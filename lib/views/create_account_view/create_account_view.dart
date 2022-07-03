import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:walkie_talkie_360/resources/color_manager.dart';
import 'package:walkie_talkie_360/resources/font_manager.dart';
import 'package:walkie_talkie_360/resources/image_manager.dart';
import 'package:walkie_talkie_360/resources/navigation_utils.dart';
import 'package:walkie_talkie_360/resources/strings_manager.dart';
import 'package:walkie_talkie_360/resources/value_manager.dart';
import 'package:walkie_talkie_360/widgets/custom_text.dart';
import 'package:walkie_talkie_360/widgets/custom_text_field.dart';
import 'package:walkie_talkie_360/widgets/reusable_widget.dart';

class CreateAccountView extends StatelessWidget {
  const CreateAccountView({Key? key}) : super(key: key);

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

                  Image.asset(AppImages.line),

                  SizedBox(height: AppSize.s12.h,),
                  
                  CustomTextWithLineHeight(text: AppStrings.createAccount, textColor: ColorManager.textColor, fontSize: FontSize.s20,),

                  SizedBox(height: AppSize.s12.h,),

                  Image.asset(AppImages.line),

                  SizedBox(height: AppSize.s28.h,),

                  Image.asset(AppImages.three60Circle),

                  SizedBox(height: AppSize.s16.h,),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSize.s73.r),
                    child: Column(
                      children: [
                        CustomTextField(
                          hint: AppStrings.fullName,
                          labelText: AppStrings.fullName,
                          obSecureText: false,
                        ),

                        SizedBox(height: AppSize.s9.h,),

                        CustomTextField(
                          hint: AppStrings.username,
                          labelText: AppStrings.username,
                        ),

                        SizedBox(height: AppSize.s9.h,),

                        CustomTextField(
                          hint: AppStrings.password,
                          labelText: AppStrings.password,
                          obSecureText: true,
                        ),

                        SizedBox(height: AppSize.s9.h,),

                        CustomTextField(
                          hint: AppStrings.email,
                          labelText: AppStrings.email,
                        ),

                        SizedBox(height: AppSize.s9.h,),

                        CustomTextField(
                          hint: AppStrings.phoneNumber,
                          labelText: AppStrings.phoneNumber,
                        ),


                        SizedBox(height: AppSize.s17.h,),


                        SizedBox(
                          width: AppSize.s280.w ,
                          child: RichText(
                            text: TextSpan(
                              text: 'by clicking on ',
                              style: TextStyle(
                                color: ColorManager.textColor
                              ),
                              children: <TextSpan>[
                                TextSpan(text: '"create account"', style: TextStyle(fontWeight: FontWeight.w300, color: ColorManager.whiteColor)),
                                TextSpan(text: ' you completely agree to the', style: TextStyle(
                                    color: ColorManager.textColor
                                ),),
                                TextSpan(text: ' term of service', style: TextStyle(fontWeight: FontWeight.w300, color: ColorManager.whiteColor)),
                                TextSpan(text: ' and accept our', style: TextStyle(
                                    color: ColorManager.textColor
                                ),),
                                TextSpan(text: ' privacy policy.', style: TextStyle(fontWeight: FontWeight.w300, color: ColorManager.whiteColor)),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: AppSize.s17.h,),

                        WalkieButton(context: context, onTap: (){
                          openGetStartedScreen(context);
                        }, title: AppStrings.createAccount),
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
