import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../resources/color_manager.dart';
import '../resources/font_manager.dart';
import '../resources/image_manager.dart';
import '../resources/value_manager.dart';
import 'custom_text.dart';

class SettingsItem extends StatelessWidget {
  final String title;
  final String iconName;
  const SettingsItem({Key? key,
    required this.title,
    required this.iconName
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSize.s60.h,
      padding: EdgeInsets.symmetric(
          horizontal: AppSize.s16.w
      ),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AppImages.settingaItemsBg))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                SvgPicture.asset(iconName),
                SizedBox(width: AppSize.s12.w,),
                CustomText(
                  text: title,
                  fontSize: FontSize.s20,
                  textColor: ColorManager.blckTxtColor,
                ),
              ],
            ),
          ),
          SvgPicture.asset(AppImages.forwardArrowIcon),
        ],
      ),
    );
  }
}
