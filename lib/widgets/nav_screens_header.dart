import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../resources/color_manager.dart';
import '../resources/font_manager.dart';
import '../resources/image_manager.dart';
import '../resources/value_manager.dart';
import 'custom_text.dart';

import 'package:provider/provider.dart';
import 'package:walkie_talkie_360/provider/authentication_provider.dart';

class NavScreensHeader extends StatelessWidget {
  const NavScreensHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthenticationProvider>();
    return Container(
      height: AppSize.s54.h,
      decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage(AppImages.headerBgImage), fit: BoxFit.cover)
      ),
      alignment: Alignment.center,
      child: Row(
        children: [
          SizedBox(width: AppSize.s21.w,),
          Image.asset(AppImages.three60Small),
          SizedBox(width: AppSize.s7.w,),
          Expanded(child: CustomTextWithLineHeight(text: authProvider.userInfo.fullName,
            textColor: ColorManager.blackTextColor,
            fontWeight: FontWeight.w300,
            fontSize: FontSize.s20,),),

          SvgPicture.asset(AppImages.menuIcon),
          SizedBox(width: AppSize.s21.w,),
        ],
      ),
    );
  }
}
