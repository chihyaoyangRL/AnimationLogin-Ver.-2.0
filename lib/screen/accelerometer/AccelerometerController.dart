import 'package:get/get.dart';

class AccelerometerController extends GetxController {
  RxDouble x = 0.0.obs;
  RxDouble y = 0.0.obs;
  RxDouble z = 0.0.obs;
  RxDouble top = 125.0.obs;
  RxDouble left = 0.0.obs;
  RxBool sensorStatus = false.obs;
}