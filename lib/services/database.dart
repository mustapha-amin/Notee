import 'package:notes/models/note.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  Future createNote({required Note note, String? uid}) async {
    final notesDoc = FirebaseFirestore.instance.collection('$uid notes').doc();
    note.id = notesDoc.id;
    await notesDoc.set(note.toJson());
  }

  Stream<List<Note>> readNotes(String uid) {
    final notesDoc = FirebaseFirestore.instance.collection('$uid notes');
    return notesDoc.orderBy('createdTime', descending: true).snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => Note.fromJson(doc.data())).toList());
  }

  Future updateNote(Note note, String title, String content, String uid) async {
    note.title = title;
    note.content = content;
    note.createdTime = DateTime.now();
    final notesDoc =
        FirebaseFirestore.instance.collection('$uid notes').doc(note.id);
    await notesDoc.update(note.toJson());
  }

  Future deleteNote(Note note, String uid) async {
    final notesDoc =
        FirebaseFirestore.instance.collection('$uid notes').doc(note.id);
    await notesDoc.delete();
  }

  Future superDelete(String uid) async {
    var notesDoc = FirebaseFirestore.instance.collection('$uid notes');
    var snaps = await notesDoc.get();
    for (var doc in snaps.docs) {
      await doc.reference.delete();
    }
  }
}
