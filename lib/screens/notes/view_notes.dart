import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';
import 'package:notes/providers/firestore_provider.dart';
import 'package:notes/screens/notes/edit_notes.dart';
import 'package:notes/services/database.dart';
import 'package:provider/provider.dart';

class ViewNote extends StatefulWidget {
  final Note note;
  ViewNote({required this.note});
  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<FireStoreProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return EditNote(
                  note: Note(
                    id: widget.note.id,
                    title: widget.note.title,
                    content: widget.note.content,
                  ),
                );
              }));
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: const Text("Do you want to delete"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              provider.deleteNote(widget.note);
                            },
                            child: const Text("Yes"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("No"),
                          ),
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.delete))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.note.title}',
              style:
                  const TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 16,
            ),
            Text('${widget.note.content}'),
            const SizedBox(
              height: 70,
            ),
            Text(
              "${widget.note.createdTime}".substring(0, 19),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}