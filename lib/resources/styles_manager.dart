import 'package:flutter/material.dart';

import 'font_manager.dart';

TextStyle _getTextStyle(
    double fontSize, String fontFamily, Color textColor, FontWeight fontWeight,
    ) {
  return TextStyle(
    fontSize: fontSize,
    fontFamily: fontFamily,
    color: textColor,
    fontWeight: fontWeight,
  );
}

TextStyle _getTextStyleWithLineHeight(
    double fontSize, String fontFamily, Color textColor, FontWeight fontWeight,
    double lineHeight) {
  return TextStyle(
      fontSize: fontSize,
      fontFamily: fontFamily,
      color: textColor,
      fontWeight: fontWeight,
      height: lineHeight,

    decoration: TextDecoration.none,
  );
}

TextStyle _getDecoratedTextStyle(
  double fontSize,
  String fontFamily,
  Color textColor,
  FontWeight fontWeight,
) {
  return TextStyle(
    fontSize: fontSize,
    fontFamily: fontFamily,
    color: textColor,
    fontWeight: fontWeight,
    decoration: TextDecoration.underline,
  );
}

//Bold Style
TextStyle getBoldStyle(
    {double fontSize = FontSize.s24, required Color textColor}) {
  return _getTextStyle(fontSize, FontConstants.fontFamily, textColor,
      FontWeightManager.semiBold);
}

//Bold Style
TextStyle getAppBarTitleStyle(
    {double fontSize = FontSize.s16, required Color textColor}) {
  return _getTextStyle(
      fontSize, FontConstants.fontFamily, textColor, FontWeightManager.title);
}

//Bold Style
// TextStyle getDecoratedTextStyle({double fontSize = FontSize.s16, required Color textColor}){
//   return _getDecoratedTextStyle(fontSize, FontConstants.fontFamily, textColor, FontWeightManager.title);
// }

TextStyle getDecoratedTextStyle(
    {double fontSize = FontSize.s16, required Color textColor}) {
  return _getDecoratedTextStyle(
    fontSize,
    FontConstants.fontFamily,
    textColor,
    FontWeightManager.medium,
  );
}

//Bold Style
TextStyle getCustomTextStyle(
    {required double fontSize,
    required Color textColor,
    required FontWeight fontWeight,
    String fontFamily = FontConstants.fontFamily}) {
  return _getTextStyle(
      fontSize, fontFamily, textColor, fontWeight);
}

//TextStyle with line height
TextStyle getTextStyleWithLineHeight(
    {required double fontSize,
      required Color textColor,
      required FontWeight fontWeight,
      double lineHeight = 16 * 1.5}) {
  return _getTextStyleWithLineHeight(
      fontSize, FontConstants.fontFamily, textColor, fontWeight, lineHeight);
}

//Bold Style
TextStyle getHintStyle(
    {double fontSize = FontSize.s14, required Color textColor}) {
  return _getTextStyle(fontSize, FontConstants.fontFamily, textColor,
      FontWeightManager.hintWeight);
}

//Page subtitle Style
TextStyle getPageSubtitleStyle(
    {double fontSize = FontSize.s20, required Color textColor}) {
  return _getTextStyle(
      fontSize, FontConstants.fontFamily, textColor, FontWeightManager.title);
}

//Regular Style
TextStyle getRegularStyle(
    {double fontSize = FontSize.s16, required Color textColor}) {
  return _getTextStyle(
      fontSize, FontConstants.fontFamily, textColor, FontWeightManager.regular);
}

//Semibold Style
TextStyle getSemiBoldStyle(
    {double fontSize = FontSize.s24, required Color textColor}) {
  return _getTextStyle(fontSize, FontConstants.fontFamily, textColor,
      FontWeightManager.semiBold);
}
