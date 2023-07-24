import 'dart:io';
import 'package:get/get.dart';
import '../../utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animationlogin2/widget/CustomTextField.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:animationlogin2/widget/Custom_Loading_Button.dart';
import 'package:animationlogin2/authentication/login/LoginController.dart';
import 'package:animationlogin2/authentication/register/register_page.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  final LoginController controller = Get.put(LoginController());
  AnimationController _loginButtonController;

  @override
  void initState() {
    super.initState();
    _loginButtonController = new AnimationController(duration: new Duration(milliseconds: 3000), vsync: this);
  }

  @override
  void dispose() {
    _loginButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: new BoxDecoration(
            image: DecorationImage(image: new ExactAssetImage('assets/banner/banner.jpg'), fit: BoxFit.cover),
          ),
          child: Container(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  const Color.fromRGBO(162, 146, 199, 0.9),
                  const Color.fromRGBO(51, 51, 63, 0.9),
                ],
                stops: [0.2, 1.0],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(0.0, 1.0),
              ),
            ),
            child: ListView(
              padding: const EdgeInsets.all(0.0),
              children: <Widget>[
                Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 80.0),
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(image: new ExactAssetImage('assets/icon/icon.jpg')),
                            ),
                          ),
                        ),
                        // SizedBox(height: 140),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Obx(() {
                                return Form(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      CustomTextField(
                                        controller: controller.usuarioController.value,
                                        hint: 'userName'.tr,
                                        keyboardType: TextInputType.emailAddress,
                                        obscure: false,
                                        icon: Icons.person_outline,
                                      ),
                                      CustomTextField(
                                        controller: controller.senhaController.value,
                                        hint: 'password'.tr,
                                        keyboardType: TextInputType.multiline,
                                        obscure: true,
                                        icon: Icons.lock_outline,
                                        editing: () => controller.login(_loginButtonController),
                                      ),
                                    ],
                                  ),
                                );
                              })
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 80),
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 20.0),
                            width: Get.width,
                            decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(10)), color: cor_secondary),
                            child: TextButton(
                              onPressed: () => controller.buttonState.value == false ? Get.to(() => Register()) : null,
                              child: Text(
                                "sign_Up".tr,
                                style: TextStyle(fontWeight: FontWeight.w300, letterSpacing: 0.8, color: Colors.white, fontSize: 12.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ///Animation Button
                    Obx(() {
                      return AbsorbPointer(
                        absorbing: controller.buttonState.value,
                        child: LoadingButton(
                          buttonController: _loginButtonController,
                          textLabel: 'login'.tr,
                          local: 'login',
                          color: cor_primary,
                          loading: SleekCircularSlider(
                            appearance: CircularSliderAppearance(
                              size: 40,
                              spinnerMode: true,
                              customColors: CustomSliderColors(
                                  progressBarColors: [Colors.black, Colors.white],
                                  dynamicGradient: true,
                                  shadowMaxOpacity: 0.05
                              ),
                            ),
                          ),
                          onTap: () => controller.login(_loginButtonController),
                        ),
                      );
                    })
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() {
    return Get.defaultDialog(
      title: 'alert'.tr,
      content: Text('exitAPP'.tr),
      actions: [
        TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
        TextButton(onPressed: () => exit(0), child: Text('yes'.tr)),
      ],
    );
  }
}