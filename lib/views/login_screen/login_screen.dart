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

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorManager.bgColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: AppSize.s100.h,),

                Image.asset(AppImages.three60Circle),

                SizedBox(height: AppSize.s23.h,),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSize.s73.r),
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: emailController,
                        hint: AppStrings.email,
                        labelText: AppStrings.enterChannelName,
                      ),
                      SizedBox(height: AppSize.s9.h,),
                      CustomTextField(
                        controller: passwordController,
                        hint: AppStrings.password,
                        labelText: AppStrings.password,
                        obSecureText: true,
                      ),
                      SizedBox(height: AppSize.s24.h,),
                      Consumer<AuthenticationProvider>(
                          builder: (ctx, auth, child) {
                            WidgetsBinding.instance?.
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
                            return WalkieButton(context: context, onTap: ()async{
                              if(emailController.text.trim().length >= 3
                                  && passwordController.text.trim().length >= 6){
                                final user = await  auth.signInUserWithEmailAndPassword(
                                    context: context,
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim());

                                if(user != null){
                                  //  login successful
                                  openGetStartedScreen(context);
                                }
                              }else{
                                showTopSnackBar(
                                  context,
                                  CustomSnackBar.info(
                                    message: AppStrings.enterValidEmailAndPassword,
                                    backgroundColor:
                                    ColorManager.primaryColor,
                                  ),
                                );
                              }
                            }, title: AppStrings.loginToAccount);
                          }
                      ),
                      SizedBox(height: AppSize.s19.h,),
                      SizedBox(
                        width: AppSize.s198.w ,
                        child: RichText(
                          text: TextSpan(
                            text:  AppStrings.forgotPassword,
                            style: TextStyle(
                                color: ColorManager.textColor
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      openFixPasswordScreen(context);
                                    },
                                  text: AppStrings.here,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: ColorManager.whiteColor)),
                              TextSpan(text: AppStrings.recoverIt,
                                style: TextStyle(
                                    color: ColorManager.textColor
                                ),),
                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                ),

              ],
            ),
          )
        )
    );
  }
}
