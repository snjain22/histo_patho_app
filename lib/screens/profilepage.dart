import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  File? _image;
  String? _fullName;
  String? _username;
  String? _userType;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await _firestore.collection('users').doc(user.uid).get();
      setState(() {
        _fullName = userData['name'];
        _username = userData['username'];
        _userType = userData['userType'];
      });
    }
  }

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.cyan,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: _uploadImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null ? Icon(Icons.person, size: 50) : null,
              ),
            ),
            SizedBox(height: 20),
            Text(
              _fullName ?? 'Loading...',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              _username ?? 'Loading...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 10),
            Text(
              _userType ?? 'Loading...',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}