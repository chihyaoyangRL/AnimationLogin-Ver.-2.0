import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../animations/loginAnimation.dart';
import 'package:flare_flutter/flare_actor.dart';
import '../authentication/login/LoginController.dart';
import 'package:flare_flutter/flare_cache_builder.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import '../authentication/register/RegisterController.dart';

class LoadingButton extends StatefulWidget {
  final GestureTapCallback onTap;
  final Color color;
  final Widget loading;
  final String textLabel, local;
  final AnimationController buttonController;

  LoadingButton({@required this.onTap, @required this.color, @required this.loading, this.textLabel, this.local, this.buttonController});

  @override
  _LoadingButtonState createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  final LoginController loginController = Get.find();
  final RegisterController singUpController = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GestureDetector(
        onTap: widget.onTap,
        child: (widget.local == 'registro' ? singUpController.loadingbuttonSucess.value == true : loginController.loadingbuttonSucess.value == true)
            ? StaggerAnimation(buttonController: widget.buttonController.view, type: widget.local)
            : Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: AnimatedContainer(
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  height: 50,
                  width: widget.local == 'registro' ? singUpController.loadingwidth.value : loginController.loadingwidth.value,
                  duration: Duration(milliseconds: 300),
                  decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(10)), color: widget.color),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 350),
                      transitionBuilder: (Widget child, Animation<double> animation) => ScaleTransition(child: child, scale: animation),
                      child: (widget.local == 'registro' ? singUpController.loadingbuttonStatus.value : loginController.loadingbuttonStatus.value)
                          ? SizedBox(height: 45, width: 45, child: widget.loading)
                          : (widget.local == 'registro' ? singUpController.loadingbuttonSucess.value == true : loginController.loadingbuttonSucess.value == true)
                              ? Container()
                              : (widget.local == 'registro' ? singUpController.loadingbuttonErro.value == true : loginController.loadingbuttonErro.value == true)
                                  ? FlareCacheBuilder(
                                      [AssetFlare(bundle: rootBundle, name: 'assets/flare/error.flr')],
                                      builder: (BuildContext context, bool isWarm) => !isWarm
                                          ? Container()
                                          : FlareActor("assets/flare/error.flr", alignment: Alignment.center, animation: "Error"),
                                    )
                                  : Text(widget.textLabel, style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ),
      );
    });
  }
}