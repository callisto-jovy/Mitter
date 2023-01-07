import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:it_class_frontend/constants.dart';
import 'package:it_class_frontend/util/connection_util.dart';
import 'package:it_class_frontend/util/packets/logout_packet.dart';
import 'package:it_class_frontend/util/packets/profile_packet.dart';
import 'package:it_class_frontend/views/login_view.dart';
import 'package:it_class_frontend/widgets/snackbars.dart';
import 'package:settings_ui/settings_ui.dart';

class AccountView extends StatefulWidget {
  const AccountView({Key? key}) : super(key: key);

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  @override
  Widget build(BuildContext context) {
    return SettingsList(
      sections: [
        CustomSettingsSection(
            child: Container(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 10,
            color: Theme.of(context).colorScheme.secondary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: const EdgeInsets.all(5), child: circleAvatar(localUser, radius: 32)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        localUser.username,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 32, color: Colors.white),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              child: Icon(Icons.tag_rounded, size: 16, color: Colors.grey[400]),
                            ),
                            TextSpan(
                              style: TextStyle(color: Colors.grey[400], fontSize: 16),
                              text: localUser.tag,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        )),
        SettingsSection(
          tiles: [
            SettingsTile.navigation(
              title: const Text('Profile-Picture'),
              onPressed: (context) {
                FilePicker.platform.pickFiles(type: FileType.image).then((value) {
                  if (value != null) {
                    final File file = File(value.files.single.path!);
                    //Convert the file's bytes into base64 then send the base64 string to the server and display a message in case of success.
                    file.readAsBytes().then((value) => base64Encode(value)).then((base) {
                      Get.find<SocketInterface>().send(ProfilePacket(base)).then((value) =>
                          ScaffoldMessenger.of(context)
                              .showSnackBar(successSnackbar(value.operation)));
                      setState(() {
                        localUser.profile = base;
                      });
                    });
                  }
                });
              },
            ),
          ],
          title: const Text('Account'),
        ),
        SettingsSection(
          title: const Text('Common'),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
              leading: const Icon(Icons.language),
              title: const Text('Language'),
              value: const Text('English'),
            ),
            SettingsTile.switchTile(
              onToggle: (value) {},
              initialValue: true,
              leading: const Icon(Icons.format_paint),
              title: const Text('Enable custom theme'),
            ),
            SettingsTile.navigation(
              title: const Text('Logout'),
              onPressed: (context) =>
                  Get.find<SocketInterface>().send(LogoutPacket()).then((value) {
                Navigator.pushReplacement(
                    context, CupertinoPageRoute(builder: (ctx) => const LoginView()));
                logout();
              }),
              leading: const Icon(Icons.logout_sharp),
            )
          ],
        ),
      ],
    );
  }
}
