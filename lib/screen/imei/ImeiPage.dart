import 'package:get/get.dart';
import '../../utils/constants.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:animationlogin2/screen/imei/ImeiController.dart';

class ImeiPage extends StatefulWidget {
  @override
  _ImeiPageState createState() => _ImeiPageState();
}

class _ImeiPageState extends State<ImeiPage> {
  final ImeiController controller = Get.put(ImeiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark, /// fix status bar text color
        title: Text('Imei'),
        backgroundColor: cor_primary,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Imei: '),
                    Obx(() => Text(controller.imei.value)),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('model'.tr),
                    Obx(() => Text(controller.model.value)),
                  ],
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => controller.getDeviceInfo(),
            child: Text('deviceInfo'.tr),
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
              minimumSize: Size(Get.width, 50),
              primary: Colors.white,
              backgroundColor: cor_primary,
            ),
          ),
        ],
      ),
    );
  }
}