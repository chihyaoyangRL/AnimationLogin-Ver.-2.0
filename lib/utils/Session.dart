import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../authentication/login/login_page.dart';
import 'package:animationlogin2/screen/home/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Session extends State {
  void logado() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('logado') == null) {
      Get.offAll(() => Login());
    } else {
      Get.offAll(() => HomePage());
    }
  }

  @override
  Widget build(BuildContext context) => Container();
}