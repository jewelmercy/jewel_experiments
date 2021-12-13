//Defining size for make app responsive
import 'dart:core';
import 'package:flutter/widgets.dart';

class SizeConfig {
   MediaQueryData? _mediaQueryData;
  static  double? screenWidth;
  static  double? screenHeight;
  static  double? blockSizeWidth;
  static  double? blockSizeHeight;

  static  double? _safeAreaHorizontal;
  static  double? _safeAreaVertical;
  static  double? safeBlockHorizontal;
  static  double? safeBlockVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
    blockSizeWidth = (screenWidth! / 100);
    blockSizeHeight = screenHeight! / 100;

    _safeAreaHorizontal =
        _mediaQueryData!.padding.left + _mediaQueryData!.padding.right;
    _safeAreaVertical =
        _mediaQueryData!.padding.top + _mediaQueryData!.padding.bottom;
    safeBlockHorizontal = (screenWidth! - _safeAreaHorizontal!) / 100;
    safeBlockVertical = (screenHeight! - _safeAreaVertical!) / 100;
  }
}