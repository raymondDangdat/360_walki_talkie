import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../resources/color_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/image_manager.dart';
import '../../resources/navigation_utils.dart';
import '../../resources/strings_manager.dart';
import '../../resources/value_manager.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/reusable_widget.dart';

class NewGetStartedScreen extends StatefulWidget {
  const NewGetStartedScreen({Key? key}) : super(key: key);

  @override
  State<NewGetStartedScreen> createState() => _NewGetStartedScreenState();
}

class _NewGetStartedScreenState extends State<NewGetStartedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.bgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: AppSize.s100.h,),

            Center(child: Image.asset(AppImages.walkieTalkieCircle)),

            SizedBox(height: AppSize.s20.h,),

            WalkieButton(
                height: AppSize.s51.h,
                width: AppSize.s255.w,
                context: context, onTap: (){
              openLoginScreen(context);
            }, title:
            AppStrings.loginToAccount),

            SizedBox(height: AppSize.s17.h,),

            WalkieButton(
                height: AppSize.s51.h,
                width: AppSize.s255.w,
                context: context, onTap: (){
              openAccountCreateScreen(context);
            }, title:
            AppStrings.getAnAccount),

            SizedBox(height: AppSize.s17.h,),

            WalkieButtonBordered(context: context, onTap: (){
              openHowItWorksScreen(context);
              // openLoginScreen(context);
            },
              title: AppStrings.howItWorks, textColor: ColorManager.textColor,
              borderColor: ColorManager.textColor,),

            SizedBox(height: AppSize.s31.h,),

            SizedBox(width: AppSize.s280.w,
              child: CustomTextWithLineHeight(text: AppStrings.createCommunication, fontSize: FontSize.s18,  textColor: ColorManager.textColor,),),

            SizedBox(height: AppSize.s100.h,),




          ],
        ),
      ),
    );
  }
}
