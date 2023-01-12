import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:it_class_frontend/chat/chat_handler.dart';
import 'package:it_class_frontend/users/user.dart';
import 'package:it_class_frontend/users/user_handler.dart';
import 'package:it_class_frontend/widgets/user_avatar.dart';

late User localUser;
ChatHandler chatHandler = ChatHandler();
UserHandler userHandler = UserHandler();

void logout() {
  chatHandler.chats.clear();
  userHandler.users.clear();
}

Widget circleAvatar(User user, {double? radius}) => user.profile.isEmpty
    ? UserAvatar(
        radius: radius,
        child: Text(user.initials),
      )
    : UserAvatar(
        radius: radius,
        backgroundImage: Image.memory(
          user.profile,
          cacheWidth: 64,
          cacheHeight: 64,
        ).image,
        filterQuality: FilterQuality.medium,
      );

TextStyle loginTitleStyle(Size size) => GoogleFonts.openSans(
      fontSize: size.height * 0.060,
      fontWeight: FontWeight.bold,
    );

TextStyle loginSubtitleStyle(Size size) => GoogleFonts.openSans(
      fontSize: size.height * 0.030,
    );

TextStyle loginFinePrintStyle(Size size, {Color? color}) =>
    GoogleFonts.openSans(fontSize: 15, color: color ?? Colors.grey, height: 1.5);

TextStyle textFormErrorStyle() => const TextStyle(color: Colors.redAccent);

String errorMessageInvalidLength(String id, {required int lower, int? upper}) => upper != null
    ? 'Your $id has to be between $lower and $upper characters in length.'
    : 'Your $id must at least be $lower characters in length.';
