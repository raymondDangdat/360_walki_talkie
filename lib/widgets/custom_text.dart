import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../resources/font_manager.dart';
import '../resources/styles_manager.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color textColor;
  final FontWeight fontWeight;
  const CustomText(
      {Key? key,
      required this.text,
      this.fontSize = FontSize.s12,
      this.textColor = const Color.fromRGBO(114, 115, 118, 1),
      this.fontWeight = FontWeightManager.regular})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: getCustomTextStyle(
          fontSize: fontSize.sp, textColor: textColor, fontWeight: fontWeight),
      overflow: TextOverflow.ellipsis,
    );
  }
}

class CustomTextPoppins extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color textColor;
  final FontWeight fontWeight;
  const CustomTextPoppins(
      {Key? key,
      required this.text,
      this.fontSize = FontSize.s12,
      this.textColor = const Color.fromRGBO(114, 115, 118, 1),
      this.fontWeight = FontWeightManager.regular})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: getCustomTextStyle(
        fontSize: fontSize.sp,
        textColor: textColor,
        fontWeight: fontWeight,
        // fontFamily: FontConstants.fontFamily2
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}

class CustomTextNoOverFlow extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color textColor;
  final bool? isCentered;
  final bool? justification;
  final bool? isAlignedRight;
  final FontWeight fontWeight;
  const CustomTextNoOverFlow(
      {Key? key,
      required this.text,
      this.fontSize = FontSize.s12,
      this.textColor = const Color.fromRGBO(114, 115, 118, 1),
      this.fontWeight = FontWeightManager.regular,
      this.isCentered = false,
      this.justification = false,
      this.isAlignedRight = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: isCentered!
          ? TextAlign.center
          : isAlignedRight!
              ? TextAlign.right
              : justification == true
                  ? TextAlign.justify
                  : TextAlign.left,
      style: getCustomTextStyle(
          fontSize: fontSize, textColor: textColor, fontWeight: fontWeight),
    );
  }
}

class CustomTextWithLineHeight extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color textColor;
  final FontWeight fontWeight;
  final double lineHeight;
  final bool isCenterAligned;
  const CustomTextWithLineHeight(
      {Key? key,
      required this.text,
      this.fontSize = FontSize.s14,
      this.lineHeight = 1.5,
      this.textColor = const Color.fromRGBO(101, 123, 154, 1),
      this.fontWeight = FontWeightManager.regular,
      this.isCenterAligned = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,

      textAlign: isCenterAligned ? TextAlign.center : TextAlign.start,
      style: getTextStyleWithLineHeight(
          fontSize: fontSize.sp,
          textColor: textColor,
          fontWeight: fontWeight,
          lineHeight: lineHeight),
      // overflow: TextOverflow.ellipsis,
    );
  }
}
