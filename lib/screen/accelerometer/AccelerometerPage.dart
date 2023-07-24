import 'dart:async';
import 'package:get/get.dart';
import '../../utils/constants.dart';
import 'AccelerometerController.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sensors/flutter_sensors.dart';

class AccelerometerPage extends StatefulWidget {
  @override
  _AccelerometerPageState createState() => _AccelerometerPageState();
}

class _AccelerometerPageState extends State<AccelerometerPage> {
  final AccelerometerController controller = Get.put(AccelerometerController());
  StreamSubscription _accelSubscription;

  @override
  void initState() {
    super.initState();
    _checkAccelerometerStatus();
  }

  void _checkAccelerometerStatus() async {
    await SensorManager().isSensorAvailable(Sensors.ACCELEROMETER).then((result) {
      controller.sensorStatus.value = result;
      _startAccelerometer();
    });
  }

  Future<void> _startAccelerometer() async {
    if (controller.sensorStatus.value) {
      final stream = await SensorManager().sensorUpdates(sensorId: Sensors.ACCELEROMETER, interval: Sensors.SENSOR_DELAY_FASTEST);
      _accelSubscription = stream.listen((sensorEvent) {
        // sensorEvent.data[0] x
        // sensorEvent.data[1] y
        // sensorEvent.data[2] z
        controller.left.value = ((sensorEvent.data[0] * 12) + ((Get.width - 100) / 2));
        controller.top.value = sensorEvent.data[1] * 12 + 125;
        controller.x.value = sensorEvent.data[0];
        controller.y.value = sensorEvent.data[1];
        controller.z.value = sensorEvent.data[2];
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _stopAccelerometer();
  }

  void _stopAccelerometer() {
    if (_accelSubscription == null) return;
    _accelSubscription.cancel();
    _accelSubscription = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text('accelerometerTitle'.tr),
        backgroundColor: cor_primary,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Obx(() => Text('Sensor status: ${controller.sensorStatus.value}')),
          ),
          Stack(
            children: [
              Container(height: Get.height / 2, width: Get.width),
              Obx(() {
                return Positioned(
                  top: controller.top.value,
                  left: controller.left.value ?? (Get.width - 100) / 2,
                  child: ClipOval(child: Container(width: 25, height: 25, color: cor_primary)),
                );
              }),
            ],
          ),
          Obx(() => Text('x: ${(controller.x.value ?? 0).toStringAsFixed(3)}')),
          Obx(() => Text('y: ${(controller.y.value ?? 0).toStringAsFixed(3)}')),
          Obx(() => Text('z: ${(controller.z.value ?? 0).toStringAsFixed(3)}')),
        ],
      ),
    );
  }
}