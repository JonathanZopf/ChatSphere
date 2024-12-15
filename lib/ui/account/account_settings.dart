import 'package:awesome_side_sheet/Enums/sheet_position.dart';
import 'package:awesome_side_sheet/side_sheet.dart';
import 'package:chat_sphere/data/user.dart';
import 'package:flutter/material.dart';

import '../../db_operations/db_operations.dart';
import 'account_settings_body.dart';

class AccountSettings {
 static void show(BuildContext context) {
    aweSideSheet(
      context: context,
      sheetPosition: SheetPosition.right,
      transitionDuration: const Duration(milliseconds: 150),
      showHeaderDivider: false,
      header: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Text('Account Settings',
                style: Theme.of(context).textTheme.titleLarge),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: AccountSettingBody(),
      ),
    );
  }
}