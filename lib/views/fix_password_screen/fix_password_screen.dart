import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:walkie_talkie_360/resources/color_manager.dart';
import '../../resources/image_manager.dart';
import '../../resources/navigation_utils.dart';
import '../../resources/strings_manager.dart';
import '../../resources/value_manager.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/reusable_widget.dart';

class FixPasswordScreen extends StatelessWidget {
  const FixPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorManager.bgColor,
        body: Column(
          children: [
            SizedBox(height: AppSize.s185.h,),

            Image.asset(AppImages.three60Circle),

            SizedBox(height: AppSize.s30.h,),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSize.s73.r),
              child: Column(
                children: [
                  SizedBox(height: AppSize.s9.h,),
                  CustomTextField(
                    hint: AppStrings.enterYourEmail,
                    labelText: AppStrings.enterYourEmail,
                    obSecureText: true,
                  ),
                  SizedBox(height: AppSize.s24.h,),
                  WalkieButton(context: context, onTap: (){
                    openGetStartedScreen(context);
                  }, title: AppStrings.submit),
                  SizedBox(height: AppSize.s24.h,),
                  SizedBox(
                    width: AppSize.s208.w ,
                    child: RichText(
                      text: TextSpan(
                        text: AppStrings.iRememberMyUsername,
                        style: TextStyle(
                            color: ColorManager.textColor
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  openLoginScreen(context);
                                },
                              text: AppStrings.login, style: TextStyle(fontWeight: FontWeight.w300, color: ColorManager.whiteColor)),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),


            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(AppImages.walkieLeft)
                ],
              ),
            )
          ],
        )
    );
  }
}
