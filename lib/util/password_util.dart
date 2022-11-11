import 'package:crypto/crypto.dart';
import 'package:get/get.dart';
import 'package:it_class_frontend/util/packets/packets.dart';
import 'package:it_class_frontend/util/security_util.dart';
import 'package:it_class_frontend/util/connection_util.dart';


const int key_rounds = 30;
const int key_length = 256;
const int salt_length = 50;
final PBKDF2 hashing = PBKDF2(hashAlgorithm: sha512224);

Future<bool> validateLogin(final String tag, final String password) async {
  final String generatedHash =
      hashing.generateBase64Key(tag + password, Salt.generate(salt_length), key_rounds, key_length);
  //Send off to server to validate
  Get.find<SocketInterface>().send(SignInPacket(tag, password));
  //Only in debugging
  return true;
}

void sendLogin(final String tag, final String password, final String username) {
  final String generatedHash =
      hashing.generateBase64Key(tag + password, Salt.generate(salt_length), key_rounds, key_length);
  //Send data
  Get.find<SocketInterface>().send(SignUpPacket(username, tag, password));
}
