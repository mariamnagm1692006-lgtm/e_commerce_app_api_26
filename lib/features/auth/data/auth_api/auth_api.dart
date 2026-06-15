import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class AuthApi {
  Future<void> login({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.');
      } else {
        throw Exception(
          e.message ?? 'An unexpected error occurred. Please try again.',
        );
      }
    }
  }

  Future<void> signup(String name, String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
      }
    } catch (e) {
      throw Exception(
        'An unexpected error occurred. Please try again. ${e.toString()}',
      );
    }
  }
}
