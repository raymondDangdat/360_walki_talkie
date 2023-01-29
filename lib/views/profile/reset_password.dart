import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:walkie_talkie_360/provider/authentication_provider.dart';
import 'package:walkie_talkie_360/resources/font_manager.dart';
import 'package:walkie_talkie_360/resources/image_manager.dart';
import 'package:walkie_talkie_360/resources/strings_manager.dart';
import 'package:walkie_talkie_360/resources/value_manager.dart';
import 'package:walkie_talkie_360/widgets/custom_text.dart';
import 'package:walkie_talkie_360/widgets/profile_item.dart';

import '../../resources/color_manager.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/nav_screens_header.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final ImagePicker _picker = ImagePicker();

  File? file;
  XFile? xFile;

  handleChooseFromGallery(BuildContext context) async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      xFile = file;
      this.file = File(file!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthenticationProvider>();
    return Scaffold(
        backgroundColor: ColorManager.bgColor,
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: AppSize.s20.h,
              ),
              NavScreen3(
                title: AppStrings.resetPassword,
                positionSize: AppSize.s200,
              ),
              SizedBox(
                height: AppSize.s40.h
              ),
              Container(
                  height: AppSize.s90,
                  width: AppSize.s90,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: ColorManager.primaryColor)),
                  child: Padding(
                    padding: const EdgeInsets.all(AppPadding.p20),
                    child: SvgPicture.asset(AppImages.resetPasswordIcon, color: ColorManager.primaryColor,),
                  )),
              SizedBox(
                height: AppSize.s30.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSize.s35.w),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppSize.s24.w, vertical: AppSize.s20.h),
                  // height: AppSize.s600.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: ColorManager.profileInfoBgColor,
                      borderRadius: BorderRadius.circular(AppSize.s24.r)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      SizedBox(child: Row(
                        children: [
                          SizedBox(
                              width: AppSize.s230.w,
                              child: ProfileTextField(
                                labelText: 'current password',
                              )),
                        ],
                      ),),

                      SizedBox(height: AppSize.s10),

                      SizedBox(child: Row(
                        children: [
                          SizedBox(
                              width: AppSize.s230.w,
                              child: ProfileTextField(
                                labelText: 'new password',
                              )),
                        ],
                      ),),

                      SizedBox(height: AppSize.s10),

                      SizedBox(child: Row(
                        children: [
                          SizedBox(
                              width: AppSize.s230.w,
                              child: ProfileTextField(
                                labelText: 'verify password',
                              )),
                        ],
                      ),),

                      SizedBox(height: AppSize.s10),

                      InkWell(
                        onTap: () {
                          print("Tapped");
                        },
                        child: Container(
                          height: AppSize.s35.h,
                          width: AppSize.s120.w,
                          padding:
                              EdgeInsets.symmetric(horizontal: AppSize.s10.w),
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                                image: AssetImage(AppImages.signoutBg),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(AppSize.s23.r),
                          ),
                          alignment: Alignment.center,
                          child: CustomText(
                            text: AppStrings.resetPassword,
                            textColor: ColorManager.blackColor,
                            fontSize: FontSize.s14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppSize.s10),
            ],
          ),
        )));
  }
}
