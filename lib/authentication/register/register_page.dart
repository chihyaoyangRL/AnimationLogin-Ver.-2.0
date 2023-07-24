import 'package:get/get.dart';
import 'RegisterController.dart';
import '../../utils/constants.dart';
import 'package:flutter/material.dart';
import '../../widget/Custom_Loading_Button.dart';
import 'package:animationlogin2/widget/CustomTextField.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> with TickerProviderStateMixin {
  final RegisterController controller = Get.put(RegisterController());
  AnimationController _registerButtonController;

  @override
  void initState() {
    super.initState();
    _registerButtonController = new AnimationController(duration: new Duration(milliseconds: 3000), vsync: this);
  }

  @override
  void dispose() {
    _registerButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                const Color.fromRGBO(162, 146, 199, 0.7),
                const Color.fromRGBO(51, 51, 63, 0.7),
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
                      SizedBox(height: 120),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Form(
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
                                  ),
                                  CustomTextField(
                                    controller: controller.repeatSenhaController.value,
                                    hint: 'rep_password'.tr,
                                    keyboardType: TextInputType.multiline,
                                    obscure: true,
                                    icon: Icons.verified_user_sharp,
                                    editing: () => controller.cadastro(_registerButtonController),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(top: 80),
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 20.0),
                            child: TextButton(
                              onPressed: () => controller.buttonState.value == false ? Get.back() : null,
                              child: Text(
                                'back'.tr,
                                style: TextStyle(fontWeight: FontWeight.w300, letterSpacing: 0.8, color: Colors.white, fontSize: 12.0),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  ///Animation Button
                  Obx(() {
                    return AbsorbPointer(
                      absorbing: controller.buttonState.value,
                      child: LoadingButton(
                        buttonController: _registerButtonController,
                        textLabel: 'sign_Up'.tr,
                        local: 'registro',
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
                        onTap: () => controller.cadastro(_registerButtonController),
                      ),
                    );
                  })
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}