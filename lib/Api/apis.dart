import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:your_friend/models/chat_users.dart';

class APIs {
  // For Authentication in app
  static FirebaseAuth auth = FirebaseAuth.instance;

  // For accessing cloud Firestore databases
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // to return current user
  static User get user => auth.currentUser!;

  // for checking if user exist or not?
  static Future<bool> userExists() async {
    return (await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
  }

  // for creating new users
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = ChatUser(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      image: user.photoURL.toString(),
      about: "Hey, I am Visible!",
      createdAt: time,
      isOnline: false,
      lastActive: time,
      pushToken: '',
    );
    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }
}
