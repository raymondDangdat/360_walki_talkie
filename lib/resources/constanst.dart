import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:onboarding/onboarding.dart';
import 'package:walkie_talkie_360/resources/strings_manager.dart';
import 'package:walkie_talkie_360/resources/value_manager.dart';

import '../widgets/custom_text.dart';
import 'color_manager.dart';
import 'image_manager.dart';

var moneyFormat = NumberFormat('#,###,000');

final pageModels = [
  PageModel(
    widget: DecoratedBox(
      decoration: BoxDecoration(
        color: ColorManager.bgColor,
        border: Border.all(
          width: 0.0,
          color: background,
        ),
      ),
      child: SingleChildScrollView(
        controller: ScrollController(),
        child: Container(
          height: AppSize.highestHeight.h,
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: AppSize.s119.h,),
              CustomTextWithLineHeight(text: AppStrings.welcomeTo, textColor: ColorManager.whiteColor,),
              SizedBox(height: AppSize.s52.h,),

              Image.asset(AppImages.three60),


              CustomTextWithLineHeight(text: AppStrings.pushToTalk, textColor: ColorManager.whiteColor),

              SizedBox(height: AppSize.s11.h,),

              Image.asset(AppImages.walkieMetal),

              SizedBox(height: AppSize.s50.h,),

              CustomTextWithLineHeight(text: "Dots coming here", textColor: ColorManager.whiteColor),

            ],
          ),
        ),
      ),
    ),
  ),

  PageModel(
    widget: DecoratedBox(
      decoration: BoxDecoration(
        color: ColorManager.bgColor,
        border: Border.all(
          width: 0.0,
          color: background,
        ),
      ),
      child: SingleChildScrollView(
        controller: ScrollController(),
        child: Container(
          height: AppSize.highestHeight.h,
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: AppSize.s20.h,),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: AppSize.s52.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: AppSize.s308.h,),
                          CustomTextWithLineHeight(text: AppStrings.takeYourTimeTo, textColor: ColorManager.textColor,),

                          Image.asset(AppImages.talkImage),

                          CustomTextWithLineHeight(text: AppStrings.toYourTeam, textColor: ColorManager.textColor,),

                          CustomTextWithLineHeight(text: AppStrings.simplyPushToTalk, textColor: ColorManager.textColor,),

                          SizedBox(height: AppSize.s208.h,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CustomTextWithLineHeight(text: "Dots coming here", textColor: ColorManager.whiteColor),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  Image.asset(AppImages.walkieTalkieLeft),
                ],
              ),




            ],
          ),
        ),
      ),
    ),
  ),

  PageModel(
    widget: DecoratedBox(
      decoration: BoxDecoration(
        color: ColorManager.bgColor,
        border: Border.all(
          width: 0.0,
          color: background,
        ),
      ),
      child: SingleChildScrollView(
        controller: ScrollController(),
        child: Container(
          height: AppSize.highestHeight.h,
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: AppSize.s20.h,),
              Row(
                children: [
                  Image.asset(AppImages.walkieTalkieRight),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: AppSize.s308.h,),
                        CustomTextWithLineHeight(text: AppStrings.orWhyDontYou, textColor: ColorManager.textColor,),

                        Image.asset(AppImages.chatWithUs),

                        CustomTextWithLineHeight(text: AppStrings.whenYouSimplyDont, textColor: ColorManager.textColor,),

                        CustomTextWithLineHeight(text: AppStrings.wantToTalk, textColor: ColorManager.textColor,),

                        CustomTextWithLineHeight(text: AppStrings.toStartChatting, textColor: ColorManager.textColor,),

                        SizedBox(height: AppSize.s208.h,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomTextWithLineHeight(text: "Dots coming here", textColor: ColorManager.whiteColor),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),




            ],
          ),
        ),
      ),
    ),
  ),


  PageModel(
    widget: DecoratedBox(
      decoration: BoxDecoration(
        color: ColorManager.bgColor,
        border: Border.all(
          width: 0.0,
          color: background,
        ),
      ),
      child: SingleChildScrollView(
        controller: ScrollController(),
        child: Container(
          height: AppSize.highestHeight.h,
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: AppSize.s141.h,),

              Image.asset(AppImages.walkieTalkieCircle),

              SizedBox(height: AppSize.s20.h,),


            ],
          ),
        ),
      ),
    ),
  ),
];