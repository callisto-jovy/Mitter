import 'package:uuid/uuid.dart';

String get newStamp => const Uuid().v4().toString();
