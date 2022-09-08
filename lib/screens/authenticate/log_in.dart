import 'package:notes/providers/firestore_provider.dart';

import '/helper_widgets/loading.dart';
import '/helper_widgets/spacings.dart';
import '/screens/authenticate/authenticate.dart';
import 'package:notes/screens/authenticate/log_in.dart';
import 'package:notes/screens/authenticate/sign_up.dart';
import 'package:notes/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../helper_widgets/error_widget.dart';
import '../../providers/status.dart';
import 'reset_password.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool loading = false;
  String error = '';
  bool obscureText = false;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  // String email = '';
  // String password = '';

  void passwordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              actions: [
                TextButton.icon(
                  onPressed: () {
                    context.read<AuthStatus>().toggle();
                  },
                  icon: const Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  label: const Text(
                    "Sign up",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
              backgroundColor: Colors.brown[500],
              elevation: 0,
              title: const Text("Log in"),
              centerTitle: true,
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    addVerticalSpace(30.0),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: "email",
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) =>
                          val!.isEmpty ? "Enter an email" : null,
                      controller: _emailController,
                    ),
                    addVerticalSpace(10.0),
                    TextFormField(
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        filled: true,
                        hintText: "password",
                        fillColor: Colors.white,
                        suffixIcon: GestureDetector(
                          onTap: passwordVisibility,
                          child: Icon(
                            obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      obscureText: obscureText,
                      validator: (val) =>
                          val!.length < 6 ? "Enter your password" : null,
                      controller: _passwordController,
                    ),
                    addVerticalSpace(50.0),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                          });
                          var email = _emailController.text;
                          var password = _passwordController.text;
                          try {
                            await _auth
                                .signInWithEmailandPassword(
                              email,
                              password,
                            ).whenComplete(() {
                              setState(() {
                                loading = false;
                              });
                            });
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              setState(() {
                                loading = false;
                                error = "User not found";
                              });
                              showErrorDialog(context, error);
                            } else if (e.code == "wrong-password") {
                              setState(() {
                                loading = false;
                                error = "Incorrect password";
                              });
                              showErrorDialog(context, error);
                            } else if (e.code == "network-request-failed") {
                              setState(() {
                                loading = false;
                                error =
                                    "A network occured, check your internet settings";
                              });
                              showErrorDialog(context, error);
                            } else {
                              setState(() {
                                loading = false;
                                error = e.message.toString();
                              });
                              showErrorDialog(context, error);
                            }
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.brown[700],
                        padding: const EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: const Text("Log in"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/resetpwd');
                      },
                      child: const Text(
                        "Forgot password?",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
