import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:walkie_talkie_360/resources/font_manager.dart';
import 'package:walkie_talkie_360/resources/image_manager.dart';
import 'package:walkie_talkie_360/resources/strings_manager.dart';
import 'package:walkie_talkie_360/resources/value_manager.dart';
import 'package:walkie_talkie_360/widgets/custom_text.dart';

import '../../resources/color_manager.dart';

class HowItWorks extends StatelessWidget {
  const HowItWorks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.bgColor,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
        color: Colors.black26,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: -20,
              top: 30,
              child: InkWell(
                onTap: (){
                  print("Print something");
                },
                child: Container(
                  height: AppSize.s61.h,
                  width: AppSize.s77.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSize.s23.r),
                    image: const DecorationImage(
                        image: AssetImage(AppImages.backButtonBg),
                        fit: BoxFit.cover)
                  ),
                  child: Image.asset(AppImages.arrowLeft),
                ),
              ),
            ),

            Positioned(
              top: 30,
              right: 0,
              left: 0,
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(
                        width: AppSize.s208.w,
                        child: Image.asset(AppImages.how360Works),
                      ),
                      SizedBox(height: AppSize.s14.h,),
                      SizedBox(
                        width: AppSize.s200.w,
                        child: CustomTextWithLineHeight(
                            text: AppStrings.thisIsAGuide,
                          isCenterAligned: true,
                          textColor: ColorManager.primaryColor,
                        ),
                      ),
                      SizedBox(height: AppSize.s10.h,),
                      Image.asset(AppImages.smileFace),
                      SizedBox(height: AppSize.s6.h,),
                      SizedBox(
                        width: AppSize.s200.w,
                        child: CustomTextWithLineHeight(
                          text: AppStrings.signUpTo360,
                          isCenterAligned: true,
                          textColor: ColorManager.primaryColor,
                          fontWeight: FontWeightManager.regular,
                        ),
                      ),

                      SizedBox(height: AppSize.s5.h,),
                      Image.asset(AppImages.loader),
                      SizedBox(height: AppSize.s4.h,),

                      SizedBox(
                        width: AppSize.s200.w,
                        child: CustomTextWithLineHeight(
                          text: AppStrings.createASupperChannel,
                          isCenterAligned: true,
                          textColor: ColorManager.primaryColor,
                          fontWeight: FontWeightManager.regular,
                        ),
                      ),
                      SizedBox(height: AppSize.s5.h,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(AppImages.smileSmall),
                          Image.asset(AppImages.smileBig),
                          Image.asset(AppImages.smileSmall),
                        ],
                      ),
                      SizedBox(height: AppSize.s4.h,),
                      SizedBox(
                        width: AppSize.s200.w,
                        child: CustomTextWithLineHeight(
                          text: AppStrings.onBoardChannelUsers,
                          isCenterAligned: true,
                          textColor: ColorManager.primaryColor,
                          fontWeight: FontWeightManager.regular,
                        ),
                      ),
                      SizedBox(height: AppSize.s5.h,),
                      Image.asset(AppImages.messageCircle),
                      SizedBox(height: AppSize.s4.h,),

                      SizedBox(
                        width: AppSize.s200.w,
                        child: CustomTextWithLineHeight(
                          text: AppStrings.onBoardedChannelUsersCanAlso,
                          isCenterAligned: true,
                          textColor: ColorManager.primaryColor,
                          fontWeight: FontWeightManager.regular,
                        ),
                      ),
                      SizedBox(height: AppSize.s5.h,),
                      Image.asset(AppImages.messageCircle),
                      SizedBox(height: AppSize.s4.h,),
                      SizedBox(
                        width: AppSize.s200.w,
                        child: CustomTextWithLineHeight(
                          text: AppStrings.youCanBeginToPush,
                          isCenterAligned: true,
                          textColor: ColorManager.primaryColor,
                          fontWeight: FontWeightManager.regular,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
                bottom: 10,
                child: Container(
                  width: AppSize.s80.w,
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(AppImages.howItWorksTalkie),
                          fit: BoxFit.cover)
                    ),),
            ),
            Positioned(
              left: 22,
              bottom: 10,
              child: Image.asset(AppImages.howItWorksTalkieSmall),
            ),
          ],
        ),
      ),)
    );
  }
}
