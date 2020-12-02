import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthenticationService {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User getUser() {
    User currentUser = _firebaseAuth.currentUser;

    return currentUser;
  }

  Future<void> login(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signup(
    String name,
    int teamNumber,
    String email,
    String password,
  ) async {
    UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    result.user.updateProfile(
      displayName: name,
    );

    await _firestore.collection('users').add({
      'userId': result.user.uid,
      'name': name,
      'teamNumber': teamNumber,
      'email': email,
      'createdDate': DateTime.now().toString(),
    });
  }

  Future<void> logout() async {
    return await _firebaseAuth.signOut();
  }
}
