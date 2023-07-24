import 'dart:io';
import 'package:get/get.dart';
import '../../controller..dart';
import 'package:latlong/latlong.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:permission_handler/permission_handler.dart';

class LocalizationController extends GetxController {
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  RxBool isLoading = true.obs;
  List<Marker> marker = [];
  String link = '';

  getLocation() async {
    isLoading.value = true;
    if (await Geolocator.isLocationServiceEnabled() == true) {
      if (await Permission.location.request().isGranted) {
        await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((location) {
          latitude.value = location.latitude;
          longitude.value = location.longitude;
          link = 'http://maps.google.com/maps?z=12&t=m&q=loc:${latitude.value}+${longitude.value}';
          marker.add(
            Marker(
              height: 40,
              width: 40,
              point: new LatLng(latitude.value, longitude.value),
              builder: (ctx) => Image.asset('assets/screen/pointer.png'),
            ),
          );
          isLoading.value = false;
        }).catchError((e) {
          print('Error: ' + e.toString());
          isLoading.value = false;
          Get.back();
          dialogs.showSnackBar('locationError'.tr, Icons.warning);
        });
      } else {
        isLoading.value = false;
        (Platform.isIOS) ? dialogs.showSnackBar('locationError'.tr, Icons.warning) : await Geolocator.openAppSettings();
        Get.back();
      }
    } else {
      isLoading.value = false;
      (Platform.isIOS) ? dialogs.showSnackBar('locationError'.tr, Icons.warning) : await Geolocator.openLocationSettings();
      Get.back();
    }
  }
}