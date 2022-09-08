import '/screens/authenticate/log_in.dart';
import '/screens/authenticate/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/status.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    bool isSignIn = context.watch<AuthStatus>().isSignIn;
    if (isSignIn) {
      return const LogIn();
    } else {
      return const SignUp();
    }
  }
}
