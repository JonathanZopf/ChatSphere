import 'package:chat_sphere/data/message.dart';
import 'package:chat_sphere/data/user.dart';

class ChatThread {
  final ChatUser otherUser;
  final List<Message> messages;

  ChatThread({required this.otherUser, required this.messages});

  factory ChatThread.fromJson(Map<dynamic, dynamic> json) {
    return ChatThread(
      otherUser: ChatUser.fromJson(json['otherUser']),
      messages: (json['messages'] as Map<dynamic, dynamic>?)?.values
              .map((e) => Message.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'otherUser': otherUser.toJson(),
      'messages': messages,
    };
  }
}