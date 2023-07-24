import 'dart:math';
import 'package:flutter/material.dart';

class PageOffsetNotifier with ChangeNotifier {
  double _offset = 0;
  double _page = 0;
  int _moviesLength = 0;

  PageOffsetNotifier(PageController pageController, int moviesLength) {
    pageController.addListener(() {
      _offset = pageController.offset;
      _page = min(pageController.page, moviesLength - 1.toDouble());
      _moviesLength = moviesLength;
      notifyListeners();
    });
  }

  double get offset => _offset;
  double get page => _page;
  bool get isLast => _page >= _moviesLength - 1;
}