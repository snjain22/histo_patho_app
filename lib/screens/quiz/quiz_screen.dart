import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuizScreen extends StatefulWidget {
  final String quizId;
  final String teacherId;
  final String quizTitle;

  QuizScreen({required this.quizId, required this.teacherId, required this.quizTitle});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Map<String, dynamic>> _questions = [];
  int _currentQuestionIndex = 0;
  Map<String, String> _userAnswers = {};
  bool _isLoading = true;
  bool _isTimed = false;
  int _remainingTime = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadQuizData();
  }

  void _loadQuizData() async {
    try {
      DocumentSnapshot quizDoc = await FirebaseFirestore.instance
          .collection('quizzes')
          .doc(widget.teacherId)
          .collection('quizzes')
          .doc(widget.quizId)
          .get();

      if (quizDoc.exists) {
        var quizData = quizDoc.data() as Map<String, dynamic>;
        setState(() {
          _questions = List<Map<String, dynamic>>.from(quizData['questions']);
          _isTimed = quizData['isTimed'] ?? false;
          if (_isTimed) {
            _remainingTime = quizData['duration'] * 60; // Convert minutes to seconds
            _startTimer();
          }
          _isLoading = false;
        });
      } else {
        throw Exception('Quiz not found');
      }
    } catch (e) {
      print('Error loading quiz data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading quiz. Please try again.')),
      );
      Navigator.pop(context);
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _submitQuiz();
        }
      });
    });
  }

  void _submitQuiz() async {
    _timer?.cancel();
    int score = 0;
    for (var question in _questions) {
      if (_userAnswers[question['text']] == question['correctAnswer']) {
        score++;
      }
    }

    try {
      // Update quiz results
      await FirebaseFirestore.instance
          .collection('quizzes')
          .doc(widget.teacherId)
          .collection('quizzes')
          .doc(widget.quizId)
          .collection('participants')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .set({
        'score': score,
        'totalQuestions': _questions.length,
        'answers': _userAnswers,
        'completedAt': FieldValue.serverTimestamp(),
        'attempts': FieldValue.increment(1),
      }, SetOptions(merge: true));

      // Update user_quizzes collection
      await FirebaseFirestore.instance
          .collection('user_quizzes')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('quizzes')
          .doc(widget.quizId)
          .set({
        'quizId': widget.quizId,
        'teacherId': widget.teacherId,
        'title': widget.quizTitle,
        'score': score,
        'totalQuestions': _questions.length,
        'attempts': FieldValue.increment(1),
        'lastAttemptDate': FieldValue.serverTimestamp(),
        'isCompleted': true,
      }, SetOptions(merge: true));

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Quiz submitted successfully.')),
      );
    } catch (e) {
      print('Error submitting quiz: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting quiz. Please try again.')),
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
      appBar: AppBar(
        title: Text(widget.quizTitle),
        actions: [
          if (_isTimed)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text(
                  'Time: ${_remainingTime ~/ 60}:${(_remainingTime % 60).toString().padLeft(2, '0')}',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              _questions[_currentQuestionIndex]['text'],
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            ..._questions[_currentQuestionIndex]['options'].map<Widget>((option) {
              return RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: _userAnswers[_questions[_currentQuestionIndex]['text']],
                onChanged: (value) {
                  setState(() {
                    _userAnswers[_questions[_currentQuestionIndex]['text']] = value!;
                  });
                },
              );
            }).toList(),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_currentQuestionIndex > 0)
              TextButton(
                child: Text('Previous'),
                onPressed: () {
                  setState(() {
                    _currentQuestionIndex--;
                  });
                },
              ),
            if (_currentQuestionIndex < _questions.length - 1)
              TextButton(
                child: Text('Next'),
                onPressed: () {
                  setState(() {
                    _currentQuestionIndex++;
                  });
                },
              ),
            if (_currentQuestionIndex == _questions.length - 1)
              ElevatedButton(
                child: Text('Submit'),
                onPressed: _submitQuiz,
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}