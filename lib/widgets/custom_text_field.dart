import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:walkie_talkie_360/resources/font_manager.dart';

import '../resources/color_manager.dart';
import '../resources/value_manager.dart';

class CustomTextField extends StatelessWidget {
  final bool autoFocus;
  final bool obSecureText;
  final int? maxLines;
  final int maxLength;
  final String hint;
  final String? labelText;
  final TextEditingController? controller;
  final bool? isNumbers;
  const CustomTextField(
      {Key? key,
      this.autoFocus = false,
      this.obSecureText = false,
      this.labelText = "",
      this.hint = "",
      this.maxLines = 1,
      this.maxLength = 1000,
      this.controller,
      this.isNumbers = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSize.s10.r),
              color: ColorManager.textFilledColor,
            ),
            alignment: Alignment.center,
            child: TextFormField(
              controller: controller,
              cursorColor: ColorManager.textColor,
              autofocus: autoFocus,
              maxLines: maxLines,
              maxLength: maxLength,
              obscureText: obSecureText,
              keyboardType:
                  isNumbers! ? TextInputType.phone : TextInputType.text,
              style: TextStyle(
                  color: ColorManager.textColor, fontSize: FontSize.s16),
              decoration: InputDecoration(
                  filled: true,
                  fillColor: ColorManager.bgColor,
                  hintText: hint,
                  labelText: labelText,
                  counterText: "",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSize.s10.r),
                    borderSide:
                        BorderSide(color: ColorManager.textColor, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSize.s10.r),
                    borderSide:
                        BorderSide(color: ColorManager.textColor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    gapPadding: 0.0,
                    borderRadius: BorderRadius.circular(AppSize.s10.r),
                    borderSide:
                        BorderSide(color: ColorManager.textColor, width: 1),
                  ),
                  hintStyle: TextStyle(
                      color: ColorManager.textColor, fontSize: FontSize.s16),
                  labelStyle: TextStyle(
                      color: ColorManager.textColor, fontSize: FontSize.s16)),
            )),
      ],
    );
  }
}

class ProfileTextField extends StatelessWidget {
  final bool autoFocus;
  final bool obSecureText;
  final int? maxLines;
  final bool? withFill;
  final int maxLength;
  final String hint;
  final String? labelText;
  final TextEditingController? controller;
  final bool? isNumbers;
  const ProfileTextField(
      {Key? key,
      this.autoFocus = false,
      this.withFill = false,
      this.obSecureText = false,
      this.labelText = "",
      this.hint = "",
      this.maxLines = 1,
      this.maxLength = 1000,
      this.controller,
      this.isNumbers = false})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: AppSize.s40.h,
            decoration: withFill == true
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSize.s20.r),
                    color: ColorManager.textFilledColor.withOpacity(.3),
                  )
                : null,
            alignment: Alignment.center,
            child: TextFormField(
              controller: controller,
              cursorColor: ColorManager.textColor,
              autofocus: autoFocus,
              maxLines: maxLines,
              maxLength: maxLength,
              obscureText: obSecureText,
              keyboardType:
                  isNumbers! ? TextInputType.phone : TextInputType.text,
              style: TextStyle(fontSize: FontSize.s13, color: ColorManager.whiteColor, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: AppPadding.p27),
                  filled: false,
                  hintText: hint,
                  labelText: labelText,
                  counterText: "",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSize.s20.r),
                    borderSide:
                        BorderSide(color: ColorManager.textColor, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSize.s20.r),
                    borderSide:
                        BorderSide(color: ColorManager.textColor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    gapPadding: 0.0,
                    borderRadius: BorderRadius.circular(AppSize.s20.r),
                    borderSide:
                        BorderSide(color: ColorManager.textColor, width: 1),
                  ),
                  hintStyle: TextStyle(
                      color: ColorManager.whiteColor, fontSize: FontSize.s13),
                  labelStyle: TextStyle(
                      color: ColorManager.whiteColor, fontSize: FontSize.s13)),
            )),
      ],
    );
  }
}
