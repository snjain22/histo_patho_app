import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:histo_patho_app/screens/dashboard.dart';
import 'package:histo_patho_app/screens/home_screen.dart';
import 'package:histo_patho_app/screens/imagescreen.dart';
import 'package:histo_patho_app/screens/signup_screen.dart';
import '../reusable_widgets/reusable_widget.dart';
import '../unused/color_utils.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/background-2.png"),
        fit: BoxFit.cover,
        )

      ),
    child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Sign In",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.1, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Logo at the top
                Image.asset(
                  'assets/images/SNJ.jpg', // Replace with your logo asset
                  height: 100,
                ),
                const SizedBox(
                  height: 100,
                ),
                // Welcome Text
                const Text(
                  "Welcome to HistoPath!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                // Email TextField
                reusableTextField(
                  "Enter Email",
                  Icons.verified_user,
                  false,
                  _emailTextController,
                ),
                const SizedBox(
                  height: 20,
                ),
                // Password TextField
                reusableTextField(
                  "Enter Password",
                  Icons.lock_outline,
                  true,
                  _passwordTextController,
                ),
                const SizedBox(
                  height: 20,
                ),
                // Sign In Button
                signInSignUpButton(context, true, () async {
                  try {
                    UserCredential userCredential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                      email: _emailTextController.text,
                      password: _passwordTextController.text,
                    );

                    // Fetch user profile
                    DocumentSnapshot userProfile = await FirebaseFirestore.instance
                        .collection('users')
                        .doc(userCredential.user!.uid)
                        .get();

                    if (userProfile.exists) {
                      // User profile exists, navigate to dashboard
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DashBoardPage()),
                      );
                    } else {
                      // Handle case where user profile doesn't exist
                      print("User profile not found");
                    }
                  } catch (error) {
                    print("ERROR ${error.toString()}");
                    // Show error message to user
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error: ${error.toString()}")),
                    );
                  }
                }),
                const SizedBox(
                  height: 20,
                ),
                // Sign Up Option
                signUpOption(),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}