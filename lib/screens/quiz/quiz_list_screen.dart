import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:histo_patho_app/screens/quiz/quiz_screen.dart';
import 'package:histo_patho_app/screens/quiz/participant_response_screen.dart';

class QuizListScreen extends StatefulWidget {
  @override
  _QuizListScreenState createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  final TextEditingController _codeController = TextEditingController();
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quizzes')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _codeController,
                    decoration: InputDecoration(
                      labelText: 'Enter Quiz Code',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  child: Text('Start Quiz'),
                  onPressed: () => _findAndStartQuiz(context, _codeController.text.trim()),
                ),
              ],
            ),
          ),
          Divider(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('user_quizzes')
                  .doc(userId)
                  .collection('quizzes')
                  .orderBy('lastAttemptDate', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No past quizzes.'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var quizData = snapshot.data!.docs[index].data() as Map<String, dynamic>;

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('quizzes')
                          .doc(quizData['teacherId'])
                          .collection('quizzes')
                          .doc(quizData['quizId'])
                          .get(),
                      builder: (context, quizSnapshot) {
                        if (quizSnapshot.connectionState == ConnectionState.waiting) {
                          return ListTile(title: Text(quizData['title']), subtitle: Text('Loading...'));
                        }

                        bool instantResults = false;
                        if (quizSnapshot.hasData && quizSnapshot.data!.exists) {
                          var fullQuizData = quizSnapshot.data!.data() as Map<String, dynamic>;
                          instantResults = fullQuizData['instantResults'] ?? false;
                        }

                        return ListTile(
                          title: Text(quizData['title']),
                          subtitle: Text(instantResults
                              ? 'Score: ${quizData['score']}/${quizData['totalQuestions']} | Attempts: ${quizData['attempts']}'
                              : 'Attempts: ${quizData['attempts']} | Results pending'),
                          trailing: quizData['isCompleted']
                              ? Icon(Icons.check_circle, color: Colors.blue)
                              : Icon(Icons.play_arrow, color: Colors.green),
                          onTap: () {
                            if (!quizData['isCompleted']) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QuizScreen(
                                    quizId: quizData['quizId'],
                                    teacherId: quizData['teacherId'],
                                    quizTitle: quizData['title'],
                                  ),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ParticipantResponseScreen(
                                    quizId: quizData['quizId'],
                                    teacherId: quizData['teacherId'],
                                    userId: userId,
                                    instantResults: instantResults,
                                    isTeacherOrAdmin: false,
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _findAndStartQuiz(BuildContext context, String code) async {
    try {
      DocumentSnapshot codeDoc = await FirebaseFirestore.instance
          .collection('quiz_codes')
          .doc(code)
          .get();

      if (codeDoc.exists) {
        var codeData = codeDoc.data() as Map<String, dynamic>;
        String quizId = codeData['quizId'];
        String teacherId = codeData['teacherId'];

        DocumentSnapshot quizDoc = await FirebaseFirestore.instance
            .collection('quizzes')
            .doc(teacherId)
            .collection('quizzes')
            .doc(quizId)
            .get();

        if (quizDoc.exists) {
          var quizData = quizDoc.data() as Map<String, dynamic>;
          if (quizData['isEnabled']) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuizScreen(
                  quizId: quizId,
                  teacherId: teacherId,
                  quizTitle: quizData['title'],
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('This quiz is not available')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Quiz not found')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid quiz code')),
        );
      }
    } catch (e) {
      print('Error finding quiz: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error finding quiz. Please try again.')),
      );
    }
  }
}