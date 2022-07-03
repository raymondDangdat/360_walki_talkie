import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:walkie_talkie_360/resources/color_manager.dart';
import 'package:walkie_talkie_360/widgets/reusable_widget.dart';

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
            body: SingleChildScrollView(
              child: Column(
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
                            CustomTextWithLineHeight(text: AppStrings.userName, textColor: ColorManager.blackTextColor, fontWeight: FontWeight.w300, fontSize: FontSize.s20,),
                          ],
                        ),
                      ],
                    ),
                  ),



                  SizedBox(height: AppSize.s85.h,),

                  SizedBox(
                    height: AppSize.s240.h,
                    child: Stack(
                      clipBehavior: Clip.none,
                      fit: StackFit.loose,
                      children: <Widget>[
                        // Max Size Widget
                        Container(
                          height: AppSize.s210.h,
                          width: AppSize.s323.w,
                          decoration: BoxDecoration(
                              color: ColorManager.textColor,
                              borderRadius: BorderRadius.circular(AppSize.s40)
                          ),
                        ),
                        Positioned(
                          top: -40,
                          child: Container(
                            height: AppSize.s58.h,
                            width: AppSize.s323.w,
                            decoration: BoxDecoration(
                              color: ColorManager.orangeColor,
                              borderRadius: BorderRadius.circular(AppSize.s40)
                            ),
                            alignment: Alignment.center,
                            child: CustomTextWithLineHeight(text: AppStrings.corporateChannel, textColor: ColorManager.whiteColor, fontSize: FontSize.s26,),
                          ),
                        ),
                        Positioned(
                            top: AppSize.s30.h,
                            left: AppSize.s60.w,
                            right: AppSize.s60.w,
                            child: CustomTextWithLineHeight(text: AppStrings.createCorporateOrProgram, textColor: ColorManager.blackTextColor,)
                        ),
                        Positioned(
                            top: AppSize.s160.h,
                            left: AppSize.s60.w,
                            right: AppSize.s60.w,
                            child: WalkieButtonBordered(context: context, onTap: (){}, title: AppStrings.clickToCreate, textColor: ColorManager.blackTextColor, borderColor: ColorManager.deepOrange)
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSize.s54.r),
                    child: Column(
                      children: [

                      ],
                    ),
                  )


                ],
              ),
            ),
          )),
    );
  }
}
