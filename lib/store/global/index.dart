import 'package:get/get.dart';

class GlobalStore extends GetxController {
  RxBool isStorageInitialized = false.obs;

  void changeStorageInitialized(bool value) {
    print('changeStorageInitialized: $value');
    isStorageInitialized.value = value;
  }
}