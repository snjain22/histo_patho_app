import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:histo_patho_app/screens/quiz/quiz_creation_screen.dart';
import 'package:histo_patho_app/screens/quiz/quiz_questions_screen.dart';
import 'package:histo_patho_app/screens/quiz/quiz_participants_screen.dart';

class QuizDetailsScreen extends StatelessWidget {
  final String quizId;
  final String teacherId;
  final bool isAdmin;

  QuizDetailsScreen({required this.quizId, required this.teacherId, this.isAdmin = false});

  Future<void> _deleteQuiz(BuildContext context) async {
    // Show a confirmation dialog
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Quiz'),
          content: Text('Are you sure you want to delete this quiz? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      // Navigate back to the previous screen immediately
      Navigator.of(context).pop();

      // Show a "deleting" message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Deleting quiz...')),
      );

      try {
        // Get the quiz document to retrieve the code
        DocumentSnapshot quizDoc = await FirebaseFirestore.instance
            .collection('quizzes')
            .doc(teacherId)
            .collection('quizzes')
            .doc(quizId)
            .get();

        String quizCode = (quizDoc.data() as Map<String, dynamic>)['code'];

        // Get all participants who have attempted this quiz
        QuerySnapshot participantsSnapshot = await FirebaseFirestore.instance
            .collection('quizzes')
            .doc(teacherId)
            .collection('quizzes')
            .doc(quizId)
            .collection('participants')
            .get();

        // Delete the quiz from user_quizzes for all participants
        List<Future> userQuizDeletions = participantsSnapshot.docs.map((participantDoc) {
          return FirebaseFirestore.instance
              .collection('user_quizzes')
              .doc(participantDoc.id)
              .collection('quizzes')
              .doc(quizId)
              .delete();
        }).toList();

        // Wait for all user_quizzes deletions to complete
        await Future.wait(userQuizDeletions);

        // Delete the quiz document
        await FirebaseFirestore.instance
            .collection('quizzes')
            .doc(teacherId)
            .collection('quizzes')
            .doc(quizId)
            .delete();

        // Delete the quiz code mapping
        await FirebaseFirestore.instance
            .collection('quiz_codes')
            .doc(quizCode)
            .delete();

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Quiz deleted successfully')),
        );
      } catch (e) {
        print('Error deleting quiz: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting quiz')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz Details'), elevation: 0),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('quizzes')
            .doc(teacherId)
            .collection('quizzes')
            .doc(quizId)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          var quiz = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 4,
                  margin: EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${quiz['title']}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text('Created By: ${quiz['createdByName']}'),
                        Text('Date Created: ${quiz['createdAt'].toDate().toString()}'),
                        Text('Access Code: ${quiz['code']}', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Instant Results: ${quiz['instantResults'] ? 'Yes' : 'No'}'),
                        Text('Attempts Allowed: ${quiz['attemptsAllowed']}'),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 16),
                      _buildActionButton(
                        context: context,
                        icon: Icons.question_answer,
                        label: 'View Questions',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizQuestionsScreen(quizId: quizId, teacherId: teacherId),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 8),
                      _buildActionButton(
                        context: context,
                        icon: Icons.people,
                        label: 'View Participants',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizParticipantsScreen(quizId: quizId, teacherId: teacherId),
                            ),
                          );
                        },
                      ),
                      if (isAdmin || FirebaseAuth.instance.currentUser!.uid == teacherId) ...[
                        SizedBox(height: 8),
                        _buildActionButton(
                          context: context,
                          icon: Icons.edit,
                          label: 'Modify Quiz',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuizCreationScreen(quizId: quizId, teacherId: teacherId, isAdmin: isAdmin),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 16),
                        Card(
                          child: SwitchListTile(
                            title: Text('Enable Quiz'),
                            value: quiz['isEnabled'],
                            onChanged: (bool value) {
                              FirebaseFirestore.instance
                                  .collection('quizzes')
                                  .doc(teacherId)
                                  .collection('quizzes')
                                  .doc(quizId)
                                  .update({'isEnabled': value});
                            },
                          ),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton.icon(
                          icon: Icon(Icons.delete, color: Color.fromRGBO(255, 255, 255, 1.0),),
                          label: Text('Delete Quiz', style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1.0))),
                          onPressed: () => _deleteQuiz(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[900],
                            padding: EdgeInsets.symmetric(vertical: 12),
                            textStyle: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 12),
        textStyle: TextStyle(fontSize: 16),
      ),
    );
  }
}