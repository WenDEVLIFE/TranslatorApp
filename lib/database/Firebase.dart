import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseInstance {

  static Future<void> run() async {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyALoQV2gPP-mYfksGP1uMmC9N4dRUTPbXg',
        appId: '1:49243635699:android:df6cedc02cc9c799b79c86',
        messagingSenderId: '49243635699',
        projectId: 'mandtransapp',
        storageBucket: 'mandtransapp.firebasestorage.app',  // Add this line
      ),
    );

    if (Firebase.apps.isEmpty) {
      Fluttertoast.showToast(msg: "Failed to connect to database", backgroundColor: Colors.red);
    } else {
      Fluttertoast.showToast(msg: "Connected to database", backgroundColor: Colors.green);
    }
  }

}