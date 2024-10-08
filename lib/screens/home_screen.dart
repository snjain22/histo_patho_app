import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:histo_patho_app/screens/dashboard.dart';
import 'package:histo_patho_app/screens/imagescreen.dart';
import 'package:histo_patho_app/screens/login.dart';
import 'package:histo_patho_app/screens/signin_screen.dart';
import 'package:histo_patho_app/screens/signup_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // Welcome Message
                const Text(
                  "Welcome",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 20),

                // Description
                Text(
                  "Automatic identity verification which enables you to verify your identity",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 40), // Space before the image

                // Image
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/illustration.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 40), // Space before buttons

                // Buttons
                Column(
                  children: <Widget>[
                    MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>  SignInScreen()));
                      },
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
                      },
                      color: Colors.cyanAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}