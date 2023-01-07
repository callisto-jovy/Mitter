import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:it_class_frontend/constants.dart';
import 'package:it_class_frontend/widgets/big_user_card.dart';

import '../util/icon_style.dart';
import '../widgets/settings_item.dart';

class AccountView extends StatefulWidget {
  const AccountView({Key? key}) : super(key: key);

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return ListView(
      children: [
        BigUserCard(
          cardColor: Theme.of(context).colorScheme.secondary,
          userName: localUser.username,
          userProfilePic: localUser.profile == 'null'
              ? Icon(
                  Icons.account_circle_rounded,
                  size: size.height / 4,
                  color: Theme.of(context).colorScheme.secondary,
                )
              : Image.memory(base64Decode(localUser.profile)),
          cardActionWidget: SettingsItem(
            icons: Icons.edit,
            iconStyle: IconStyle(
              withBackground: true,
              borderRadius: 50,
              backgroundColor: Colors.yellow[600],
            ),
            title: "Modify",
            subtitle: "Tap to change your data",
            onTap: () {
              print("OK");
            },
          ),
        ),
      ],
    );
  }
}
