import 'package:flutter/material.dart';

class ColorManager {
  static Color bgColor = const Color.fromRGBO(59, 47, 47, 1);
  static Color textColor = const Color.fromRGBO(255, 213, 79, 1);
  static Color orangeColor = const Color.fromRGBO(255, 132, 43, 1);
  static Color deepOrange = const Color.fromRGBO(255, 132, 43, 1);
  static Color darkTextColor = const Color.fromRGBO(7, 7, 7, 1);


  static Color primaryColor = const Color.fromRGBO(255, 213, 79, 1);
  static Color textFilledColor = HexColor.fromHex("#EEF6FC");
  static Color blackTextColor = const Color.fromRGBO(14, 16, 18, 1);
  static Color disabledButtonColor = const Color.fromRGBO(232, 235, 237, 1);

  static Color lightTextColor = HexColor.fromHex("#657B9A");
  static Color whiteColor = HexColor.fromHex("#FFFFFF");
  static Color containerShadow = HexColor.fromHex("#2C3A4E14");
  static Color accentColor = HexColor.fromHex("#F1C00F");
  static Color greenColor = const Color.fromRGBO(4, 140, 91, 1);
  static Color cardColor = HexColor.fromHex("#F3F4F7");
  static Color hintColor = HexColor.fromHex("#C1CAD7");
  static Color labelColor = HexColor.fromHex("#657B9A");
  static Color errorColor = HexColor.fromHex("#CC334F");
  static Color redColor = HexColor.fromHex("#FF0000");
  static Color blackColor = HexColor.fromHex("#031F4C");





}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll("#", '');

    if (hexColorString.length == 6) {
      hexColorString = "FF" + hexColorString;
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}
