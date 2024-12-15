import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../data/chat_thread.dart';
import '../../data/user.dart';
import '../../db_operations/db_operations.dart';
import 'create_chat_dialog.dart';

class CreateChatButton extends StatelessWidget {
  const CreateChatButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: FloatingActionButton(
        child: const Icon(Icons.message),
          onPressed: () async {
        final users = await getAvailableChatUsers();

        showDialog(
          context: context,
          builder: (context) => CreateChatDialog(
              users: users,
              onCreateChat: (otherUser) async {
                await createChat(otherUser);
              }),
        );
      }),
    );
  }
}