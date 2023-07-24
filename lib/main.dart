import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'translations/translations.dart';
import 'package:animationlogin2/controller..dart';

void main() => runApp(
      GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AnimationLogin_Ver.2',
        home: Splash(),
        translations: Translation(),
        locale: Get.deviceLocale,
        fallbackLocale: Get.deviceLocale,
      ),
    );

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  void initState() {
    super.initState();
    session.logado();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image.asset(
            "assets/banner/banner.jpg",
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          Container(
            alignment: FractionalOffset.center,
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white)),
          ),
        ],
      ),
    );
  }
}