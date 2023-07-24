import 'constants.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class Dialogs extends State {
  void showSnackBar(String message, IconData icon) {
    Get.snackbar(
      'alert'.tr,
      message,
      borderRadius: 5.0,
      colorText: Colors.white,
      backgroundColor: cor_primary,
      icon: Icon(icon, color: Colors.white),
      duration: Duration(seconds: 4),
      animationDuration: Duration(milliseconds: 100),
      snackPosition: SnackPosition.BOTTOM,
      dismissDirection: SnackDismissDirection.HORIZONTAL,
    );
  }

  @override
  Widget build(BuildContext context) => Container();
}