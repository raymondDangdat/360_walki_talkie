import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:walkie_talkie_360/provider/authentication_provider.dart';
import 'package:walkie_talkie_360/resources/color_manager.dart';

import '../../resources/font_manager.dart';
import '../../resources/image_manager.dart';
import '../../resources/navigation_utils.dart';
import '../../resources/strings_manager.dart';
import '../../resources/value_manager.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/reusable_widget.dart';


class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthenticationProvider>();
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
                            CustomTextWithLineHeight(text: authProvider.userInfo.fullName, textColor: ColorManager.blackTextColor, fontWeight: FontWeight.w300, fontSize: FontSize.s20,),
                          ],
                        ),
                      ],
                    ),
                  ),



                  SizedBox(height: AppSize.s66.h,),

                  Image.asset(AppImages.walkieTalkiComplete),

                  SizedBox(height: AppSize.s30.h,),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSize.s73.r),
                    child: Column(
                      children: [
                        SizedBox(height: AppSize.s17.h,),
                        WalkieButton(context: context, onTap: (){
                          openChannelTypeScreen(context);
                        }, title: AppStrings.createChannel),
                        SizedBox(height: AppSize.s16.h,),
                        WalkieButtonBordered(context: context, onTap: (){}, title: AppStrings.howItWorks, textColor: ColorManager.textColor, borderColor: ColorManager.textColor)
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
