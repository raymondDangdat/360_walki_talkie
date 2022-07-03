import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../resources/color_manager.dart';
import '../resources/font_manager.dart';
import '../resources/image_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/value_manager.dart';
import 'custom_text.dart';

class NavScreensHeader extends StatelessWidget {
  const NavScreensHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: AppSize.s21.w,),
        Image.asset(AppImages.three60Small),
        SizedBox(width: AppSize.s7.w,),
        Expanded(child: CustomTextWithLineHeight(text: AppStrings.userName,
          textColor: ColorManager.blackTextColor,
          fontWeight: FontWeight.w300,
          fontSize: FontSize.s20,),),
        
        SvgPicture.asset(AppImages.menuIcon),
        SizedBox(width: AppSize.s21.w,),
      ],
    );
  }
}
