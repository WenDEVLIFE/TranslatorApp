import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DefaultConnector {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  // Constructor to initialize Firebase Auth and Firestore
  DefaultConnector({
    required this.auth,
    required this.firestore,
  });

  // Singleton instance of DefaultConnector
  static final DefaultConnector instance = DefaultConnector(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  );
}
