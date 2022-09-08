import 'package:notes/providers/firestore_provider.dart';

import '/helper_widgets/error_widget.dart';
import '/helper_widgets/loading.dart';
import '/helper_widgets/spacings.dart';
import '/screens/authenticate/authenticate.dart';
import '/screens/authenticate/log_in.dart';
import '/screens/nickname.dart';
import '/services/auth.dart';
import '/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/status.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  bool loading = false;
  String error = '';

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<FireStoreProvider>(context);
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[500],
              elevation: 0,
              title: const Text("Sign up"),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
                            hintStyle: TextStyle(color: Colors.grey),
                            suffixIcon: Icon(Icons.email)),
                        validator: (val) =>
                            val!.isEmpty ? "Enter an email" : null,
                        controller: _emailController,
                      ),
                      addVerticalSpace(10.0),
                      TextFormField(
                        decoration: const InputDecoration(
                            hintText: "password",
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                            hintStyle: TextStyle(color: Colors.grey),
                            suffixIcon: Icon(Icons.password)),
                        obscureText: true,
                        validator: (val) => val!.length < 6
                            ? "Enter a password with 6+ characters"
                            : null,
                        controller: _passwordController,
                      ),
                      addVerticalSpace(10.0),
                      TextFormField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            hintText: "confirm password",
                            hintStyle: TextStyle(color: Colors.grey),
                            fillColor: Colors.white,
                            suffixIcon: Icon(Icons.password)),
                        obscureText: true,
                        validator: (val) => val!.isEmpty
                            ? "confirm password"
                            : val != _passwordController.text
                                ? "passwords do not match"
                                : null,
                        controller: _confirmPasswordController,
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
                                  .registerWithEmailandPassword(
                                email,
                                password,
                              ).whenComplete(() {
                                setState(() {
                                  loading = false;
                                });
                              });
                              provider.updateUid(provider.uid!);
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                setState(() {
                                  loading = false;
                                  error = "weak password";
                                });
                                showErrorDialog(context, error);
                              } else if (e.code == 'email-already-in-use') {
                                setState(() {
                                  loading = false;
                                  error = "email already in use";
                                });
                                showErrorDialog(context, error);
                              } else if (e.code == 'invalid-email') {
                                setState(() {
                                  loading = false;
                                  error = "Invalid email";
                                });
                                showErrorDialog(context, error);
                              } else if (e.code == "network-request-failed") {
                                error =
                                    "A network occured, check your internet settings";
                                showErrorDialog(context, error);
                              } else {
                                error = e.message.toString();
                                showErrorDialog(context, error);
                              }
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.brown[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text("Sign up"),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 15,
                            child: Text(
                              "Already have an account?",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                context.read<AuthStatus>().toggle(),
                            child: const Text(
                              "Log in",
                              style: TextStyle(color: Colors.blue),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
