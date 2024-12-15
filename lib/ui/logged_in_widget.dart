import 'package:awesome_side_sheet/Enums/sheet_position.dart';
import 'package:awesome_side_sheet/side_sheet.dart';
import 'package:chat_sphere/ui/account/account_settings.dart';
import 'package:flutter/material.dart';

import 'chat/chat.dart';

class LoggedInWidget extends StatelessWidget {
  final Function() onSignOut;
  const LoggedInWidget({super.key, required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Chat(),
      appBar: AppBar(
        title: const Text('Chat Sphere'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: onSignOut,
          ),
          IconButton(onPressed: () {
          AccountSettings.show(context);
          }, icon: const Icon(Icons.account_circle)),
        ],
      ),
    );
  }
}