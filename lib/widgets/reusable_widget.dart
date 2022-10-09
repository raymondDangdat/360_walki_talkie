import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../resources/color_manager.dart';
import '../resources/font_manager.dart';
import '../resources/value_manager.dart';
import 'custom_text.dart';

class WalkieButton extends StatelessWidget {
  final BuildContext context;
  final VoidCallback onTap;
  final String title;
  final double height, width;
  const WalkieButton(
      {Key? key,
      required this.context,
      required this.onTap,
      required this.title,
      required this.height,
      required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: ColorManager.textColor,
          borderRadius: BorderRadius.circular(AppSize.s23.r),
          gradient: const LinearGradient(
            colors: [
              Color.fromRGBO(255, 213, 79, 1),
              Color.fromRGBO(255, 213, 79, 0),
            ],
            begin: FractionalOffset(0.0, 0.3),
            end: FractionalOffset(0.0, 1.0),
            // stops: [0.2, 1.0],
          ),
        ),
        alignment: Alignment.center,
        child: CustomText(
          text: title,
          textColor: const Color.fromRGBO(7, 7, 7, 1),
          fontSize: FontSize.s26,
        ),
      ),
    );
  }
}

class WalkieButtonBordered extends StatelessWidget {
  final BuildContext context;
  final VoidCallback onTap;
  final String title;
  final Color borderColor;
  final Color textColor;
  const WalkieButtonBordered({
    Key? key,
    required this.context,
    required this.onTap,
    required this.title,
    required this.textColor,
    required this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        height: AppSize.s51.h,
        width: AppSize.s255.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSize.s23.r),
            border: Border.all(color: borderColor)),
        alignment: Alignment.center,
        child: CustomText(
          text: title,
          textColor: textColor,
          fontSize: FontSize.s26,
        ),
      ),
    );
  }
}

class DropdownButtonText extends StatelessWidget {
  final String text;
  final double width;
  const DropdownButtonText({Key? key, required this.text, this.width = 250.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width.w,
      child: CustomTextNoOverFlow(
        text: text,
        textColor: ColorManager.textColor,
        fontWeight: FontWeightManager.regular,
        fontSize: FontSize.s14,
      ),
    );
  }
}

class DropdownButtonHint extends StatelessWidget {
  final String hint;
  const DropdownButtonHint({Key? key, required this.hint}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text: hint,
      textColor: ColorManager.textColor,
      fontSize: FontSize.s14,
      // lineHeight: 1.571,
    );
  }
}
