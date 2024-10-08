import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:histo_patho_app/screens/quiz/participant_response_screen.dart';

class QuizParticipantsScreen extends StatelessWidget {
  final String quizId;
  final String teacherId;

  QuizParticipantsScreen({required this.quizId, required this.teacherId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz Participants'), elevation: 0),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('quizzes')
            .doc(teacherId)
            .collection('quizzes')
            .doc(quizId)
            .snapshots(),
        builder: (context, quizSnapshot) {
          if (!quizSnapshot.hasData) return Center(child: CircularProgressIndicator());

          var quizData = quizSnapshot.data!.data() as Map<String, dynamic>;
          bool instantResults = quizData['instantResults'] ?? false;

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('quizzes')
                .doc(teacherId)
                .collection('quizzes')
                .doc(quizId)
                .collection('participants')
                .snapshots(),
            builder: (context, participantsSnapshot) {
              if (!participantsSnapshot.hasData) return Center(child: CircularProgressIndicator());

              return ListView.separated(
                itemCount: participantsSnapshot.data!.docs.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  var participant = participantsSnapshot.data!.docs[index];
                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance.collection('users').doc(participant.id).get(),
                    builder: (context, userSnapshot) {
                      if (!userSnapshot.hasData) return ListTile(title: Text('Loading...'));
                      var userData = userSnapshot.data!.data() as Map<String, dynamic>?;
                      return Card(
                        elevation: 2,
                        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(userData?['username']?[0] ?? 'U'),
                          ),
                          title: Text(userData?['username'] ?? 'Unknown User', style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Score: ${participant['score']}'),
                          trailing: Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ParticipantResponseScreen(
                                  quizId: quizId,
                                  teacherId: teacherId,
                                  userId: participant.id,
                                  instantResults: instantResults,
                                  isTeacherOrAdmin: true,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}