import 'package:crypto/crypto.dart';
import 'package:get/get.dart';
import 'package:it_class_frontend/util/connection_util.dart';
import 'package:it_class_frontend/util/packets/packets.dart';
import 'package:it_class_frontend/util/security_util.dart';

const int key_rounds = 30;
const int key_length = 256;
const int salt_length = 50;
final PBKDF2 hashing = PBKDF2(hashAlgorithm: sha512224);

void validateLogin(final String tag, final String password, Function(bool) accepted) async {
  final String generatedHash =
      hashing.generateBase64Key(tag + password, Salt.generate(salt_length), key_rounds, key_length);
  //Send off to server to validate and register callback
  Get.find<SocketInterface>().send(SignInPacket(tag, generatedHash),
      whenReceived: (value) => accepted.call((value.first == 'TRUE')));
}

void sendLogin(final String tag, final String password, final String username) {
  final String generatedHash =
      hashing.generateBase64Key(tag + password, Salt.generate(salt_length), key_rounds, key_length);
  //Send data
  Get.find<SocketInterface>().send(SignUpPacket(username, tag, password));
}
