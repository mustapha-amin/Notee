import 'package:notes/providers/firestore_provider.dart';
import 'package:notes/screens/authenticate/verify_email.dart';
import '/screens/authenticate/authenticate.dart';
import '/screens/home/home.dart';
import '/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthService _auth = AuthService();
    var provider = Provider.of<FireStoreProvider>(context);
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: _auth.authChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var uid = _auth.currentUser!.uid;
            provider.updateUid(uid);
            return const VerifyEmail();
          } else {
            return const Authenticate();
          }
        },
      ),
    );
  }
}
