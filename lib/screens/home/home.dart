import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/providers/firestore_provider.dart';
import 'package:notes/screens/home/drawer.dart';
import 'package:notes/screens/notes/edit_notes.dart';
import '../notes/view_notes.dart';
import '/screens/authenticate/authenticate.dart';
import '/screens/nickname.dart';
import 'package:notes/services/auth.dart';
import 'package:notes/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/models/note.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseService databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    AuthService _auth = AuthService();
    var provider = Provider.of<FireStoreProvider>(context);
    DatabaseService database = DatabaseService();
    User? user = _auth.currentUser;
    return user!.displayName == null
        ? NickName()
        : Scaffold(
            drawer: const MyDrawer(),
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              title: const Text("My notes"),
              elevation: 0,
              backgroundColor: Colors.brown,
            ),
            body: StreamBuilder<List<Note>>(
              stream: database.readNotes(provider.uid.toString()),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final notes = snapshot.data;
                  debugPrint(snapshot.data!.map((e) => e.toJson()).toString());
                  return notes!.isEmpty
                      ? const Center(
                          child: Text("No notes"),
                        )
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: notes.length,
                          itemBuilder: (context, index) {
                            Note note = notes[index];
                            return Dismissible(
                              key: UniqueKey(),
                              resizeDuration: Duration(microseconds: 100),
                              direction: DismissDirection.horizontal,
                              onDismissed: (direction) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: const Text(
                                            "Do you want to delete this note?"),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                provider.deleteNote(note);
                                                Navigator.pop(context);
                                              },
                                              child: const Text("Yes")),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                setState(() {});
                                              },
                                              child: const Text("No")),
                                        ],
                                      );
                                    });
                              },
                              background: Container(
                                padding: const EdgeInsets.only(left: 10.0),
                                color: Colors.red,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: const [
                                    Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                              secondaryBackground: Container(
                                padding: const EdgeInsets.only(right: 10.0),
                                color: Colors.red[400],
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: const [
                                    Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                              child: Card(
                                elevation: 2,
                                child: ListTile(
                                    title: Text(note.title!),
                                    subtitle: Text(
                                      note.content!,
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return ViewNote(
                                          note: Note(
                                            id: note.id,
                                            title: note.title,
                                            content: note.content,
                                            createdTime: note.createdTime,
                                          ),
                                        );
                                      }));
                                    }),
                              ),
                            );
                          },
                        );
                } else if (snapshot.hasError) {
                  debugPrint(
                    snapshot.error.toString(),
                  );
                  debugPrint(snapshot.data.toString());
                  return const Text("An error occured");
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.brown,
                    ),
                  );
                }
              },
            ),
            floatingActionButton: FloatingActionButton(
              elevation: 0,
              backgroundColor: Colors.brown[700],
              onPressed: () {
                Navigator.pushNamed(context, '/addnotes');
                // databaseService.superDelete(
                //   provider.uid.toString(),
                // );
              },
              child: const Icon(
                Icons.edit_rounded,
                color: Colors.white,
              ),
            ),
          );
  }
}
