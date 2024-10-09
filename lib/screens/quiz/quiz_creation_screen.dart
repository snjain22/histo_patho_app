import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';


class QuizCreationScreen extends StatefulWidget {
  final String? quizId;
  final String? teacherId;
  final bool isAdmin;

  QuizCreationScreen({this.quizId, this.teacherId, this.isAdmin = false});

  @override
  _QuizCreationScreenState createState() => _QuizCreationScreenState();
}

class _QuizCreationScreenState extends State<QuizCreationScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _attemptsController = TextEditingController();
  bool _instantResults = false;
  List<Map<String, dynamic>> _questions = [];
  bool _isLoading = true;
  bool _quizAttempted = false;
  bool _isTimed = true;
  int _originalAttemptsAllowed = 1;
  String? _selectedTeacherId;
  List<Map<String, dynamic>> _teachers = [];

  @override
  void initState() {
    super.initState();
    if (widget.isAdmin) {
      _loadTeachers();
    }
    _loadQuizData();
  }

  Future<void> _loadTeachers() async {
    QuerySnapshot teacherSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('userType', isEqualTo: 'teacher')
        .get();

    setState(() {
      _teachers = teacherSnapshot.docs
          .map((doc) => {
        'id': doc.id,
        'name': (doc.data() as Map<String, dynamic>)['username'] ?? 'Unknown Teacher',
      })
          .toList();
    });
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
            _originalAttemptsAllowed = quizData['attemptsAllowed'] ?? 1;
            _attemptsController.text = _originalAttemptsAllowed.toString();
            _selectedTeacherId = widget.teacherId;
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
    } else {
      // Set default values for new quizzes
      _attemptsController.text = '1';
      _originalAttemptsAllowed = 1;
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<String?> _uploadImage(File image) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = FirebaseStorage.instance.ref().child('quiz_images/$fileName');
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
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
        String? imageUrl;
        final _formKey = GlobalKey<FormState>();

        return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text('Add Question'),
                content: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: questionController,
                          decoration: InputDecoration(labelText: 'Question'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a question';
                            }
                            return null;
                          },
                        ),
                        ...optionControllers.asMap().entries.map((entry) => TextFormField(
                          controller: entry.value,
                          decoration: InputDecoration(labelText: 'Option ${entry.key + 1}'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an option';
                            }
                            if (optionControllers.where((c) => c.text == value).length > 1) {
                              return 'Options must be distinct';
                            }
                            return null;
                          },
                        )).toList(),
                        TextFormField(
                          controller: correctAnswerController,
                          decoration: InputDecoration(labelText: 'Correct Answer'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the correct answer';
                            }
                            if (!optionControllers.map((c) => c.text).contains(value)) {
                              return 'Correct answer must be one of the options';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          child: Text('Add Image'),
                          onPressed: () async {
                            final ImagePicker _picker = ImagePicker();
                            final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                            if (image != null) {
                              String? url = await _uploadImage(File(image.path));
                              if (url != null) {
                                setState(() {
                                  imageUrl = url;
                                });
                              }
                            }
                          },
                        ),
                        if (imageUrl != null)
                          Image.network(imageUrl!, height: 100, width: 100, fit: BoxFit.contain),
                      ],
                    ),
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
                      if (_formKey.currentState!.validate()) {
                        this.setState(() {
                          _questions.add({
                            'text': questionController.text,
                            'options': optionControllers.map((c) => c.text).toList(),
                            'correctAnswer': correctAnswerController.text,
                            'imageUrl': imageUrl,
                          });
                        });
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              );
            }
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
        String? imageUrl = _questions[index]['imageUrl'];
        final _formKey = GlobalKey<FormState>();

        return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(_quizAttempted ? 'Edit Correct Answer' : 'Edit Question'),
                content: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        if (!_quizAttempted) ...[
                          TextFormField(
                            controller: questionController,
                            decoration: InputDecoration(labelText: 'Question'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a question';
                              }
                              return null;
                            },
                          ),
                          ...optionControllers.asMap().entries.map((entry) => TextFormField(
                            controller: entry.value,
                            decoration: InputDecoration(labelText: 'Option ${entry.key + 1}'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an option';
                              }
                              if (optionControllers.where((c) => c.text == value).length > 1) {
                                return 'Options must be distinct';
                              }
                              return null;
                            },
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select the correct answer';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          child: Text(imageUrl == null ? 'Add Image' : 'Change Image'),
                          onPressed: () async {
                            final ImagePicker _picker = ImagePicker();
                            final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                            if (image != null) {
                              String? url = await _uploadImage(File(image.path));
                              if (url != null) {
                                setState(() {
                                  imageUrl = url;
                                });
                              }
                            }
                          },
                        ),
                        if (imageUrl != null)
                          Image.network(imageUrl!, height: 100, width: 100, fit: BoxFit.contain),
                      ],
                    ),
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
                      if (_formKey.currentState!.validate()) {
                        this.setState(() {
                          if (!_quizAttempted) {
                            _questions[index]['text'] = questionController.text;
                            _questions[index]['options'] = optionControllers.map((c) => c.text).toList();
                          }
                          _questions[index]['correctAnswer'] = correctAnswer;
                          _questions[index]['imageUrl'] = imageUrl;
                        });
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              );
            }
        );
      },
    );
  }

  Future<void> _updateScores(BuildContext context) async {
    try {
      String teacherId = widget.isAdmin ? _selectedTeacherId! : widget.teacherId!;

      QuerySnapshot participantsSnapshot = await FirebaseFirestore.instance
          .collection('quizzes')
          .doc(teacherId)
          .collection('quizzes')
          .doc(widget.quizId)
          .collection('participants')
          .get();

      int totalUpdated = 0;
      int totalParticipants = participantsSnapshot.docs.length;

      for (var participantDoc in participantsSnapshot.docs) {
        bool success = await _recalculateScore(
          quizId: widget.quizId!,
          teacherId: teacherId,
          userId: participantDoc.id,
        );
        if (success) totalUpdated++;
      }

      if (totalUpdated == totalParticipants) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('All participant scores updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Updated $totalUpdated out of $totalParticipants participant scores')),
        );
      }
    } catch (e) {
      print('Error updating scores: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating participant scores')),
      );
    }
  }

  Future<bool> _recalculateScore({
    required String quizId,
    required String teacherId,
    required String userId,
  }) async {
    try {
      // Fetch the quiz data
      DocumentSnapshot quizDoc = await FirebaseFirestore.instance
          .collection('quizzes')
          .doc(teacherId)
          .collection('quizzes')
          .doc(quizId)
          .get();

      var quizData = quizDoc.data() as Map<String, dynamic>;
      var questions = quizData['questions'] as List<dynamic>;

      // Fetch the participant's answers
      DocumentSnapshot participantDoc = await FirebaseFirestore.instance
          .collection('quizzes')
          .doc(teacherId)
          .collection('quizzes')
          .doc(quizId)
          .collection('participants')
          .doc(userId)
          .get();

      var participantData = participantDoc.data() as Map<String, dynamic>;
      var answers = participantData['answers'] as Map<String, dynamic>;

      // Recalculate the score
      int newScore = 0;
      for (var question in questions) {
        String userAnswer = answers[question['text']] ?? '';
        if (userAnswer == question['correctAnswer']) {
          newScore++;
        }
      }

      // Update the participant's score
      await FirebaseFirestore.instance
          .collection('quizzes')
          .doc(teacherId)
          .collection('quizzes')
          .doc(quizId)
          .collection('participants')
          .doc(userId)
          .update({'score': newScore});

      // Update the user's quiz data
      await FirebaseFirestore.instance
          .collection('user_quizzes')
          .doc(userId)
          .collection('quizzes')
          .doc(quizId)
          .update({'score': newScore});

      return true;
    } catch (e) {
      print('Error recalculating score for user $userId: $e');
      return false;
    }
  }

  void _saveQuiz() async {
    if (widget.isAdmin && _selectedTeacherId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a teacher')),
      );
      return;
    }

    try {
      String teacherId = widget.isAdmin ? _selectedTeacherId! : widget.teacherId!;

      // Fetch the teacher's name
      DocumentSnapshot teacherDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(teacherId)
          .get();

      String teacherName = 'Unknown Teacher';
      if (teacherDoc.exists) {
        Map<String, dynamic> teacherData = teacherDoc.data() as Map<String, dynamic>;
        teacherName = teacherData['username'] ?? teacherData['name'] ?? 'Unknown Teacher';
      }

      int newAttemptsAllowed = int.parse(_attemptsController.text);
      if (newAttemptsAllowed < _originalAttemptsAllowed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cannot reduce the number of attempts allowed')),
        );
        return;
      }

      final quizData = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'isTimed': _isTimed,
        'duration': _isTimed ? int.parse(_durationController.text) : null,
        'instantResults': _instantResults,
        'questions': _questions,
        'updatedAt': FieldValue.serverTimestamp(),
        'attemptsAllowed': newAttemptsAllowed,
      };

      if (widget.quizId == null) {
        // Creating a new quiz
        quizData['code'] = DateTime.now().millisecondsSinceEpoch.toString().substring(7);
        quizData['isEnabled'] = true;
        quizData['createdBy'] = teacherId;
        quizData['createdByName'] = teacherName;
        quizData['createdAt'] = FieldValue.serverTimestamp();
        DocumentReference quizRef = await FirebaseFirestore.instance
            .collection('quizzes')
            .doc(teacherId)
            .collection('quizzes')
            .add(quizData);
        // Add the quiz code mapping
        await FirebaseFirestore.instance.collection('quiz_codes').doc(quizData['code'] as String).set({
          'quizId': quizRef.id,
          'teacherId': teacherId,
        });
      } else {
        // Updating an existing quiz
        await FirebaseFirestore.instance
            .collection('quizzes')
            .doc(teacherId)
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
            if (widget.isAdmin && _teachers.isNotEmpty)
              DropdownButtonFormField<String>(
                value: _selectedTeacherId,
                decoration: InputDecoration(labelText: 'Select Teacher'),
                items: _teachers.map((teacher) {
                  return DropdownMenuItem<String>(
                    value: teacher['id'],
                    child: Text(teacher['name']),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedTeacherId = newValue;
                  });
                },
              ),
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
            TextField(
              controller: _attemptsController,
              decoration: InputDecoration(labelText: 'Number of Attempts Allowed'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                int? newValue = int.tryParse(value);
                if (newValue != null && newValue < _originalAttemptsAllowed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Cannot reduce the number of attempts allowed')),
                  );
                  _attemptsController.text = _originalAttemptsAllowed.toString();
                }
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
                  leading: _questions[index]['imageUrl'] != null
                      ? Image.network(_questions[index]['imageUrl']!, width: 50, height: 50, fit: BoxFit.cover)
                      : null,
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
