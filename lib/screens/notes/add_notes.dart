import 'package:flutter/material.dart';
import 'package:notes/services/database.dart';
import 'package:provider/provider.dart';
import '../../models/note.dart';
import '../../providers/firestore_provider.dart';

class AddNotes extends StatefulWidget {
  AddNotes({Key? key}) : super(key: key);

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DatabaseService note = DatabaseService();
    var provider = Provider.of<FireStoreProvider>(context);
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              _titleController.text != null || _contentController.text != null
                  ? provider.addNote(Note(
                      title: _titleController.text,
                      content: _contentController.text,
                      createdTime: DateTime.now()))
                  : null;
              Navigator.pop(context);
            },
          ),
        ],
        backgroundColor: Colors.brown[700],
        title: const Text("Add notes"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: "Title",
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            TextField(
              keyboardType: TextInputType.multiline,
              controller: _contentController,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: "Add notes",
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
