import 'package:hive_flutter/adapters.dart';

class HiveInterface {
  static final HiveInterface _instance = HiveInterface._inst();

  HiveInterface._inst();

  factory HiveInterface() {
    return _instance;
  }

  late Box settingsBox;

  Future<void> init() async {
    await Hive.initFlutter();
    settingsBox = await Hive.openBox("settings");

  }

  bool get darkTheme => settingsBox.get('dark_theme', defaultValue: false);

  void toggleDarkTheme(bool value) => settingsBox.put('dark_theme', value);
}
