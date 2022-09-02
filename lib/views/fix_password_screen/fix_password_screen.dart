import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:walkie_talkie_360/resources/color_manager.dart';
import '../../provider/authentication_provider.dart';
import '../../resources/image_manager.dart';
import '../../resources/navigation_utils.dart';
import '../../resources/strings_manager.dart';
import '../../resources/value_manager.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/reusable_widget.dart';

class FixPasswordScreen extends StatefulWidget {
  const FixPasswordScreen({Key? key}) : super(key: key);

  @override
  State<FixPasswordScreen> createState() => _FixPasswordScreenState();
}

class _FixPasswordScreenState extends State<FixPasswordScreen> {
  final emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorManager.bgColor,
        resizeToAvoidBottomInset: true,
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
                    controller: emailController,
                    hint: AppStrings.enterYourEmail,
                    labelText: AppStrings.enterYourEmail,
                  ),
                  SizedBox(height: AppSize.s24.h,),
                  Consumer<AuthenticationProvider>(
                      builder: (ctx, auth, child) {
                        WidgetsBinding.instance.
                        addPostFrameCallback((_) {
                          if (auth.resMessage != '') {
                            showTopSnackBar(
                              context,
                              CustomSnackBar.info(
                                message: auth.resMessage,
                                backgroundColor:
                                ColorManager.primaryColor,
                              ),
                            );
                            ///Clear the response message to avoid duplicate
                            auth.clear();
                          }
                        });
                      return WalkieButton(context: context, onTap: (){
                        if(emailController.text.trim().isNotEmpty && emailController.text.trim().length > 3){
                          auth.sentPasswordResetEmail(context: context, email: emailController.text.trim());
                        }
                      }, title: AppStrings.submit);
                    }
                  ),
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
