
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:histo_patho_app/reusable_widgets/reusable_widget.dart';
import 'package:histo_patho_app/screens/home_screen.dart';
import 'package:histo_patho_app/unused/color_utils.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  TextEditingController _NameTextController = TextEditingController();

  String _selectedUserType = 'student';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            hexStringToColor("CB2B93"),
            hexStringToColor("9546C4"),
            hexStringToColor("5E61F4")
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20),
                reusableTextField("Enter Name", Icons.person_2_outlined, false,
                    _userNameTextController),
                const SizedBox(height: 20),
                reusableTextField("Enter UserName", Icons.person_3_outlined, false,
                    _NameTextController),
                const SizedBox(height: 20),
                reusableTextField("Enter Email Id", Icons.person_outline, false,
                    _emailTextController),
                const SizedBox(height: 20),
                reusableTextField("Enter Password", Icons.lock_outlined, true,
                    _passwordTextController),
                // const SizedBox(height: 20),
                // // Add dropdown for user type selection
                // Container(
                //   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(30),
                //     color: Colors.white.withOpacity(0.3),
                //   ),
                //   child: DropdownButtonHideUnderline(
                //     child: DropdownButton<String>(
                //       value: _selectedUserType,
                //       dropdownColor: Colors.purple.withOpacity(0.9),
                //       style: TextStyle(color: Colors.white),
                //       items: <String>['student', 'teacher'].map((String value) {
                //         return DropdownMenuItem<String>(
                //           value: value,
                //           child: Text(
                //             value.capitalize(),
                //             style: TextStyle(color: Colors.white),
                //           ),
                //         );
                //       }).toList(),
                //       onChanged: (String? newValue) {
                //         setState(() {
                //           _selectedUserType = newValue!;
                //         });
                //       },
                //       icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                //       isExpanded: true,
                //     ),
                //   ),
                // ),
                const SizedBox(height: 20),

                firebaseUIButton(context, "Sign Up", () {
                  String userType = _selectedUserType;
                  if (["sambhavjain1404@gmail.com", "hardikgarg717@gmail.com"]
                      .contains(_emailTextController.text.toLowerCase())){

                    print("In If Condition");
                    userType = 'admin';
                  }
                  else if (['dsouzaanne4@gmail.com', 'prabhuswathi15@gmail.com']
                      .contains(_emailTextController.text.toLowerCase())){
                    print("NOW IN ELSE IF");
                    userType = 'teacher';
                  }
                  else{
                    print("ELSE STUDENT EHEHEH");
                    userType = 'student';
                  }
                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                      email: _emailTextController.text,
                      password: _passwordTextController.text)
                      .then((value) {
                    // Create user document in Firestore

                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(value.user!.uid)
                        .set({
                      'name': _NameTextController.text,
                      'username': _userNameTextController.text,
                      'email': _emailTextController.text.toLowerCase(),
                      'userType': userType,
                      'createdAt': FieldValue.serverTimestamp(),
                    });

                    print("Created New Account");
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  }).onError((error, stackTrace) {
                    print("Error ${error.toString()}");
                  });
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> createUserProfile(String uid, String username, String email) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'username': username,
      'email': email,
      'uid': uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
