import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ParticipantResponseScreen extends StatelessWidget {
  final String quizId;
  final String teacherId;
  final String userId;
  final bool instantResults;
  final bool isTeacherOrAdmin;

  ParticipantResponseScreen._({
    required this.quizId,
    required this.teacherId,
    required this.userId,
    required this.instantResults,
    required this.isTeacherOrAdmin,
  });

  factory ParticipantResponseScreen({
    required String quizId,
    required String teacherId,
    required String userId,
    bool? instantResults,
    bool isTeacherOrAdmin = false,
  }) {
    return ParticipantResponseScreen._(
      quizId: quizId,
      teacherId: teacherId,
      userId: userId,
      instantResults: instantResults ?? false,
      isTeacherOrAdmin: isTeacherOrAdmin,
    );
  }

  Future<void> recalculateScore(BuildContext context) async {
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Score updated successfully')),
      );
    } catch (e) {
      print('Error recalculating score: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating score')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Participant Response'),
        actions: [
          if (isTeacherOrAdmin)
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () => recalculateScore(context),
            ),
        ],
      ),
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

          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('quizzes')
                .doc(teacherId)
                .collection('quizzes')
                .doc(quizId)
                .collection('participants')
                .doc(userId)
                .snapshots(),
            builder: (context, participantSnapshot) {
              if (!participantSnapshot.hasData) return Center(child: CircularProgressIndicator());

              var participantData = participantSnapshot.data!.data() as Map<String, dynamic>;

              // Recalculate score based on current quiz data
              int calculatedScore = 0;
              var questions = quizData['questions'] as List<dynamic>;
              var answers = participantData['answers'] as Map<String, dynamic>;
              for (var question in questions) {
                String userAnswer = answers[question['text']] ?? '';
                if (userAnswer == question['correctAnswer']) {
                  calculatedScore++;
                }
              }

              return SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Quiz: ${quizData['title']}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    Text('Score: $calculatedScore/${questions.length}'),
                    Text('Completed At: ${participantData['completedAt'].toDate()}'),
                    SizedBox(height: 24),
                    if (isTeacherOrAdmin || instantResults)
                      ...questions.asMap().entries.map((entry) {
                        int index = entry.key;
                        Map<String, dynamic> question = entry.value;
                        String userAnswer = answers[question['text']] ?? 'Not answered';
                        bool isCorrect = userAnswer == question['correctAnswer'];

                        return Card(
                          margin: EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Question ${index + 1}: ${question['text']}', style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 8),
                                Text('User\'s Answer: $userAnswer'),
                                Text('Correct Answer: ${question['correctAnswer']}'),
                                SizedBox(height: 8),
                                Text(
                                  isCorrect ? 'Correct' : 'Incorrect',
                                  style: TextStyle(
                                    color: isCorrect ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                    else
                      Text('Detailed results are not available yet.',
                          style: TextStyle(fontStyle: FontStyle.italic)),
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