import 'package:chat_sphere/data/user.dart';

class Message {
  final bool isMine;
  final String content;
  final DateTime time;

  Message({required this.isMine, required this.content, required this.time});

  factory Message.fromJson(Map<dynamic, dynamic> json) {
    return Message(
      isMine: json['isMine'],
      content: json['content'],
      time: DateTime.parse(json['time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isMine': isMine,
      'content': content,
      'time': time.toIso8601String(),
    };
  }
}