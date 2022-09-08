import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notes/main.dart';
import 'package:notes/services/auth.dart';

import '../../helper_widgets/spacings.dart';
import 'authenticate.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);
  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  AuthService _auth = AuthService();
  var message = "A verification email has been sent";
  bool isEmailVerified = false;
  Timer? timer;

  Future checkEmailVerified() async {
    await _auth.currentUser!.reload();
    setState(() {
      isEmailVerified = _auth.currentUser!.emailVerified;
    });
    if (isEmailVerified) {
      timer!.cancel();
    }
  }

  @override
  void initState() {
    isEmailVerified = _auth.currentUser!.emailVerified;
    if (!isEmailVerified) {
      _auth.sendVerificationEmail();
      timer = Timer.periodic(Duration(seconds: 3), (_) {
        checkEmailVerified();
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerified
        ? Home()
        : Scaffold(
            backgroundColor: Colors.grey[800],
            appBar: AppBar(
              title: const Text("verify email"),
            ),
            body: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(message, style: const TextStyle(color: Colors.white)),
                  addVerticalSpace(20.0),
                  ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          message = "Waiting for response...";
                        });
                        _auth.sendVerificationEmail().whenComplete(() {
                          setState(() {
                            message = "A verification email has been sent";
                          });
                        }).onError((error, stackTrace) => ScaffoldMessenger(
                            child: SnackBar(content: Text('$error'))));
                      },
                      icon: const Icon(Icons.email),
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50)),
                      label: const Text("Resend email")),
                  TextButton(
                      onPressed: () {
                        _auth.signOut();
                      },
                      child: const Text("Log out"))
                ],
              ),
            ),
          );
  }
}
