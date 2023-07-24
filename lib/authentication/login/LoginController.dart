import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:animationlogin2/controller..dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  Rx<TextEditingController> usuarioController = TextEditingController().obs;
  Rx<TextEditingController> senhaController = TextEditingController().obs;
  RxDouble loadingwidth = 350.0.obs; // Definir altura loading button
  RxBool buttonState = false.obs; //Status botão para habilitar ação ou não
  RxBool loadingbuttonStatus = false.obs; //Status para change text or loadingIndicator
  RxBool loadingbuttonSucess = false.obs; //Status para change Icon
  RxBool loadingbuttonErro = false.obs; //Status para change Icon

  loadingButtonOn() {
    buttonState.value = true;
    loadingwidth.value = 50.0;
    loadingbuttonStatus.value = true;
  }

  loadingButtonOff() {
    loadingwidth.value = 350.0;
    loadingbuttonStatus.value = false;
    loadingbuttonSucess.value = false;
    loadingbuttonErro.value = false;
    buttonState.value = false;
  }

  loadingButtonSucess(_loginButtonController) async {
    loadingbuttonStatus.value = false;
    loadingbuttonSucess.value = true;
    try {
      await _loginButtonController.forward();
      await _loginButtonController.reverse();
    } on TickerCanceled {}
  }

  loadingButtonError() {
    loadingbuttonStatus.value = false;
    loadingbuttonErro.value = true;
  }

  clearForm() {
    usuarioController.value.clear();
    senhaController.value.clear();
  }

  login(_loginButtonController) async {
    FocusScope.of(Get.context).requestFocus(FocusNode());
    if (usuarioController.value.text.isEmpty || senhaController.value.text.isEmpty) {
      dialogs.showSnackBar('empty'.tr, Icons.warning_rounded);
      return;
    }
    loadingButtonOn();
    usuarioRepository.checkLogin(usuarioController.value.text, usuarioController.value.text).then((result) {
      Future.delayed(Duration(seconds: 2), () async {
        if (result != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setInt('logado', 1);
          loadingButtonSucess(_loginButtonController);
        } else {
          loadingButtonError();
          Future.delayed(Duration(seconds: 3), () => loadingButtonOff());
        }
      });
    });
  }
}