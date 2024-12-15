import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../data/chat_thread.dart';
import '../data/message.dart';
import '../data/user.dart';

Future<ChatUser> fetchUserData() async {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final userRef = FirebaseDatabase.instance.ref("users/$userId");
  final snapshot = await userRef.get();

  if (!snapshot.exists) {
    final newUser = ChatUser(
      id: userId,
      userName: "User ${Random().nextInt(10000)}",
      profilePictureUrl: "to be implemented",
      chatThreads: [],
    );

    await userRef.set(newUser.toJson());
    return newUser;
  }

  final userData = snapshot.value as Map<dynamic, dynamic>;
  return ChatUser.fromJson(userData);
}
Future<void> createMessage(String content, ChatUser otherUser) async {
  final thisUser = await fetchUserData();

  final message = Message(
    isMine: true,
    content: content,
    time: DateTime.now(),
  );

  final messagesRef = FirebaseDatabase.instance.ref(
    "users/${thisUser.id}/chatThreads/${otherUser.id}/messages",
  );

  await messagesRef.push().set(message.toJson());

  final otherUserMessagesRef = FirebaseDatabase.instance.ref(
    "users/${otherUser.id}/chatThreads/${thisUser.id}/messages",
  );

  final mirroredMessage = Message(
    isMine: false,
    content: content,
    time: message.time,
  );

  await otherUserMessagesRef.push().set(mirroredMessage.toJson());
}

Future<List<ChatUser>> getAvailableChatUsers() async {
  final currentUser = FirebaseAuth.instance.currentUser!;

  final chatRef = FirebaseDatabase.instance.ref(
    "users/${currentUser.uid}/chatThreads",
  );
  final chatSnapshot = await chatRef.get();
  final usersWithChat = chatSnapshot.children.map((e) {
    final chatData = e.value as Map<dynamic, dynamic>;
    return ChatUser.fromJson(chatData["otherUser"]);
  }).toList();

  final userRef = FirebaseDatabase.instance.ref("users");
  final usersSnapshot = await userRef.get();

  return usersSnapshot.children
      .map((e) {
    final userData = e.value as Map<dynamic, dynamic>;
    return ChatUser.fromJson(userData);
  })
      .where((e) =>
  e.id != currentUser.uid &&
      !usersWithChat.any((chatUser) => chatUser.id == e.id))
      .toList();
}

Future<void> createChat(ChatUser otherUser) async {
  final thisUser = await fetchUserData();

  final chatThread = ChatThread(
    otherUser: otherUser,
    messages: [],
  );

  final chatRef = FirebaseDatabase.instance.ref(
    "users/${thisUser.id}/chatThreads/${otherUser.id}",
  );

  await chatRef.set(chatThread.toJson());

  final mirroredChatThread = ChatThread(
    otherUser: thisUser,
    messages: [],
  );

  final otherUserChatRef = FirebaseDatabase.instance.ref(
    "users/${otherUser.id}/chatThreads/${thisUser.id}",
  );

  await otherUserChatRef.set(mirroredChatThread.toJson());
}