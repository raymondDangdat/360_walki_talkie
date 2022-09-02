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

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
                SizedBox(height: AppSize.s20.h,),
                Row(
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: AppSize.s61.h,
                        width: AppSize.s77.w,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(AppImages.backButtonBg),
                                fit: BoxFit.cover),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(AppSize.s23),
                            bottomRight: Radius.circular(AppSize.s23)
                          )
                        ),
                        child: Image.asset(AppImages.arrowLeft),
                      ),
                    ),


                    SizedBox(width: AppSize.s30.w,),
                    Container(
                      width: AppSize.s208.w,
                      height: AppSize.s50.w,
                      decoration: BoxDecoration(
                          color: ColorManager.bgColor,
                          borderRadius: BorderRadius.circular(
                              AppSize.s23.r
                          ),
                          border: Border.all(
                              color: ColorManager.primaryColor
                          )
                      ),
                      alignment: Alignment.center,
                      child: CustomText(text: AppStrings.profileStatus,
                        textColor: ColorManager.primaryColor,
                        fontSize: FontSize.s20,),
                    ),
                  ],
                ),

                SizedBox(height: AppSize.s21.h,),

                InkWell(
                  onTap: (){
                    handleChooseFromGallery(context);
                  },
                  child: file == null ? Container(
                    height: AppSize.s130.h,
                    width: AppSize.s130.h,
                    decoration: BoxDecoration(
                        color: ColorManager.blackTextColor,
                        borderRadius: BorderRadius.circular(AppSize.s100.r),
                        image: const DecorationImage(image:  AssetImage(AppImages.dummyGuy), fit: BoxFit.cover)
                    ),
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
                                borderRadius: BorderRadius.circular(AppSize.s50.r)
                              ),
                              child: SvgPicture.asset(AppImages.camera)),
                        ),
                      ],
                    ),
                  ) : Container(
                    height: AppSize.s130.h,
                    width: AppSize.s130.h,
                    decoration: BoxDecoration(
                        color: ColorManager.blackTextColor,
                        borderRadius: BorderRadius.circular(AppSize.s100.r),
                        image:  DecorationImage(image:  FileImage(file!), fit: BoxFit.cover)
                    ),
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
                                  borderRadius: BorderRadius.circular(AppSize.s50.r)
                              ),
                              child: SvgPicture.asset(AppImages.camera)),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: AppSize.s25.h,),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.s35.w
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSize.s24.w,
                      vertical: AppSize.s39.h
                    ),
                    // height: AppSize.s600.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: ColorManager.profileInfoBgColor,
                      borderRadius: BorderRadius.circular(
                        AppSize.s24.r
                      )
                    ),
                    child: Column(
                      children: [
                        ProfileItem(
                            label: AppStrings.fullName,
                            title: authProvider.userInfo.fullName,
                            icon: AppImages.profileUserIcon),

                        ProfileItem(
                            label: AppStrings.username,
                            title: authProvider.userInfo.userName,
                            icon: AppImages.profileUserIcon),


                        ProfileItem(
                            label: AppStrings.emailAddress,
                            title: authProvider.userInfo.email,
                            icon: AppImages.profileUserIcon),


                        const ProfileItem(
                            label: AppStrings.country,
                            title: AppStrings.nigeria,
                            icon: AppImages.profileLocationIcon),

                        ProfileItem(
                            label: AppStrings.phoneNumber,
                            title: authProvider.userInfo.phoneNumber,
                            icon: AppImages.profileCallIcon),

                        const ProfileItem(
                            label: AppStrings.gender,
                            title: AppStrings.male,
                            icon: AppImages.profileGenderIcon),

                        const ProfileItem(
                            label: AppStrings.mainChannel,
                            title: AppStrings.mainChannel,
                            icon: AppImages.profileMainChannelIcon),

                        const ProfileItem(
                            label: AppStrings.subChannel,
                            title: AppStrings.subChannel,
                            icon: AppImages.profileSubChannelIcon),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        )
    );
  }
}
