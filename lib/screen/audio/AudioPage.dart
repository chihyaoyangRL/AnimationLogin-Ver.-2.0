import 'dart:async';
import 'AudioController.dart';
import 'package:get/get.dart';
import '../../controller..dart';
import 'package:record/record.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:animationlogin2/utils/constants.dart';
import 'package:animationlogin2/models/audio_model.dart';
import 'package:animated_icon_button/animated_icon_button.dart';

enum PlayerState { stopped, playing, paused }

class AudioPage extends StatefulWidget {
  @override
  _AudioPageState createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  final AudioController controller = Get.put(AudioController());
  Timer _timer;
  StreamSubscription _positionSubscription;
  StreamSubscription _audioPlayerStateSubscription;
  Duration duration;
  Duration position;
  PlayerState playerState = PlayerState.stopped;

  get isPlaying => playerState == PlayerState.playing;

  get isPaused => playerState == PlayerState.paused;

  get durationText => duration != null ? duration.toString().split('.').first : '';

  get positionText => position != null ? position.toString().split('.').first : '';

  @override
  void initState() {
    super.initState();
    initAudioPlayer();
    controller.createPath();
    controller.getAll();
    controller.isRecording.value = false;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _positionSubscription.cancel();
    _audioPlayerStateSubscription.cancel();
    controller.audioPlayer.stop();
    super.dispose();
  }

  /// Audio Player
  void initAudioPlayer() {
    controller.audioPlayer = AudioPlayer();
    _positionSubscription = controller.audioPlayer.onAudioPositionChanged.listen((p) => setState(() => position = p));
    _audioPlayerStateSubscription = controller.audioPlayer.onPlayerStateChanged.listen((s) {
      if (s == AudioPlayerState.PLAYING) {
        setState(() => duration = controller.audioPlayer.duration);
      } else if (s == AudioPlayerState.STOPPED) {
        onComplete();
        setState(() => position = duration);
      }
    }, onError: (msg) {
      setState(() {
        playerState = PlayerState.stopped;
        duration = Duration(seconds: 0);
        position = Duration(seconds: 0);
      });
    });
  }

  Future _playLocal(path) async {
    controller.show.value = true;
    await controller.audioPlayer.play(path, isLocal: true);
    setState(() => playerState = PlayerState.playing);
  }

  Future pause() async {
    await controller.audioPlayer.pause();
    setState(() => playerState = PlayerState.paused);
  }

  Future stop() async {
    await controller.audioPlayer.stop();
    setState(() {
      playerState = PlayerState.stopped;
      position = Duration();
    });
  }

  void onComplete() => setState(() => playerState = PlayerState.stopped);

  /// Recording
  Future<void> _start() async {
    try {
      if (await Record.hasPermission()) {
        await controller.getPath();
        await Record.start(path: controller.path.value);
        bool isRecording = await Record.isRecording();
        controller.isRecording.value = isRecording;
        controller..recordDuration.value = 0;
        _startTimer();
      } else {
        dialogs.showSnackBar('permission'.tr, Icons.warning);
      }
    } catch (e) {
      print(e);
      dialogs.showSnackBar('permission'.tr, Icons.warning);
    }
  }

  Future<void> _stop() async {
    _timer?.cancel();
    await Record.stop();
    controller.isRecording.value = false;
    audioRepository.insert(AudioModel(path: controller.path.value));
    controller.getAll();
  }

  Future<void> _pause() async {
    _timer?.cancel();
    await Record.pause();
    controller.isPaused.value = true;
  }

  Future<void> _resume() async {
    _startTimer();
    await Record.resume();
    controller.isPaused.value = false;
  }

  void _startTimer() {
    const tick = const Duration(seconds: 1);
    _timer?.cancel();
    _timer = Timer.periodic(tick, (Timer t) => controller.recordDuration.value++);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text('audioTitle'.tr),
        backgroundColor: cor_primary,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 10),
              ClipOval(
                child: Obx(() {
                  return Material(
                    color: (controller.isRecording.value || controller.isPaused.value) ? Colors.red.withOpacity(0.1) : cor_primary.withOpacity(0.1),
                    child: InkWell(
                      child: SizedBox(
                          width: 56,
                          height: 56,
                          child: (controller.isRecording.value || controller.isPaused.value)
                              ? Icon(Icons.stop, color: Colors.red, size: 30)
                              : Icon(Icons.mic, color: cor_primary, size: 30)
                      ),
                      onTap: () => controller.isRecording.value ? _stop() : _start(),
                    ),
                  );
                }),
              ),
              const SizedBox(width: 20),
              Obx(() {
                return ((!controller.isRecording.value && !controller.isPaused.value))
                    ? SizedBox.shrink()
                    : ClipOval(
                        child: Material(
                          color: !controller.isPaused.value ? Colors.red.withOpacity(0.1) : cor_primary.withOpacity(0.1),
                          child: InkWell(
                            child: SizedBox(
                                width: 56,
                                height: 56,
                                child: !controller.isPaused.value
                                    ? Icon(Icons.pause, color: Colors.red, size: 30)
                                    : Icon(Icons.play_arrow, color: Colors.red, size: 30)
                            ),
                            onTap: () => controller.isPaused.value ? _resume() : _pause(),
                          ),
                        ),
                      );
              }),
              const SizedBox(width: 20),
              Obx(() {
                return (controller.isRecording.value || controller.isPaused.value)
                    ? Text('${controller.formatNumber(controller.recordDuration.value ~/ 60)} : ${controller.formatNumber(controller.recordDuration.value % 60)}', style: TextStyle(color: Colors.red))
                    : Text("awaitRecord".tr);
              })
            ],
          ),
          /// Audio Player
          Container(
            color: cor_secondary,
            height: 150,
            width: Get.width,
            child: (position != null && duration != null)
                ? Obx(() {
                    return Visibility(
                      visible: controller.show.value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AnimatedIconButton(
                                    size: 25,
                                    icons: [
                                      AnimatedIconItem(
                                        onPressed: () => controller.mute(true),
                                        icon: Icon(Icons.headset, color: Colors.white),
                                      ),
                                      AnimatedIconItem(
                                        onPressed: () => controller.mute(false),
                                        icon: Icon(Icons.headset_off, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  /// Progress
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 25,
                                      width: 25,
                                      child: CircularProgressIndicator(value: position != null && position.inMilliseconds > 0 ? (position?.inMilliseconds?.toDouble() ?? 0.0) / (duration?.inMilliseconds?.toDouble() ?? 0.0) : 0.0,
                                        valueColor: AlwaysStoppedAnimation(Colors.white),
                                        backgroundColor: cor_primary,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          Text("${positionText ?? ''} / ${durationText ?? ''} ", style: TextStyle(fontSize: 24.0, color: Colors.white)),
                          AbsorbPointer(
                            child: Slider(
                              activeColor: Colors.white,
                              value: position?.inMilliseconds?.toDouble() ?? 0.0,
                              onChanged: (double value) => controller.audioPlayer.seek((value / 1000).roundToDouble()),
                              min: 0.0,
                              max: duration.inMilliseconds.toDouble(),
                            ),
                          )
                        ],
                      ),
                    );
                  })
                : Container(),
          ),
          Expanded(
            child: Obx(() {
              return FutureBuilder<List<AudioModel>>(
                future: controller.audio.value,
                builder: (context, snapshot) => list(context, snapshot),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget list(context, snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
      case ConnectionState.waiting:
        return Center(child: loading.loader(cor_primary));
        break;
      case ConnectionState.active:
      case ConnectionState.done:
        if (snapshot.data != null && !snapshot.data.isEmpty) {
          return ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 5),
            padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0, bottom: 90.0),
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              AudioModel audios = List<AudioModel>.from(snapshot.data)[index];
              return Dismissible(
                key: Key(audios.id.toString()),
                background: Container(color: Colors.red),
                onDismissed: (direction) async {
                  await audioRepository.delete(audios.id);
                  controller.show.value = false;
                  dialogs.showSnackBar('fileDelete'.trParams({'pathName': exp.firstMatch(audios.path).group(1)}), Icons.delete);
                },
                child: Container(
                  color: cor_secondary,
                  height: 80,
                  width: Get.width,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(exp.firstMatch(audios.path).group(1), style: TextStyle(color: Colors.white)),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: isPlaying ? null : () => _playLocal(audios.path),
                            iconSize: 25.0,
                            icon: Icon(Icons.play_arrow, color: Colors.white),
                          ),
                          IconButton(
                            onPressed: isPlaying ? () => pause() : null,
                            iconSize: 25.0,
                            icon: Icon(Icons.pause, color: Colors.white),
                          ),
                          IconButton(
                            onPressed: isPlaying || isPaused ? () => stop() : null,
                            iconSize: 25.0,
                            icon: Icon(Icons.stop, color: Colors.white),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return Center(child: Text('notFound'.tr, style: TextStyle(color: Colors.red)));
        }
        break;
    }
    return null;
  }
}