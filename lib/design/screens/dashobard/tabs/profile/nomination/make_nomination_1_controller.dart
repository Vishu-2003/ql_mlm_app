import 'package:get/get.dart';

class MakeNomination1Controller extends GetxController {
  bool isDisclaimerChecked = false;

  void onDisclaimerChecked() {
    isDisclaimerChecked = !isDisclaimerChecked;
    update();
  }
}
