import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controller..dart';
import 'package:flutter/material.dart';
import '../../models/Usuario_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterController extends GetxController {
  Rx<TextEditingController> usuarioController = TextEditingController().obs;
  Rx<TextEditingController> senhaController = TextEditingController().obs;
  Rx<TextEditingController> repeatSenhaController = TextEditingController().obs;
  RxBool loadingbuttonStatus = false.obs; //Status para change text or loadingIndicator
  RxBool loadingbuttonSucess = false.obs; //Status para change Icon
  RxBool loadingbuttonErro = false.obs; //Status para change Icon
  RxBool buttonState = false.obs; //definir status botão
  RxDouble loadingwidth = 350.0.obs; //Definir altura loading button

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

  loadingButtonSucess(_registerButtonController) async {
    loadingbuttonStatus.value = false;
    loadingbuttonSucess.value = true;
    try {
      await _registerButtonController.forward();
      await _registerButtonController.reverse();
    } on TickerCanceled {}
  }

  loadingButtonError() {
    loadingbuttonStatus.value = false;
    loadingbuttonErro.value = true;
  }

  clearForm() {
    usuarioController.value.clear();
    senhaController.value.clear();
    repeatSenhaController.value.clear();
  }

  cadastro(_registerButtonController) async {
    FocusScope.of(Get.context).requestFocus(FocusNode());
    if (usuarioController.value.text.isEmpty || senhaController.value.text.isEmpty || repeatSenhaController.value.text.isEmpty) {
      dialogs.showSnackBar('empty'.tr, Icons.warning_rounded);
      return;
    }
    if (repeatSenhaController.value.text != senhaController.value.text) {
      dialogs.showSnackBar('repeatError'.tr, Icons.warning_rounded);
      return;
    }
    loadingButtonOn();
    usuarioRepository.insert(UsuarioModel(email: usuarioController.value.text.toString(), password: senhaController.value.text.toString(), dataLogin: DateFormat('dd-MM-yyyy').format(DateTime.now()))).then((result) async {
      if (result != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('logado', 1);
        loadingButtonSucess(_registerButtonController);
      } else {
        loadingButtonError();
        Future.delayed(Duration(seconds: 5), () => loadingButtonOff());
      }
    });
  }
}