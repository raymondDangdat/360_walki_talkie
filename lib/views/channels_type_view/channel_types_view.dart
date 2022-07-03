import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:walkie_talkie_360/resources/color_manager.dart';
import 'package:walkie_talkie_360/resources/navigation_utils.dart';
import 'package:walkie_talkie_360/widgets/channel_types_widget.dart';

import '../../resources/font_manager.dart';
import '../../resources/image_manager.dart';
import '../../resources/strings_manager.dart';
import '../../resources/value_manager.dart';
import '../../widgets/custom_text.dart';


class ChannelTypesView extends StatelessWidget {
  const ChannelTypesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.bgColor,

      body: SafeArea(
          child: Scaffold(
            backgroundColor: ColorManager.bgColor,
            body: Column(
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
                    children: [
                      Row(
                        children: [
                          Image.asset(AppImages.three60Small),
                          SizedBox(width: AppSize.s7.w,),
                          CustomTextWithLineHeight(text: AppStrings.userName,
                            textColor: ColorManager.blackTextColor,
                            fontWeight: FontWeight.w300,
                            fontSize: FontSize.s20,),
                        ],
                      ),
                    ],
                  ),
                ),



                SizedBox(height: AppSize.s85.h,),

                Expanded(
                  child: Column(
                    children: [
                      ChannelTypeWidget(
                          channelType: AppStrings.corporateChannel,
                          channelDescription: AppStrings.createCorporateOrProgram,
                          channelTypeTextColor: ColorManager.whiteColor,
                          channelTypeContainerColor: ColorManager.orangeColor,
                          bigContainerColor: ColorManager.textColor,
                          bigContainerBorderColor: ColorManager.textColor,
                          descriptionTextColor: ColorManager.darkTextColor,
                          buttonBgColor: ColorManager.textColor,
                          buttonBorderColor: ColorManager.deepOrange,
                          buttonTextColor: ColorManager.darkTextColor),

                      SizedBox(height: AppSize.s50.h,),

                      ChannelTypeWidget(
                          channelType: AppStrings.personalChannel,
                          channelDescription: AppStrings.createPersonalChannel,
                          channelTypeTextColor: ColorManager.darkTextColor,
                          channelTypeContainerColor: ColorManager.textColor,
                          bigContainerColor: ColorManager.bgColor,
                          bigContainerBorderColor: ColorManager.deepOrange,
                          descriptionTextColor: ColorManager.textColor,
                          buttonBgColor: ColorManager.bgColor,
                          buttonBorderColor: ColorManager.deepOrange,
                          buttonTextColor: ColorManager.whiteColor)
                    ],
                  )
                ),



              ],
            ),
          )),
    );
  }
}
