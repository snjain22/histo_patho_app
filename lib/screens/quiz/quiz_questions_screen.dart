import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuizQuestionsScreen extends StatelessWidget {
  final String quizId;
  final String teacherId;
  final bool isAdmin;

  QuizQuestionsScreen({required this.quizId, required this.teacherId, this.isAdmin = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz Questions')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('quizzes')
            .doc(teacherId)
            .collection('quizzes')
            .doc(quizId)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          var quiz = snapshot.data!.data() as Map<String, dynamic>;
          var questions = List<Map<String, dynamic>>.from(quiz['questions']);
          return ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              var question = questions[index];
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ExpansionTile(
                  title: Text('Question ${index + 1}'),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(question['text'], style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          if (question['image'] != null)
                            Image.network(question['image'], height: 150, width: double.infinity, fit: BoxFit.cover),
                          SizedBox(height: 8),
                          Text('Options:', style: TextStyle(fontWeight: FontWeight.bold)),
                          ...question['options'].map((option) => ListTile(
                            title: Text(option),
                            trailing: option == question['correctAnswer']
                                ? Icon(Icons.check_circle, color: Colors.green)
                                : null,
                            tileColor: option == question['correctAnswer']
                                ? Colors.green.withOpacity(0.1)
                                : null,
                          )).toList(),
                          SizedBox(height: 8),
                          Text('Correct Answer: ${question['correctAnswer']}',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}