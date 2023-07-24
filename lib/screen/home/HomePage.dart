import 'dart:ui';
import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../authentication/login/login_page.dart';
import 'package:animationlogin2/screen/qr/QrPage.dart';
import 'package:animationlogin2/models/list_model.dart';
import 'package:animationlogin2/screen/imei/ImeiPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animationlogin2/screen/audio/AudioPage.dart';
import 'package:animationlogin2/animations/FadeAnimation.dart';
import 'package:animationlogin2/screen/conversor/ConversorPage.dart';
import 'package:animationlogin2/animations/pageAnimationController.dart';
import 'package:animationlogin2/screen/localization/LocalizationPage.dart';
import 'package:animationlogin2/screen/accelerometer/AccelerometerPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController pageController = PageController(initialPage: 0, viewportFraction: 0.7);
  List<ListModel> mySLides = [];
  List<String> listCategory = ["Imei", "audioTitle".tr, "localizationTitle".tr, "QR", "accelerometerTitle".tr, "conversor".tr];

  @override
  void initState() {
    super.initState();
    mySLides = getSlides();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ChangeNotifierProvider(
        create: (_) => PageOffsetNotifier(pageController, mySLides.length),
        lazy: false,
        child: Stack(
          children: <Widget>[
            /// Background imagem
            Consumer<PageOffsetNotifier>(
              builder: (context, offsetNotifier, _) {
                return ClipPath(
                  clipper: CoverClipper(offsetNotifier.page),
                  child: Container(
                    width: Get.width,
                    height: Get.height,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(mySLides[offsetNotifier.page.toInt()].poster),
                      ),
                    ),
                  ),
                );
              },
            ),
            /// BlurEffect
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18.0, sigmaY: 18.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.6)),
              ),
            ),
            SafeArea(
              child: ListView(
                children: [
                  FadeAnimation(
                    fadeDirection: FadeDirection.left,
                    delay: 1.5,
                    child: Padding(
                      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ferramenta 3.0',
                            textAlign: TextAlign.start,
                            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: Icon(Icons.exit_to_app, color: Colors.white),
                            onPressed: () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.remove('logado');
                              Get.offAll(() => Login());
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  FadeAnimation(
                    fadeDirection: FadeDirection.right,
                    delay: 1.5,
                    child: Container(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: listCategory.length,
                        itemBuilder: (context, index) {
                          return Consumer<PageOffsetNotifier>(
                            builder: (context, offsetNotifier, _) {
                              var scrollIndex = 0;
                              scrollIndex = int.parse((offsetNotifier.page).toStringAsFixed(0));
                              return Center(
                                child: GestureDetector(
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 500),
                                    height: 30,
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: scrollIndex == index ? Color(0xFFFDCD00) : Colors.transparent,
                                      borderRadius: BorderRadius.all(Radius.circular(25)),
                                    ),
                                    child: Text(
                                      listCategory[index],
                                      textAlign: TextAlign.start,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  FadeAnimation(
                    fadeDirection: FadeDirection.left,
                    delay: 2.5,
                    child: Container(
                      height: 250,
                      child: PageView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: mySLides.length,
                        controller: pageController,
                        itemBuilder: (BuildContext context, int index) {
                          String heroTagPoster = index.toString();
                          return Consumer<PageOffsetNotifier>(
                            builder: (context, offsetNotifier, _) {
                              double marginTopAndBottom = (offsetNotifier.page - index).abs() * 15;
                              return GestureDetector(
                                onTap: () {
                                  switch(index) {
                                    case 0:
                                      Get.to(() => ImeiPage());
                                      break;
                                    case 1:
                                      Get.to(() => AudioPage());
                                      break;
                                    case 2:
                                      Get.to(() => LocalizationPage());
                                      break;
                                    case 3:
                                      Get.to(() => QrPage());
                                      break;
                                    case 4:
                                      Get.to(() => AccelerometerPage());
                                      break;
                                    case 5:
                                      Get.to(() => ConversorPage());
                                      break;
                                    default:
                                      break;
                                  }
                                },
                                child: Hero(
                                  tag: heroTagPoster,
                                  child: Container(
                                    margin: EdgeInsets.only(right: 20, bottom: marginTopAndBottom, top: marginTopAndBottom),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                      image: DecorationImage(
                                        image: AssetImage(mySLides[index].poster),
                                        alignment: Alignment.bottomCenter,
                                        fit: BoxFit.cover,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black.withOpacity(0.3), offset: Offset(2, 2), blurRadius: 4
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  FadeAnimation(
                    fadeDirection: FadeDirection.left,
                    delay: 3,
                    child: Consumer<PageOffsetNotifier>(builder: (context, offsetNotifier, _) {
                      return Padding(
                        padding: EdgeInsets.only(left: 28, top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              mySLides[offsetNotifier.page.round()].firstTitle,
                              textAlign: TextAlign.start,
                              style: TextStyle(color: Colors.white, fontSize: 25, fontFamily: 'Tomb Raider', fontWeight: FontWeight.normal),
                            ),
                            SizedBox(height: 10),
                            Text(mySLides[offsetNotifier.page.round()].desc, textAlign: TextAlign.start, style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      );
                    }),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CoverClipper extends CustomClipper<Path> {
  double page;

  CoverClipper(this.page);

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width * (page - page.floor()), size.height);
    path.lineTo(size.width * (page - page.floor()), 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CoverClipper oldClipper) => page != oldClipper.page;
}