import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:walkie_talkie_360/widgets/custom_text_field.dart';

import '../../resources/color_manager.dart';
import '../../resources/image_manager.dart';
import '../../resources/strings_manager.dart';
import '../../resources/value_manager.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/nav_screens_header.dart';

class AddChannelByName extends StatelessWidget {
  const AddChannelByName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.bgColor,
      body: SafeArea(child: SingleChildScrollView(
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
                children: const [
                  NavScreensHeader()
                ],
              ),
            ),



            SizedBox(height: AppSize.s21.h,),
            Image.asset(AppImages.three60Circle),
            SizedBox(height: AppSize.s19.h,),
            CustomTextWithLineHeight(text: AppStrings.addAChannelByName, textColor: ColorManager.textColor,),
            SizedBox(height: AppSize.s19.h,),

            Padding(padding: EdgeInsets.symmetric(horizontal: AppSize.s73.w),
            child: Column(
              children: [

                CustomTextField(
                  hint: AppStrings.enterChannelName,
                  labelText: AppStrings.enterChannelName,
                ),

                SizedBox(height: AppSize.s30.h,),

                CustomTextWithLineHeight(text: AppStrings.ifYouKnowTheChannelName, textColor: ColorManager.textColor,)
              ],
            ),)





          ],
        ),
      )),
    );
  }
}
