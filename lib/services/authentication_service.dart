import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

// Models
import '../models/custom_user.dart';

class AuthenticationService {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  User get currentUser {
    User currentUser = _firebaseAuth.currentUser;

    return currentUser;
  }

  Future<List<CustomUser>> getUsers() async {
    List<CustomUser> users = [];

    var result = await _firestore.collection('users').get();
    result.docs.forEach((userMap) {
      var user = CustomUser().unmapUser(userMap.data());
      users.add(user);
    });

    return users;
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

    await _firestore.collection('users').doc(result.user.uid).set({
      'userId': result.user.uid,
      'name': name,
      'teamNumber': teamNumber,
      'email': email,
      'photoUrl': result.user.photoURL,
      'createdDate': DateTime.now().toString(),
    });
  }

  Future<void> updateCurrentUserProfilePicture(File image) async {
    Reference ref = _storage.ref().child(
          'profile_photos/${DateTime.now().toIso8601String()}${currentUser.uid}',
        );

    UploadTask uploadTask = ref.putFile(image);
    uploadTask.then((res) async {
      await currentUser.updateProfile(
        photoURL: await res.ref.getDownloadURL(),
      );

      await _firestore.collection('users').doc(currentUser.uid).update({
        'photoUrl': currentUser.photoURL,
      });
    });
  }

  Future<void> logout() async {
    return await _firebaseAuth.signOut();
  }
}
