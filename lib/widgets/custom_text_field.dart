import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:walkie_talkie_360/resources/font_manager.dart';

import '../resources/color_manager.dart';

class CustomTextField extends StatelessWidget {
      bool autoFocus;
  bool obSecureText;
      int? maxLines;
  String hint;
      String? labelText;
      TextEditingController? controller;
        CustomTextField({Key? key, this.autoFocus = false,
    this.obSecureText = false,
    this.labelText = "",
    this.hint = "",
          this.maxLines = 1,
          this.controller
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.r),
              color: ColorManager.textFilledColor,
            ),
            alignment: Alignment.center,
            child: TextFormField(
              cursorColor: ColorManager.textColor,
              autofocus: autoFocus,
              maxLines: maxLines,
              obscureText:  obSecureText,
              style: TextStyle(
                color: ColorManager.textColor,
                  fontSize: FontSize.s16
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: ColorManager.bgColor,
                hintText: hint,
                labelText: labelText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.r),
                  borderSide: BorderSide(color: ColorManager.textColor,
                      width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.r),
                  borderSide: BorderSide(color: ColorManager.textColor,
                      width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  gapPadding: 0.0,
                  borderRadius: BorderRadius.circular(5.r),
                  borderSide: BorderSide(color: ColorManager.textColor,
                      width: 1),
                ),
                hintStyle: TextStyle(
                  color: ColorManager.textColor,
                  fontSize: FontSize.s16
                ),
                  labelStyle: TextStyle(
                    color: ColorManager.textColor,
                      fontSize: FontSize.s16
                  )
              ),
            )
        ),
      ],
    );
  }
}
