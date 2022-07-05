import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:walkie_talkie_360/resources/navigation_utils.dart';
import 'package:walkie_talkie_360/widgets/nav_screens_header.dart';

import '../../../resources/color_manager.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/image_manager.dart';
import '../../../resources/strings_manager.dart';
import '../../../resources/value_manager.dart';
import '../../../widgets/custom_text.dart';

class ChannelView extends StatelessWidget {
  const ChannelView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: AppSize.s46.h,),

        Container(
          height: AppSize.s54.h,
          decoration: BoxDecoration(
              color: ColorManager.textColor
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              NavScreensHeader()
            ],
          ),
        ),



        SizedBox(height: AppSize.s21.h,),
        Image.asset(AppImages.three60Circle),
        SizedBox(height: AppSize.s19.h,),
        CustomTextWithLineHeight(text: AppStrings.createAChannel, textColor: ColorManager.whiteColor,),
        SizedBox(height: AppSize.s19.h,),

        Container(
          height: AppSize.s96.h,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: AppSize.s34.w),
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage(AppImages.createChannelOptionsBg), fit: BoxFit.cover),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextWithLineHeight(text: AppStrings.addAChannelByName, textColor: ColorManager.darkTextColor, fontSize: FontSize.s26,),
              SizedBox(height: AppSize.s4.h,),

              SizedBox(
                width: AppSize.s364.w,
                child: RichText(
                  text: TextSpan(
                    text: AppStrings.ifYouKnow,
                    style: TextStyle(
                        color: ColorManager.darkTextColor
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                            openAddChannelByName(context);
                            },
                          text: AppStrings.clickToContinue, style: TextStyle(fontWeight: FontWeight.w300, color: ColorManager.whiteColor)),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),

        SizedBox(height: AppSize.s14.h,),

        Container(
          height: AppSize.s96.h,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: AppSize.s34.w),
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage(AppImages.createChannelOptionsBg), fit: BoxFit.cover),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextWithLineHeight(text: AppStrings.createNewChannel, textColor: ColorManager.darkTextColor, fontSize: FontSize.s26,),
              SizedBox(height: AppSize.s4.h,),
              SizedBox(
                width: AppSize.s364.w,
                child: RichText(
                  text: TextSpan(
                    text: AppStrings.youCanCreateABrandNewChannel,
                    style: TextStyle(
                        color: ColorManager.darkTextColor
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                            openCreateBrandNewChannel(context);
                            },
                          text: AppStrings.clickToContinue, style: TextStyle(fontWeight: FontWeight.w300, color: ColorManager.whiteColor)),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),

        SizedBox(height: AppSize.s14.h,),

        Container(
          height: AppSize.s96.h,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: AppSize.s34.w),
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage(AppImages.createChannelOptionsBg), fit: BoxFit.cover),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextWithLineHeight(text: AppStrings.generateChannelQrCode, textColor: ColorManager.darkTextColor, fontSize: FontSize.s26,),
              SizedBox(height: AppSize.s4.h,),
              SizedBox(
                width: AppSize.s364.w,
                child: RichText(
                  text: TextSpan(
                    text: AppStrings.youCanGenerate,
                    style: TextStyle(
                        color: ColorManager.darkTextColor
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                            openGenerateChannelQrCode(context);
                            },
                          text: AppStrings.clickToGenerate, style: TextStyle(fontWeight: FontWeight.w300, color: ColorManager.whiteColor)),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),




      ],
    );
  }
}
