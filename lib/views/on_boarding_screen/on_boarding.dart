import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walkie_talkie_360/resources/constanst.dart';
import 'package:walkie_talkie_360/resources/navigation_utils.dart';
import 'package:walkie_talkie_360/widgets/reusable_widget.dart';

import '../../resources/color_manager.dart';
import '../../resources/image_manager.dart';
import '../../resources/strings_manager.dart';
import '../../resources/value_manager.dart';
import '../../widgets/custom_text.dart';


class OnBoardingView extends StatefulWidget {
  const OnBoardingView({Key? key}) : super(key: key);

  @override
  _OnBoardingViewState createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  final controller = PageController();

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.bgColor,
      body: SafeArea(
        child: PageView.builder(
          controller: controller,
          itemBuilder: (context, index) {
            return pages[index];
          },
          itemCount: pages.length,
        ),
      ),
    );
  }
}

class PageViewOnBoarding extends StatelessWidget {
  final int index;
  const PageViewOnBoarding({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return index == 0 ?
    SizedBox(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(height: AppSize.s50.h,),
          CustomTextWithLineHeight(text: AppStrings.welcomeTo,
            textColor: ColorManager.whiteColor,),
          SizedBox(height: AppSize.s52.h,),

          Image.asset(AppImages.three60),


          CustomTextWithLineHeight(text: AppStrings.pushToTalk,
              textColor: ColorManager.whiteColor),

          SizedBox(height: AppSize.s11.h,),

          Image.asset(AppImages.walkieMetal),

          SizedBox(height: AppSize.s50.h,),

          CustomTextWithLineHeight(text: "Dots coming here",
              textColor: ColorManager.whiteColor),

        ],
      ),
    ) :
    index == 1 ?
    SizedBox(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: AppSize.s52.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: AppSize.s308.h,),
                      CustomTextWithLineHeight(text: AppStrings.takeYourTimeTo,
                        textColor: ColorManager.textColor,),

                      Image.asset(AppImages.talkImage),

                      CustomTextWithLineHeight(text: AppStrings.toYourTeam,
                        textColor: ColorManager.textColor,),

                      CustomTextWithLineHeight(text:
                      AppStrings.simplyPushToTalk,
                        textColor: ColorManager.textColor,),

                      SizedBox(height: AppSize.s208.h,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomTextWithLineHeight(text: "Dots coming here",
                              textColor: ColorManager.whiteColor),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height * .85,
                  child: Image.asset(AppImages.walkieTalkieLeft)),
            ],
          ),

        ],
      ),
    ):
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: AppSize.s20.h,),
              Row(
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.85,
                      child: Image.asset(AppImages.walkieTalkieRight)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: AppSize.s308.h,),
                        CustomTextWithLineHeight(text: AppStrings.orWhyDontYou,
                          textColor: ColorManager.textColor,),

                        Image.asset(AppImages.chatWithUs),

                        SizedBox(height: AppSize.s10.h,),
                        CustomTextWithLineHeight(text:
                        AppStrings.whenYouSimplyDont, textColor:
                        ColorManager.textColor,),


                        CustomTextWithLineHeight(text: AppStrings.wantToTalk,
                          textColor: ColorManager.textColor,),

                        CustomTextWithLineHeight(text:
                        AppStrings.toStartChatting, textColor:
                        ColorManager.textColor,),

                        SizedBox(height: AppSize.s50.h,),
                        WalkieButton(context: context, onTap: ()async{
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setBool(showOnBoarding, false);
                          openNewGetStartedScreen(context);
                        }, title:
                        AppStrings.getStarted),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
  }
}

final List<Widget> pages = [
  const PageViewOnBoarding(
    index: 0,
  ),
  const PageViewOnBoarding(
    index: 1,
  ),
  const PageViewOnBoarding(
    index: 2,
  ),
];