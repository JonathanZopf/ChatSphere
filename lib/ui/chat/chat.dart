import 'dart:math';

import 'package:chat_sphere/ui/chat/chat_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../data/chat_thread.dart';
import '../../data/message.dart';
import '../../data/user.dart';
import '../../db_operations/db_operations.dart';
import 'chat_conversation_view.dart';
import 'chat_list.dart';
import 'no_chat_selected_view.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late Future<List<ChatThread>> _chatThreadsFuture;
  ChatThread? _selectedChat;

  @override
  void initState() {
    super.initState();
    _chatThreadsFuture = fetchUserData().then((userData) async {
      final chatThreads = await fetchUserData().then((data)=>data.chatThreads);
      return chatThreads;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ChatThread>>(
      future: _chatThreadsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error loading chats: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          final chats = snapshot.data!;
          return Row(
            children: [
              ConstrainedBox(constraints: const BoxConstraints(maxWidth: 400),child: ChatList(chats: chats, selectedChat: _selectedChat, onChatSelected: (chat) {
                setState(() {
                  _selectedChat = chat;
                });
              }),),
              Expanded(child: (_selectedChat != null)
                  ? Column(children: [Expanded(child: ChatConversationView(chat: _selectedChat!)), ChatInput(onMessageSent: (content) async {
                    final message = Message(
                      isMine: true,
                      content: content,
                      time: DateTime.now(),
                    );
                    await createMessage(content, _selectedChat!.otherUser);
              })])
                  : const NoChatSelectedView()),
            ],
          );
        } else {
          return const Center(
            child: Text('No chats available'),
          );
        }
      },
    );
  }
}
