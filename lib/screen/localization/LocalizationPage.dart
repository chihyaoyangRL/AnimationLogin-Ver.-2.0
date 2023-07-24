import 'package:get/get.dart';
import '../../controller..dart';
import 'package:share/share.dart';
import '../../utils/constants.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:animationlogin2/screen/localization/LocalizationController.dart';

class LocalizationPage extends StatefulWidget {
  @override
  _LocalizationPageState createState() => _LocalizationPageState();
}

class _LocalizationPageState extends State<LocalizationPage> {
  final LocalizationController controller = Get.put(LocalizationController());

  @override
  void initState() {
    super.initState();
    controller.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text('localizationTitle'.tr),
        backgroundColor: cor_primary,
      ),
      body: Obx(() {
        return controller.isLoading.value == true
            ? Center(child: loading.loader(cor_primary))
            : Stack(
                children: [
                  FlutterMap(
                    options: new MapOptions(
                      //Localização Inicial
                      center: new LatLng(controller.latitude.value, controller.longitude.value),
                      zoom: zoom, //Zoom inicial
                      minZoom: minZoom, //Zoom minímo
                      maxZoom: maxZoom, //Zoom máximo
                    ),
                    layers: [
                      new TileLayerOptions(
                        urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c'],
                      ),
                      new MarkerLayerOptions(markers: controller.marker),
                    ],
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      color: Colors.grey.withOpacity(0.6),
                      child: Text('© OpenStreetMap contributors'),
                    ),
                  )
                ],
              );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final RenderBox box = context.findRenderObject();
          Share.share(controller.link, sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
        },
        backgroundColor: cor_primary,
        child: Icon(Icons.my_location_outlined),
      ),
    );
  }
}