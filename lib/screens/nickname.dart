import '/helper_widgets/loading.dart';
import '/helper_widgets/spacings.dart';
import '/screens/home/home.dart';
import '/services/auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class NickName extends StatefulWidget {
  String? buttonText;
  NickName({Key? key, this.buttonText}) : super(key: key);

  @override
  State<NickName> createState() => _NickNameState();
}

class _NickNameState extends State<NickName> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _controller = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              foregroundColor: Colors.brown[700],
            ),
            backgroundColor: Colors.brown[100],
            body: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      decoration:
                          const InputDecoration(hintText: "Enter a nickname"),
                      controller: _controller,
                      validator: (val) => val!.length < 5
                          ? "Nickname must be 5 characters long"
                          : null,
                    ),
                  ),
                  addVerticalSpace(20),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      await AuthService().setName(_controller.text);
                      await AuthService()
                          .currentUser!
                          .reload().whenComplete(() => Navigator.pushReplacementNamed(context, '/home'));
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.brown[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: Text(widget.buttonText == null
                        ? "Add a nickname"
                        : widget.buttonText.toString()),
                  )
                ],
              ),
            ),
          );
  }
}
