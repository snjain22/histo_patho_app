import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:histo_patho_app/screens/home_screen.dart';

class LogoutPage extends StatefulWidget {
  @override
  _LogoutPageState createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  @override
  void initState() {
    super.initState();
    _logout();
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    await Future.delayed(Duration(seconds: 2)); // Show logout message for 2 seconds
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => HomeScreen()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.check_circle, color: Colors.green, size: 100),
            SizedBox(height: 20),
            Text(
              'Successfully Logged Out',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}