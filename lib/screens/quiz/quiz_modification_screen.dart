import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizModificationScreen extends StatefulWidget {
  final String quizId;

  QuizModificationScreen({required this.quizId});

  @override
  _QuizModificationScreenState createState() => _QuizModificationScreenState();
}

class _QuizModificationScreenState extends State<QuizModificationScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  bool _instantResults = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _loadQuizData();
  }

  void _loadQuizData() async {
    var quizDoc = await FirebaseFirestore.instance.collection('quizzes').doc(widget.quizId).get();
    setState(() {
      _titleController.text = quizDoc['title'];
      _descriptionController.text = quizDoc['description'] ?? '_${_titleController.text}_' ;
      _instantResults = quizDoc['instantResults'];
    });
  }

  void _saveQuiz() async {
    await FirebaseFirestore.instance.collection('quizzes').doc(widget.quizId).update({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'instantResults': _instantResults,
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Modify Quiz')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
              title: Text('Instant Results'),
              value: _instantResults,
              onChanged: (value) {
                setState(() {
                  _instantResults = value;
                });
              },
            ),
            ElevatedButton(
              child: Text('Save Changes'),
              onPressed: _saveQuiz,
            ),
            ElevatedButton(
              child: Text('Modify Questions'),
              onPressed: () {
                // Navigate to a screen for modifying questions
                // Implement this screen based on your requirements
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}