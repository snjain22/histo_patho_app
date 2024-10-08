import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:histo_patho_app/screens/quiz/participant_response_screen.dart';

class QuizCreationScreen extends StatefulWidget {
  final String? quizId;
  final String teacherId;
  final bool isAdmin;

  QuizCreationScreen({this.quizId, required this.teacherId, this.isAdmin = false});

  @override
  _QuizCreationScreenState createState() => _QuizCreationScreenState();
}

class _QuizCreationScreenState extends State<QuizCreationScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  bool _instantResults = false;
  List<Map<String, dynamic>> _questions = [];
  bool _isLoading = true;
  bool _quizAttempted = false;
  bool _isTimed = true;

  @override
  void initState() {
    super.initState();
    _loadQuizData();
  }

  Future<void> _loadQuizData() async {
    setState(() {
      _isLoading = true;
    });
    if (widget.quizId != null) {
      try {
        DocumentSnapshot quizDoc = await FirebaseFirestore.instance
            .collection('quizzes')
            .doc(widget.teacherId)
            .collection('quizzes')
            .doc(widget.quizId)
            .get();
        if (quizDoc.exists) {
          Map<String, dynamic> quizData = quizDoc.data() as Map<String, dynamic>;
          setState(() {
            _titleController.text = quizData['title'];
            _descriptionController.text = quizData['description'] ?? '';
            _isTimed = quizData['isTimed'] ?? true;
            if (_isTimed) {
              _durationController.text = quizData['duration'].toString();
            }
            _instantResults = quizData['instantResults'] ?? false;
            _questions = List<Map<String, dynamic>>.from(quizData['questions']);
          });
          // Check if any students have attempted the quiz
          QuerySnapshot participantsSnapshot = await FirebaseFirestore.instance
              .collection('quizzes')
              .doc(widget.teacherId)
              .collection('quizzes')
              .doc(widget.quizId)
              .collection('participants')
              .limit(1)
              .get();
          setState(() {
            _quizAttempted = participantsSnapshot.docs.isNotEmpty;
          });
        }
      } catch (e) {
        print('Error loading quiz data: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading quiz data')),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _addQuestion() {
    if (_quizAttempted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot add new questions as students have already attempted this quiz')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController questionController = TextEditingController();
        TextEditingController correctAnswerController = TextEditingController();
        List<TextEditingController> optionControllers = List.generate(4, (i) => TextEditingController());
        return AlertDialog(
          title: Text('Add Question'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: questionController,
                  decoration: InputDecoration(labelText: 'Question'),
                ),
                ...optionControllers.map((controller) => TextField(
                  controller: controller,
                  decoration: InputDecoration(labelText: 'Option'),
                )).toList(),
                TextField(
                  controller: correctAnswerController,
                  decoration: InputDecoration(labelText: 'Correct Answer'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                setState(() {
                  _questions.add({
                    'text': questionController.text,
                    'options': optionControllers.map((c) => c.text).toList(),
                    'correctAnswer': correctAnswerController.text,
                  });
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _editQuestion(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController questionController = TextEditingController(text: _questions[index]['text']);
        List<TextEditingController> optionControllers = List.generate(
          _questions[index]['options'].length,
              (i) => TextEditingController(text: _questions[index]['options'][i]),
        );
        String correctAnswer = _questions[index]['correctAnswer'];
        return AlertDialog(
          title: Text(_quizAttempted ? 'Edit Correct Answer' : 'Edit Question'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                if (!_quizAttempted) ...[
                  TextField(
                    controller: questionController,
                    decoration: InputDecoration(labelText: 'Question'),
                  ),
                  ...optionControllers.map((controller) => TextField(
                    controller: controller,
                    decoration: InputDecoration(labelText: 'Option'),
                  )).toList(),
                ],
                DropdownButtonFormField<String>(
                  value: correctAnswer,
                  decoration: InputDecoration(labelText: 'Correct Answer'),
                  items: _questions[index]['options'].map<DropdownMenuItem<String>>((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      correctAnswer = newValue;
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                setState(() {
                  if (!_quizAttempted) {
                    _questions[index]['text'] = questionController.text;
                    _questions[index]['options'] = optionControllers.map((c) => c.text).toList();
                  }
                  _questions[index]['correctAnswer'] = correctAnswer;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateScores(BuildContext context) async {
    try {
      QuerySnapshot participantsSnapshot = await FirebaseFirestore.instance
          .collection('quizzes')
          .doc(widget.teacherId)
          .collection('quizzes')
          .doc(widget.quizId)
          .collection('participants')
          .get();
      for (var participantDoc in participantsSnapshot.docs) {
        await ParticipantResponseScreen(
          quizId: widget.quizId!,
          teacherId: widget.teacherId,
          userId: participantDoc.id,
          instantResults: _instantResults,
          isTeacherOrAdmin: true,
        ).recalculateScore(context);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All participant scores updated')),
      );
    } catch (e) {
      print('Error updating scores: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating participant scores')),
      );
    }
  }

  void _saveQuiz() async {
    try {
      final quizData = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'isTimed': _isTimed,
        'duration': _isTimed ? int.parse(_durationController.text) : null,
        'instantResults': _instantResults,
        'questions': _questions,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      if (widget.quizId == null) {
        // Creating a new quiz
        quizData['code'] = DateTime.now().millisecondsSinceEpoch.toString().substring(7);
        quizData['isEnabled'] = true;
        quizData['createdBy'] = widget.teacherId;
        quizData['createdAt'] = FieldValue.serverTimestamp();
        DocumentReference quizRef = await FirebaseFirestore.instance
            .collection('quizzes')
            .doc(widget.teacherId)
            .collection('quizzes')
            .add(quizData);
        // Add the quiz code mapping
        await FirebaseFirestore.instance.collection('quiz_codes').doc(quizData['code'] as String).set({
          'quizId': quizRef.id,
          'teacherId': widget.teacherId,
        });
      } else {
        // Updating an existing quiz
        await FirebaseFirestore.instance
            .collection('quizzes')
            .doc(widget.teacherId)
            .collection('quizzes')
            .doc(widget.quizId)
            .update(quizData);
        if (_quizAttempted) {
          await _updateScores(context);
        }
      }
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Quiz saved successfully')),
      );
    } catch (e) {
      print('Error saving quiz: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving quiz')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Loading Quiz')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.quizId == null ? 'Create Quiz' : 'Edit Quiz')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Quiz Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Quiz Description'),
            ),
            SwitchListTile(
              title: Text('Timed Quiz'),
              value: _isTimed,
              onChanged: (value) {
                setState(() {
                  _isTimed = value;
                });
              },
            ),
            if (_isTimed)
              TextField(
                controller: _durationController,
                decoration: InputDecoration(labelText: 'Duration (minutes)'),
                keyboardType: TextInputType.number,
              ),
            SwitchListTile(
              title: Text('Instant Results'),
              value: _instantResults,
              onChanged: (value) {
                setState(() {
                  _instantResults = value;
                });
              },
            ),
            SizedBox(height: 20),
            Text('Questions:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_questions[index]['text']),
                  subtitle: Text('Correct Answer: ${_questions[index]['correctAnswer']}'),
                  onTap: () => _editQuestion(index),
                );
              },
            ),
            if (!_quizAttempted)
              ElevatedButton(
                child: Text('Add Question'),
                onPressed: _addQuestion,
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: _saveQuiz,
      ),
    );
  }
}