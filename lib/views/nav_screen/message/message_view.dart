import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:walkie_talkie_360/resources/color_manager.dart';
import 'package:walkie_talkie_360/resources/image_manager.dart';
import 'package:walkie_talkie_360/resources/strings_manager.dart';
import 'package:walkie_talkie_360/widgets/custom_text.dart';

import '../../../resources/value_manager.dart';
import '../../../widgets/nav_screens_header.dart';

class MessageView extends StatelessWidget {
  const MessageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: AppSize.s20.h,),
          const NavScreensHeader(),

          SizedBox(height: AppSize.s94.h,),

          CustomTextWithLineHeight(text: AppStrings.userName, textColor: ColorManager.textColor,),

          SizedBox(height: AppSize.s50.h,),

          SvgPicture.asset(AppImages.tapToTalk),

          SizedBox(height: AppSize.s50.h,),
          
          Expanded(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSize.s33),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(AppImages.speaker),
                SvgPicture.asset(AppImages.option),

              ],
            ),
          ))

        ],
      ),
    );
  }
}
