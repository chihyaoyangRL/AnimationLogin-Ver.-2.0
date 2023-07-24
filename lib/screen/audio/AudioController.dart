import 'dart:io';
import 'dart:async';
import 'package:get/get.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:animationlogin2/controller..dart';
import 'package:animationlogin2/utils/constants.dart';
import 'package:animationlogin2/models/audio_model.dart';

class AudioController extends GetxController {
  AudioPlayer audioPlayer;
  final audio = Future.value(<AudioModel>[]).obs;
  RxString path = ''.obs;
  RxBool isRecording = false.obs;
  RxBool isPaused = false.obs;
  RxBool show = false.obs;
  RxInt recordDuration = 0.obs;

  createPath() async {
    Directory appDocDir = (Platform.isIOS) ? await getApplicationDocumentsDirectory() : await getExternalStorageDirectory();
    var audio = new Directory(appDocDir.path + audioPath);
    if (await audio.exists() == false) {
      audio.create().then((Directory directory) {});
    }
  }

  Future<String> getPath() async {
    createPath();
    Directory appDocDir = (Platform.isIOS) ? await getApplicationDocumentsDirectory() : await getExternalStorageDirectory();
    String pathAudio = appDocDir.path + audioPath;
    path.value = pathAudio + DateTime.now().millisecondsSinceEpoch.toString() + '.mp3';
    return path.value;
  }

  String formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0' + numberStr;
    }
    return numberStr;
  }

  getAll() => audio.value = audioRepository.queryAllRows();

  Future mute(bool muted) async => await audioPlayer.mute(muted);
}