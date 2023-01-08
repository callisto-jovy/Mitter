import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:it_class_frontend/util/connection_util.dart';
import 'package:it_class_frontend/views/login_view.dart';

import 'controller/simple_ui_controller.dart';

void main(List<String> arguments) async {
  Get.put(SimpleUIController());
  Get.put<SocketInterface>(
    //SocketInterface("192.168.0.9"),
    SocketInterface(arguments.first),
  );

  debugInvertOversizedImages = true;

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
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const LoginView(),
    );
  }
}
