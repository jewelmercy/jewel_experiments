//Firebase user management 

import 'package:augmont_app/components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FireBaselog {
  // For registering a new user
  Future<User?> registerUsingEmailPassword({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
    required double width,
    required double height,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      // ignore: deprecated_member_use
      await user!.updateProfile(displayName: name);
      await user.reload();
      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        errorbox(context ,'The password provided is too weak',width,height);
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        errorbox(context ,'The account already exists for that email',width,height);
      }
      else if (e.code == 'email-already-in-use')
      {
        print('This email already in use');
        errorbox(context ,'This Email Id already in use',width,height);
      }
    } catch (e) {
      print(e);
    }
    return user;
  }

  // For signing in an user (have already registered)
  Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
    required double width,
    required double height,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
         errorbox(context ,'No user found for that email',width,height);
        print('No user found for that email');
      } else if (e.code == 'wrong-password') {
        errorbox(context ,'Wrong password',width,height);
      }
    }
    return user;
  }


//Refreshing user info
  static Future<User?> refreshUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await user.reload();
    User? refreshedUser = auth.currentUser;

    return refreshedUser;
  }
}
