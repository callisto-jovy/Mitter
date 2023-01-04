import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

String get newStamp => const Uuid().v4().toString();
