import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../provider/authentication_provider.dart';
import '../resources/color_manager.dart';
import '../resources/font_manager.dart';
import '../resources/value_manager.dart';
import 'custom_text.dart';

class ProfileItem extends StatelessWidget {
  final String title;
  final String label;
  final String icon;
  const ProfileItem({Key? key,
  required this.label, required this.title,
  required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SvgPicture.asset(icon),
            SizedBox(width: AppSize.s7.w,),
            CustomText(text: label,
              textColor: ColorManager.profileLabelTextColor,
              fontSize: FontSize.s20,)
          ],
        ),

        Row(
          children: [
            SizedBox(
              height: AppSize.s19.h,
              width: AppSize.s19.h,
            ),
            SizedBox(width: AppSize.s7.w,),
            CustomText(text: title,
              textColor: ColorManager.profileTitleTextColor,
              fontSize: FontSize.s20,),
          ],
        ),

        SizedBox(height: AppSize.s4.h,)
      ],
    );
  }
}
