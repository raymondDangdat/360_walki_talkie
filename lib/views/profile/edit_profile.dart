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
import '../../widgets/nav_screens_header.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
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
                title: AppStrings.updateProfile,
                positionSize: AppSize.s200,
              ),
              SizedBox(
                height: AppSize.s21.h,
              ),
              InkWell(
                onTap: () {
                  handleChooseFromGallery(context);
                },
                child: file == null
                    ? Container(
                        height: AppSize.s130.h,
                        width: AppSize.s130.h,
                        decoration: BoxDecoration(
                            color: ColorManager.blackTextColor,
                            borderRadius: BorderRadius.circular(AppSize.s100.r),
                            image: const DecorationImage(
                                image: AssetImage(AppImages.dummyGuy),
                                fit: BoxFit.cover)),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              top: AppSize.s80.h,
                              left: AppSize.s80.w,
                              child: Container(
                                  padding: EdgeInsets.all(AppSize.s10.r),
                                  height: AppSize.s50.h,
                                  width: AppSize.s50.h,
                                  decoration: BoxDecoration(
                                      color: ColorManager.primaryColor,
                                      borderRadius:
                                          BorderRadius.circular(AppSize.s50.r)),
                                  child: SvgPicture.asset(AppImages.camera)),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        height: AppSize.s130.h,
                        width: AppSize.s130.h,
                        decoration: BoxDecoration(
                            color: ColorManager.blackTextColor,
                            borderRadius: BorderRadius.circular(AppSize.s100.r),
                            image: DecorationImage(
                                image: FileImage(file!), fit: BoxFit.cover)),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              top: AppSize.s80.h,
                              left: AppSize.s80.w,
                              child: Container(
                                  padding: EdgeInsets.all(AppSize.s10.r),
                                  height: AppSize.s50.h,
                                  width: AppSize.s50.h,
                                  decoration: BoxDecoration(
                                      color: ColorManager.primaryColor,
                                      borderRadius:
                                          BorderRadius.circular(AppSize.s50.r)),
                                  child: SvgPicture.asset(AppImages.camera)),
                            ),
                          ],
                        ),
                      ),
              ),
              SizedBox(
                height: AppSize.s25.h,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UpdateProfileItem(
                          label: AppStrings.fullName,
                          title: authProvider.userInfo.fullName,
                          icon: AppImages.profileUserIcon),
                      UpdateProfileItem(
                          withFill: true,
                          label: AppStrings.username,
                          title: authProvider.userInfo.userName,
                          icon: AppImages.profileUserIcon),
                      UpdateProfileItem(
                          withFill: true,
                          label: AppStrings.emailAddress,
                          title: authProvider.userInfo.email,
                          icon: AppImages.profileEmailIcon),
                      const UpdateProfileItem(
                          label: AppStrings.country,
                          title: AppStrings.nigeria,
                          icon: AppImages.profileLocationIcon),
                      UpdateProfileItem(
                          label: AppStrings.phoneNumber,
                          title: authProvider.userInfo.phoneNumber,
                          icon: AppImages.profileCallIcon),
                      const UpdateProfileItem(
                          label: AppStrings.gender,
                          title: AppStrings.male,
                          icon: AppImages.profileGenderIcon),

                      InkWell(
                        onTap: (){
                          print("Tapped");
                        },
                        child: Container(
                          height: AppSize.s35.h,
                          width: AppSize.s100.w,
                          padding: EdgeInsets.symmetric(horizontal: AppSize.s10.w),
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                                image: AssetImage(AppImages.signoutBg),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(
                                AppSize.s23.r
                            ),
                          ),
                          alignment: Alignment.center,
                          child: CustomText(text: AppStrings.update,
                            textColor: ColorManager.blackColor,
                            fontSize: FontSize.s14,),
                        ),
                      ),
                      

                    ],
                  ),
                ),
              )
            ],
          ),
        )));
  }
}
