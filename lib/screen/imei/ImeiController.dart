import 'dart:io';
import 'package:get/get.dart';
import '../../controller..dart';
import 'package:flutter/material.dart';
import 'package:device_info/device_info.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:ios_utsname_ext/extension.dart';

class ImeiController extends GetxController {
  RxString imei = ''.obs;
  RxString model = ''.obs;

  getDeviceInfo() async {
    try {
      await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: false);
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        model.value = androidInfo.model;
        imei.value = await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: false);
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        model.value = iosInfo.utsname.machine.iOSProductName;
        imei.value = iosInfo.identifierForVendor;
      }
    } catch(e) {
      dialogs.showSnackBar('permission'.tr, Icons.warning);
    }
  }
}