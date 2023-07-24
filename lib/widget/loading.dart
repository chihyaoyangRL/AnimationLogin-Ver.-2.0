import '../utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class LoadingWidgets extends State {
  Widget loader(Color color) {
    return SleekCircularSlider(
      appearance: CircularSliderAppearance(
        customColors: CustomSliderColors(progressBarColors: [(color == Color(0xffffffff)) ? cor_primary : Colors.white, color], dynamicGradient: true, shadowMaxOpacity: 0.05), spinnerMode: true,
        size: 50,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Container();
}