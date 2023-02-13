import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../resources/color_manager.dart';
import '../resources/font_manager.dart';
import '../resources/image_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/value_manager.dart';
import 'custom_text.dart';

buildNewUserDialog({
  required BuildContext context,
  required String userName,
  required Function() onAccept,
  required Function() onReject,
}) {
  return Future.delayed(Duration(seconds: 1)).then((value) => showGeneralDialog(
        anchorPoint: Offset(0, 90),
        context: context,
        barrierColor: Colors.black.withOpacity(0.5),
        pageBuilder: (_, __, ___) {
          return Material(
            color: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.only(bottom: 550.h),
              child: Center(
                  child: Container(
                height: AppSize.s80.h,
                width: double.infinity,
                color: ColorManager.brownColor,
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                        ColorManager.bgColor,
                        ColorManager.brownColor,
                      ])),
                  height: AppSize.s70,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        CustomTextNoOverFlow(
                          text: '$userName requested to be admitted.',
                          fontSize: AppSize.s16,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: AppSize.s80.w,
                                  height: AppSize.s30,
                                  decoration: BoxDecoration(
                                    color: ColorManager.primaryColor,
                                    border: Border.all(
                                        color: ColorManager.primaryColor),
                                    borderRadius:
                                        BorderRadius.circular(AppSize.s20.r),
                                  ),
                                  child: InkWell(
                                      onTap: onAccept,
                                      child: Center(
                                        child: CustomText(
                                          text: AppStrings.accept,
                                          fontSize: FontSize.s14,
                                          textColor:
                                              ColorManager.blackTextColor,
                                        ),
                                      )),
                                ),
                                SizedBox(width: AppSize.s10.w),
                                Container(
                                  width: AppSize.s80.w,
                                  height: AppSize.s30,
                                  decoration: BoxDecoration(
                                    color: ColorManager.primaryColor,
                                    border: Border.all(
                                        color: ColorManager.primaryColor),
                                    borderRadius:
                                        BorderRadius.circular(AppSize.s20.r),
                                  ),
                                  child: InkWell(
                                      onTap: onReject,
                                      child: Center(
                                        child: CustomText(
                                          text: AppStrings.decline,
                                          fontSize: FontSize.s14,
                                          textColor:
                                              ColorManager.blackTextColor,
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )),
            ),
          );
          // return Material(

          // );
        },
      ));
}
