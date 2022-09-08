import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '/models/note.dart';
import '/services/database.dart';

class FireStoreProvider extends ChangeNotifier {
  DatabaseService databaseService = DatabaseService();
  String? _uid;

  String? get uid => _uid;

  List<Note> _notes = [];

  List<Note> get notes => _notes;

  void updateUid(String uid) {
    _uid = uid;
    notifyListeners();
  }

  void addNote(Note note) {
    databaseService.createNote(note: note, uid: _uid);
  }

  void readNote() {
    databaseService.readNotes(_uid!);
  }

  void updateNote(Note note, String title, String content) {
    databaseService.updateNote(note, title, content, _uid!);
  }

  void deleteNote(Note note) {
    databaseService.deleteNote(note, uid!);
  }
}