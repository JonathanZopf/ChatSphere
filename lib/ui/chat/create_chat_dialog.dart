import 'package:chat_sphere/data/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateChatDialog extends StatefulWidget {
  final List<ChatUser> users;
  final Function(ChatUser) onCreateChat;
  const CreateChatDialog({Key? key, required this.users, required this.onCreateChat}) : super(key: key);

  @override
  _CreateChatDialogState createState() => _CreateChatDialogState();
}

class _CreateChatDialogState extends State<CreateChatDialog> {
  final _controller = TextEditingController();
  String input = "";


  void _createChat() {
    var user = widget.users.firstWhere((user) => user.userName == input);
    widget.onCreateChat(user);
    Navigator.of(context).pop(_controller.text);
  }

  bool _userExists() {
    if (input.isEmpty) {
      return false;
    }
    return widget.users.any((user) => user.userName == input);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create a new chat'),
      content: TextField(
        controller: _controller,
        onChanged: (value) {
          setState(() {
            input = value;
          });
        },
        decoration: const InputDecoration(
          hintText: 'Enter the user name of the person you want to chat with',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _userExists() ? _createChat : null,
          child: const Text('Create'),
        ),
      ],
    );
  }
}