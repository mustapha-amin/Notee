import 'package:notes/screens/authenticate/authenticate.dart';

import '/helper_widgets/spacings.dart';
import '/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../helper_widgets/loading.dart';

class ResetPassWord extends StatefulWidget {
  const ResetPassWord({Key? key}) : super(key: key);

  @override
  State<ResetPassWord> createState() => _ResetPassWordState();
}

class _ResetPassWordState extends State<ResetPassWord> {
  TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.brown[700],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.brown[200],
      body: loading
          ? const Loading()
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        hintText: "email",
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) =>
                          val!.isEmpty ? "Enter your email" : null,
                      controller: _emailController,
                    ),
                  ),
                  addVerticalSpace(20),
                  ElevatedButton.icon(
                    onPressed: () {
                      try {
                        AuthService().resetPwd(_emailController.text);
                      } on FirebaseAuthException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("${e.message}"),
                          ),
                        );
                      }
                      if (_formKey.currentState!.validate()) {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return Authenticate();
                        }));
                      }
                    },
                    icon: const Icon(Icons.email),
                    label: const Text("Reset password"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.brown[700],
                      padding: const EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      minimumSize: const Size.fromHeight(50),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
