import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String? id;
  String? title;
  String? content;
  DateTime? createdTime;

  Note({this.id, this.title, this.content, this.createdTime});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdTime': createdTime,
    };
  }

  static Note fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      createdTime: (json['createdTime'] as Timestamp).toDate(),
    );
  }
}
