import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class AuthApi {
  Future<void> login({required String email, required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null && !userCredential.user!.emailVerified) {
        await FirebaseAuth.instance.signOut();
        throw Exception('Please verify your email');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('Incorrect email or password.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided.');
      } else {
        throw Exception(
          e.message ?? 'An unexpected error occurred. Please try again.',
        );
      }
    }
  }

  Future<void> signup(String name, String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        await userCredential.user!.sendEmailVerification();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('The email is already in use');
      } else {
        throw Exception(e.message ?? 'An error occurred during signup.');
      }
    } catch (e) {
      throw Exception(
        'An unexpected error occurred. Please try again. ${e.toString()}',
      );
    }
  }
}
