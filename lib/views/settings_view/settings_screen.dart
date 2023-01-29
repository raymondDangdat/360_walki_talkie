import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:walkie_talkie_360/provider/authentication_provider.dart';
import 'package:walkie_talkie_360/resources/font_manager.dart';
import 'package:walkie_talkie_360/resources/image_manager.dart';
import 'package:walkie_talkie_360/resources/navigation_utils.dart';
import 'package:walkie_talkie_360/resources/strings_manager.dart';
import 'package:walkie_talkie_360/resources/value_manager.dart';
import 'package:walkie_talkie_360/widgets/custom_text.dart';
import 'package:walkie_talkie_360/widgets/settings_item.dart';

import '../../resources/color_manager.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: AppSize.s61.h,
                      width: AppSize.s50.w,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(AppImages.backButtonBg),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(AppSize.s23),
                              bottomRight: Radius.circular(AppSize.s23))),
                      child: Image.asset(AppImages.arrowLeft),
                    ),
                  ),
                  SizedBox(
                    width: AppSize.s20.w,
                  ),
                  Container(
                    // width: AppSize.s156.w,
                    padding: EdgeInsets.symmetric(horizontal: AppSize.s30.w),
                    height: AppSize.s50.w,
                    decoration: BoxDecoration(
                        color: ColorManager.bgColor,
                        borderRadius: BorderRadius.circular(AppSize.s23.r),
                        border: Border.all(color: ColorManager.primaryColor)),
                    alignment: Alignment.center,
                    child: CustomText(
                      text: AppStrings.settings,
                      textColor: ColorManager.primaryColor,
                      fontSize: FontSize.s20,
                    ),
                  ),
                  SizedBox(
                    width: AppSize.s6.w,
                  ),
                  InkWell(
                    onTap: () {
                      print("Tapped");
                    },
                    child: Container(
                      // width: AppSize.s156.w,
                      padding: EdgeInsets.symmetric(horizontal: AppSize.s30.w),
                      height: AppSize.s50.w,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                            image: AssetImage(AppImages.signoutBg),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(AppSize.s23.r),
                      ),
                      alignment: Alignment.center,
                      child: CustomText(
                        text: AppStrings.signOut,
                        textColor: ColorManager.blackColor,
                        fontSize: FontSize.s20,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: AppSize.s27.h,
              ),
              Container(
                padding: EdgeInsets.all(AppSize.s22.r),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: ColorManager.primaryColor,
                    ),
                    borderRadius: BorderRadius.circular(AppSize.s100.r)),
                child: SvgPicture.asset(AppImages.gearIcon),
              ),
              SizedBox(
                height: AppSize.s25.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSize.s35.w),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      // horizontal: AppSize.s24.w,
                      vertical: AppSize.s39.h),
                  // height: AppSize.s600.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: ColorManager.profileInfoBgColor,
                      borderRadius: BorderRadius.circular(AppSize.s24.r)),
                  child: Column(
                    children: [
                      SettingsItem(
                          onTap: () {
                            openUpdateProfile(context);
                          },
                          title: AppStrings.editAccount,
                          iconName: AppImages.editAccountProfileIcon),
                      SizedBox(
                        height: AppSize.s7.h,
                      ),
                      SettingsItem(
                          onTap: () {
                            openResetPassword(context);
                          },
                          title: AppStrings.resetPassword,
                          iconName: AppImages.resetPasswordIcon),
                      SizedBox(
                        height: AppSize.s7.h,
                      ),
                      Container(
                        height: AppSize.s60.h,
                        padding:
                            EdgeInsets.symmetric(horizontal: AppSize.s16.w),
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(AppImages.settingaItemsBg))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  openNotifications(context);
                                },
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                        AppImages.notificationIcon),
                                    SizedBox(
                                      width: AppSize.s12.w,
                                    ),
                                    const CustomText(
                                      text: AppStrings.notification,
                                      fontSize: FontSize.s20,
                                      textColor: ColorManager.blckTxtColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                authProvider.changeNotificationStatus(
                                    !authProvider.notificationOn);
                              },
                              child: SvgPicture.asset(
                                  authProvider.notificationOn
                                      ? AppImages.notificationToggleOn
                                      : AppImages.notificationToggleOff),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: AppSize.s7.h,
                      ),
                      SettingsItem(
                          onTap: () {
                            openBlockChannels(context);
                          },
                          title: AppStrings.blockChannel,
                          iconName: AppImages.blockChannelIcon),
                      SizedBox(
                        height: AppSize.s7.h,
                      ),
                      SettingsItem(
                          onTap: () {
                            openBlockUsers(context);
                          },
                          title: AppStrings.blockUser,
                          iconName: AppImages.blockUserIcon),
                      SizedBox(
                        height: AppSize.s7.h,
                      ),
                      SettingsItem(
                          onTap: () {
                            openFAQ(context);
                          },
                          title: AppStrings.faq,
                          iconName: AppImages.supportIcon),
                      SizedBox(
                        height: AppSize.s7.h,
                      ),
                      SettingsItem(
                          onTap: () {
                            openPrivacyPolicy(context);
                          },
                          title: AppStrings.privacy,
                          iconName: AppImages.privacyIcon),
                      SizedBox(
                        height: AppSize.s7.h,
                      ),
                      SettingsItem(
                          onTap: () {
                            openTermsAndConditions(context);
                          },
                          title: AppStrings.termsAndConditions,
                          iconName: AppImages.termsAndConditionIcon),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: AppSize.s20.h,
              )
            ],
          ),
        )));
  }
}
