import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

Future<void> setupFirebaseForTesting() async {
  if (Platform.isAndroid) {
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    FirebaseFirestore.instance.useFirestoreEmulator('10.0.2.2', 8080);
  } else if (Platform.isIOS) {
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  }

  FirebaseAuth.instance.setSettings(appVerificationDisabledForTesting: true);
}