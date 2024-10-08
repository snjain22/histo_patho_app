import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:histo_patho_app/screens/quiz/quiz_creation_screen.dart';
import 'package:histo_patho_app/screens/quiz/quiz_details_screen.dart';

class QuizManagementScreen extends StatelessWidget {
  final bool isAdmin;

  QuizManagementScreen({this.isAdmin = false});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Quizzes'),
        elevation: 0,
      ),
      body: isAdmin ? _buildAdminView() : _buildTeacherView(currentUserId),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text('Create Quiz'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QuizCreationScreen(
                teacherId: isAdmin ? '' : currentUserId,
                isAdmin: isAdmin
            )),
          );
        },
      ),
    );
  }

  Widget _buildTeacherView(String teacherId) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('quizzes')
          .doc(teacherId)
          .collection('quizzes')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
        if (snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No quizzes available. Create one!'));
        }
        return ListView.separated(
          itemCount: snapshot.data!.docs.length,
          separatorBuilder: (context, index) => Divider(height: 1),
          itemBuilder: (context, index) {
            var quiz = snapshot.data!.docs[index];
            return Card(
              elevation: 2,
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                title: Text(quiz['title'], style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Code: ${quiz['code']}'),
                    Text('Status: ${quiz['isEnabled'] ? 'Enabled' : 'Disabled'}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Switch(
                      value: quiz['isEnabled'],
                      onChanged: (value) {
                        FirebaseFirestore.instance
                            .collection('quizzes')
                            .doc(teacherId)
                            .collection('quizzes')
                            .doc(quiz.id)
                            .update({'isEnabled': value});
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizCreationScreen(
                              quizId: quiz.id,
                              teacherId: teacherId,
                              isAdmin: false,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizDetailsScreen(quizId: quiz.id, teacherId: teacherId),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAdminView() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').where('userType', isEqualTo: 'teacher').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> teacherSnapshot) {
        if (!teacherSnapshot.hasData) return Center(child: CircularProgressIndicator());
        if (teacherSnapshot.data!.docs.isEmpty) {
          return Center(child: Text('No teachers available.'));
        }
        return ListView.builder(
          itemCount: teacherSnapshot.data!.docs.length,
          itemBuilder: (context, teacherIndex) {
            var teacher = teacherSnapshot.data!.docs[teacherIndex];
            return ExpansionTile(
              title: Text('${teacher['username']} (${teacher['email']})', style: TextStyle(fontWeight: FontWeight.bold)),
              children: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('quizzes')
                      .doc(teacher.id)
                      .collection('quizzes')
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> quizSnapshot) {
                    if (!quizSnapshot.hasData) return Center(child: CircularProgressIndicator());
                    if (quizSnapshot.data!.docs.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('No quizzes available for this teacher.'),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: quizSnapshot.data!.docs.length,
                      itemBuilder: (context, quizIndex) {
                        var quiz = quizSnapshot.data!.docs[quizIndex];
                        return Card(
                          elevation: 1,
                          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: ListTile(
                            title: Text(quiz['title'], style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Code: ${quiz['code']}'),
                                Text('Status: ${quiz['isEnabled'] ? 'Enabled' : 'Disabled'}'),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Switch(
                                  value: quiz['isEnabled'],
                                  onChanged: (value) {
                                    FirebaseFirestore.instance
                                        .collection('quizzes')
                                        .doc(teacher.id)
                                        .collection('quizzes')
                                        .doc(quiz.id)
                                        .update({'isEnabled': value});
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => QuizCreationScreen(
                                          quizId: quiz.id,
                                          teacherId: teacher.id,
                                          isAdmin: true,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QuizDetailsScreen(
                                    quizId: quiz.id,
                                    teacherId: teacher.id,
                                    isAdmin: true,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}