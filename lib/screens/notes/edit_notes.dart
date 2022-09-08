import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';
import 'package:notes/providers/firestore_provider.dart';
import 'package:notes/services/database.dart';
import 'package:provider/provider.dart';

class EditNote extends StatefulWidget {
  Note note;
  EditNote({Key? key, required this.note}) : super(key: key);
  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  String? titleCopy;
  String? contentCopy;
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
    titleCopy = widget.note.title.toString();
    contentCopy = widget.note.content.toString();
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
    var provider = Provider.of<FireStoreProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              if (titleCopy == _titleController.text &&
                  contentCopy == _contentController.text) {
                Navigator.pop(context);
              } else {
                provider.updateNote(widget.note, _titleController.text,
                    _contentController.text);
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.check),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              style:
                  const TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: "Title",
                border: InputBorder.none,
              ),
            ),
            TextField(
              keyboardType: TextInputType.multiline,
              controller: _contentController,
              decoration: const InputDecoration(border: InputBorder.none),
              maxLines: null,
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
