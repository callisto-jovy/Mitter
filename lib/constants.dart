import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle loginTitleStyle(Size size) => GoogleFonts.openSans(
      fontSize: size.height * 0.060,
      fontWeight: FontWeight.bold,
    );

TextStyle loginSubtitleStyle(Size size) => GoogleFonts.openSans(
      fontSize: size.height * 0.030,
    );

TextStyle loginFinePrintStyle(Size size, {Color? color}) =>
    GoogleFonts.openSans(fontSize: 15, color: color ?? Colors.grey, height: 1.5);

TextStyle textFormFieldStyle() => const TextStyle(color: Colors.black);

TextStyle textFormErrorStyle() => const TextStyle(color: Colors.redAccent);

String errorMessageInvalidLength(String id, {required int lower, int? upper}) => upper != null
    ? 'Your $id has to be between $lower and $upper characters in length.'
    : 'Your $id must at least be $lower characters in length.';

TextStyle textChatBubbleStyle() => const TextStyle(color: Colors.white);
