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
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final Function() onSignOut;
  const Chat({super.key, required this.onSignOut});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  ChatThread? _selectedChat;
  late Stream<List<ChatThread>> stream;

  @override
  void initState() {
    super.initState();
    stream = listenForChatThreads();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Sphere'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: widget.onSignOut,
          ),
        ],
      ),
      body: StreamBuilder<List<ChatThread>>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final chats = snapshot.data ?? [];

          return Row(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: ChatList(
                  chats: chats,
                  selectedChat: _selectedChat,
                  onChatSelected: (chat) {
                    setState(() {
                      _selectedChat = chat;
                    });
                  },
                ),
              ),
              Expanded(
                child: (_selectedChat != null)
                    ? Column(
                  children: [
                    Expanded(
                      child: ChatConversationView(chat: _selectedChat!),
                    ),
                    ChatInput(onMessageSent: (content) async {
                      await createMessage(content, _selectedChat!.otherUser);
                    }),
                  ],
                )
                    : const NoChatSelectedView(),
              ),
            ],
          );
        },
      ),
    );
  }
}
