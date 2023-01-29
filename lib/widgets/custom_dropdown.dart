import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../resources/color_manager.dart';
import '../resources/image_manager.dart';
import '../resources/value_manager.dart';
import 'custom_text.dart';

Widget customDropdown(
    {required List dropdownList,
      required String value,

       String? selectedValue,

      required Function(Object? value)? onTap}) {

  return DropdownButtonHideUnderline(
    child: DropdownButton2(
      buttonPadding: EdgeInsets.only(left: AppPadding.p8),
      buttonHeight: AppSize.s33.h,

            buttonDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.s20.r),
          border: Border.all(
            color: ColorManager.primaryColor,
          )),
      alignment: Alignment.centerLeft,

      dropdownPadding: EdgeInsets.zero,
      dropdownMaxHeight: AppSize.s200.h,
      dropdownDecoration: BoxDecoration(color: ColorManager.bgColor),
      itemPadding: EdgeInsets.symmetric(
          horizontal: AppPadding.p10, vertical: AppPadding.p5),
      itemHeight: AppSize.s25.h,
      icon: SvgPicture.asset(
        AppImages.dropdownIcon,
        height: 6,
      ),
      iconSize: 15,
      hint: CustomText(
        text: 'Select Item',
        textColor: ColorManager.primaryColor,
      ),
      items: dropdownList
          .map((item) => DropdownMenuItem<Object>(
        value: item[value],
        child: CustomText(
          text: item[value],
          textColor: ColorManager.primaryColor,
        ),
      ))
          .toList(),
      value: selectedValue,
      onChanged: onTap,
    ),
  );
}