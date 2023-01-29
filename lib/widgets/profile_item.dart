import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:walkie_talkie_360/widgets/custom_text_field.dart';

import '../provider/authentication_provider.dart';
import '../resources/color_manager.dart';
import '../resources/font_manager.dart';
import '../resources/value_manager.dart';
import 'custom_text.dart';

class ProfileItem extends StatelessWidget {
  final String title;
  final String label;
  final bool? withFill;
  final String icon;
  const ProfileItem(
      {Key? key,
      required this.label,
      required this.title,
      required this.icon,
      this.withFill})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SvgPicture.asset(icon),
            SizedBox(
              width: AppSize.s7.w,
            ),
            CustomText(
              text: label,
              textColor: ColorManager.profileLabelTextColor,
              fontSize: FontSize.s20,
            )
          ],
        ),
        Row(
          children: [
            SizedBox(
              height: AppSize.s19.h,
              width: AppSize.s19.h,
            ),
            SizedBox(
              width: AppSize.s7.w,
            ),
            CustomText(
              text: title,
              textColor: ColorManager.profileTitleTextColor,
              fontSize: FontSize.s20,
            ),
          ],
        ),
        SizedBox(
          height: AppSize.s4.h,
        )
      ],
    );
  }
}

class UpdateProfileItem extends StatelessWidget {
  final String title;
  final String label;
  final bool? withFill;
  final String icon;
  const UpdateProfileItem(
      {Key? key,
      required this.label,
      required this.title,
      required this.icon,
      this.withFill})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SvgPicture.asset(icon),
            SizedBox(
              width: AppSize.s7.w,
            ),
            CustomText(
              text: label,
              textColor: ColorManager.profileLabelTextColor,
              fontSize: FontSize.s20,
            )
          ],
        ),
        SizedBox(height: AppSize.s2.h),
        Row(
          children: [
            SizedBox(
                width: AppSize.s230.w,
                child: ProfileTextField(
                  withFill: withFill,
                  controller: TextEditingController(text: title),
                )),
          ],
        ),
        SizedBox(
          height: AppSize.s8.h,
        )
      ],
    );
  }
}
