import 'package:get/get.dart';

class ListModel {
  String title;
  String desc;
  String poster;

  String get firstTitle => title.split(" ")[0];

  ListModel({this.title, this.desc, this.poster});
}

List<ListModel> getSlides() {
  List<ListModel> list = [
    ListModel(
        title: "Imei",
        desc: "imeiDesc".tr,
        poster: "assets/screen/imei.png"),
    ListModel(
        title: "audioTitle".tr,
        desc: "audioDesc".tr,
        poster: "assets/screen/audio.jpg"),
    ListModel(
        title: "localizationTitle".tr,
        desc: "localizationDesc".tr,
        poster: "assets/screen/localization.png"),
    ListModel(
        title: "QR",
        desc: "qrDesc".tr,
        poster: "assets/screen/qr.png"),
    ListModel(
        title: "accelerometerTitle".tr,
        desc: "accelerometerDesc".tr,
        poster: "assets/screen/acelerometer.png"),
    ListModel(
        title: "conversor".tr,
        desc: "conversorDesc".tr,
        poster: "assets/screen/finance.jpg"),
  ];
  return list;
}