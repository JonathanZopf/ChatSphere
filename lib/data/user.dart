import 'package:chat_sphere/data/chat_thread.dart';

class ChatUser{
  final String id;
  final String userName;
  final String profilePictureUrl;
  final List<ChatThread> chatThreads;

  ChatUser({required this.id, required this.userName, required this.profilePictureUrl, required this.chatThreads});

  factory ChatUser.fromJson(Map<dynamic, dynamic> json) {
    return ChatUser(
      id: json['id'],
      userName: json['userName'],
      profilePictureUrl: json['photoUrl'],
      chatThreads: (json['chatThreads'] as Map<dynamic, dynamic>?)?.values.map((threadJson) => ChatThread.fromJson(threadJson)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'photoUrl': profilePictureUrl,
      'chatThreads': chatThreads,
    };
  }
}