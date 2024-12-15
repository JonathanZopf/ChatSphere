import 'package:chat_sphere/data/chat_thread.dart';
import 'package:chat_sphere/ui/chat/create_chat_button.dart';
import 'package:chat_sphere/ui/chat/create_chat_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../data/user.dart';

class ChatList extends StatelessWidget {
  final List<ChatThread> chats;
  final Function(ChatThread) onChatSelected;
  final ChatThread? selectedChat;

  const ChatList(
      {super.key,
      required this.chats,
      required this.onChatSelected,
      this.selectedChat});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card.filled(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Stack(
            children: [
              if (chats.isEmpty)
                Center(
                  child: Text(
                    'No chats yet',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                )
              else
                ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    return ListTile(
                      title: Text(chat.otherUser.userName),
                      subtitle: Text(chat.messages.isEmpty ? "" :chat.messages.last.content),
                      onTap: () => onChatSelected(chat),
                      selected: chat == selectedChat,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      selectedTileColor:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                    );
                  },
                ),
              const CreateChatButton()
            ],
          ),
        ),
      ),
    );
  }
}
