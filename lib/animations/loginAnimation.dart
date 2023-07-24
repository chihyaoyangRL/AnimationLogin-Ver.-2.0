import 'package:get/get.dart';
import '../utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:animationlogin2/screen/home/HomePage.dart';
import '../authentication/register/RegisterController.dart';
import 'package:animationlogin2/authentication/login/LoginController.dart';

class StaggerAnimation extends StatelessWidget {
  StaggerAnimation({Key key, this.buttonController, this.type})
      : buttonSqueezeanimation = Tween(begin: 320.0, end: 70.0).animate(
          CurvedAnimation(
            parent: buttonController,
            curve: Interval(0.0, 0.150),
          ),
        ),
        buttomZoomOut = Tween(begin: 70.0, end: 1000.0).animate(
          CurvedAnimation(
            parent: buttonController,
            curve: Interval(0, 0.999, curve: Curves.bounceOut),
          ),
        ),
        containerCircleAnimation = EdgeInsetsTween(
          begin: const EdgeInsets.only(bottom: 50.0),
          end: const EdgeInsets.only(bottom: 0.0),
        ).animate(
          CurvedAnimation(
            parent: buttonController,
            curve: Interval(0.500, 0.800, curve: Curves.ease),
          ),
        ),
        super(key: key);

  final AnimationController buttonController;
  final String type;
  final Animation<EdgeInsets> containerCircleAnimation;
  final Animation buttonSqueezeanimation;
  final Animation buttomZoomOut;
  final LoginController loginController = Get.find();
  final RegisterController signUpController = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    buttonController.addListener(() {
      if (buttonController.isCompleted) {
        Get.offAll(() => HomePage());
        if (type == 'registro') {
          signUpController.loadingButtonOff();
        } else {
          loginController.loadingButtonOff();
        }
        loginController.clearForm();
        signUpController.clearForm();
      }
    });
    return AnimatedBuilder(
      animation: buttonController,
      builder: (context, child) {
        return Padding(
          padding: buttomZoomOut.value == 70 ? const EdgeInsets.only(bottom: 50.0) : containerCircleAnimation.value,
          child: Container(
            width: buttomZoomOut.value,
            height: buttomZoomOut.value,
            decoration: BoxDecoration(
              shape: buttomZoomOut.value < 500 ? BoxShape.rectangle : BoxShape.rectangle,
              color: cor_primary,
            ),
          ),
        );
      },
    );
  }
}