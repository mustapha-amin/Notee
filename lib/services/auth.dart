import 'dart:async';
import 'package:notes/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser {
    return _auth.currentUser;
  }

  Future setName(String? displayName) async {
    await _auth.currentUser!.updateDisplayName(displayName);
  }

  Stream<User?> authChanges() {
    return _auth.idTokenChanges();
  }

  // sign in anon
  Future singInAnon() async {
    try {
      UserCredential credential = await _auth.signInAnonymously();
      User user = credential.user!;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // sign in with email and pwd
  Future signInWithEmailandPassword(String email, String password) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // register with email and pwd
  Future registerWithEmailandPassword(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // send verification email
  Future sendVerificationEmail() async {
    return await _auth.currentUser!.sendEmailVerification();
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }

  Future resetPwd(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
