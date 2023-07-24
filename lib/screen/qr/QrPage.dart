import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animationlogin2/utils/constants.dart';
import 'package:animationlogin2/screen/qr/QrController.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class QrPage extends StatefulWidget {
  @override
  _QrPageState createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  final QrController controller = Get.put(QrController());
  String barcodeScanRes;

  Future<void> scanQR() async {
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'cancel'.tr, true, ScanMode.QR);
      controller.results.value = barcodeScanRes;
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text('QR'),
        backgroundColor: cor_primary,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () => scanQR(),
              style: ElevatedButton.styleFrom(primary: cor_primary),
              child: Text('scan'.tr),
            ),
          ),
          SizedBox(height: 20),
          Obx(() {
            return InkWell(
              onTap: () => (controller.results.value == 'Unknown' || controller.results.value == '-1') ? null : launch(controller.results.value),
              child: Text(controller.results.value, style: TextStyle(color: Colors.blue)),
            );
          })
        ],
      ),
    );
  }
}