import 'package:get/get.dart';

class SimpleUIController extends GetxController {
  RxBool isObscure = true.obs;
  RxBool isPasswordInvalid = false.obs;

  isObscureActive() {
    isObscure.value = !isObscure.value;
  }

  isPasswordInvalidActive() {
    isPasswordInvalid.value = !isPasswordInvalid.value;
  }
}
