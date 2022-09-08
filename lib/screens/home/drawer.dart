import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/providers/firestore_provider.dart';
import 'package:notes/screens/authenticate/authenticate.dart';
import 'package:notes/screens/wrapper.dart';
import 'package:notes/services/database.dart';
import 'package:provider/provider.dart';

import '../../services/auth.dart';
import '../nickname.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<FireStoreProvider>(context);
    AuthService _auth = AuthService();
    User user = _auth.currentUser!;
    DatabaseService databaseService = DatabaseService();
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountEmail: Text(user.email.toString()),
            accountName: Text(
              '${user.displayName}',
            ),
            currentAccountPicture: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: Text(
                user.displayName!.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Update nickname"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return NickName(
                    buttonText: "Update nickname",
                  );
                }));
              }),
          ListTile(
            title: const Text("Log out"),
            leading: const Icon(Icons.logout),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: const Text("Do you want to log out"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _auth.signOut();
                        },
                        child: const Text("Yes"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("No"),
                      )
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Delete account"),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: const Text("Do you want to delete your account?"),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          databaseService.superDelete(provider.uid!).onError(
                              (error, stackTrace) =>
                                  debugPrint(error.toString()));
                          await _auth.currentUser!.delete().whenComplete(() {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return Authenticate();
                            }));
                          });
                        },
                        child: const Text(
                          "Yes, delete",
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("No"),
                      )
                    ],
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }
}
