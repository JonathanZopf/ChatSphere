import 'package:chat_sphere/data/user.dart';
import 'package:flutter/material.dart';

import '../../db_operations/db_operations.dart';

import 'package:flutter/material.dart';

class AccountSettingBody extends StatefulWidget {
  const AccountSettingBody({super.key});

  @override
  State<AccountSettingBody> createState() => _AccountSettingBodyState();
}

class _AccountSettingBodyState extends State<AccountSettingBody> {
  bool _isEditing = false;
  TextEditingController? _nameController;
  String _errorText = '';


  /// Validation Logic
  String? _isNewNameAccepted(
      String currentName, List<String> takenAccountNames, String newName) {
    if (newName.isEmpty) {
      return 'Name cannot be empty';
    }
    if (newName == currentName) {
      return 'Name is the same as the current one';
    }
    if (takenAccountNames.contains(newName)) {
      return 'Name is already taken';
    }
    if (newName.length > 20) {
      return 'Name is too long';
    }
    if (newName.length < 3) {
      return 'Name is too short';
    }
    if (newName.contains(RegExp(r'[^\w\s]'))) {
      return 'Name can only contain letters, numbers, and spaces';
    }
    return null;
  }

  /// Save Name to Database
  void _saveName(BuildContext context, ChatUser user,
      List<String> takenUsernames, String newName) async {
    final error = _isNewNameAccepted(user.userName, takenUsernames, newName);
    if (error == null) {
      await updateUserName(newName);
      setState(() {
        _isEditing = false;
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Name updated successfully!')),
        );
      }
    } else {
      setState(() {
        _errorText = error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchUserAndTakenUserNames(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return const Center(child: Text('No data found'));
        }

        final account = snapshot.data!.item1;
        final takenUsernames = snapshot.data!.item2;

        _nameController ??= TextEditingController(text: account.userName);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'User Name',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                // Display name as text when not editing
                if (!_isEditing)
                  Expanded(
                    child: Text(
                      account.userName,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                // Display editable TextField when editing
                if (_isEditing)
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Change your User Name',
                        errorText: _errorText.isNotEmpty ? _errorText : null,
                      ),
                    ),
                  ),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: IconButton(
        icon: Icon(_isEditing ? Icons.check : Icons.edit),
        onPressed: () {
        if (_isEditing) {
        _saveName(context, account, takenUsernames,
        _nameController!.text.trim());
        } else {
        setState(() {
        _isEditing = true; // Enable edit mode
        });
        }
        },
        ))
              ],
              ),
          ],
        );
      },
    );
  }
}
