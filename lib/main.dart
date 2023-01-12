import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:it_class_frontend/util/connection_util.dart';
import 'package:it_class_frontend/util/preferences_util.dart';
import 'package:it_class_frontend/views/login_view.dart';

import 'controller/simple_ui_controller.dart';

void main(List<String> arguments) async {
//  debugInvertOversizedImages = true;
  Get.put(SimpleUIController());
  Get.put<SocketInterface>(
    SocketInterface(arguments.first),
  );
  await HiveInterface().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const LoginView(),
    );
  }
}
