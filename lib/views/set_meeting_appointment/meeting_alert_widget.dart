import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../resources/color_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/image_manager.dart';
import '../../resources/strings_manager.dart';
import '../../resources/value_manager.dart';
import '../../widgets/custom_text.dart';

class MeetingAlert extends StatelessWidget {
  final Function() onAccept;
  final Function() onReject;
  final Function() onEnd;
  final int endTime;
  final String channelName;
  final CountdownTimerController controller;
  MeetingAlert(
      {Key? key,
      required this.channelName,
      required this.onAccept,
      required this.onReject,
      required this.onEnd,
      required this.controller,
      required this.endTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(bottom: 380.h),
        child: Center(
            child: Container(
          height: AppSize.s230.h,
          width: double.infinity,
          color: ColorManager.brownColor,
          child: Stack(
            children: [
              Positioned(
                top: AppSize.s30,
                left: -AppSize.s44,
                child: SvgPicture.asset(
                  AppImages.notificationIcon,
                  color: ColorManager.whiteColor.withOpacity(.15),
                  height: AppSize.s130,
                ),
              ),
              SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Padding(
                                padding: EdgeInsets.only(left: AppSize.s30),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      CustomText(
                                        text: AppStrings.alert,
                                        textColor: ColorManager.primaryColor,
                                        fontSize: AppSize.s40,
                                      ),
                                      CustomTextNoOverFlow(
                                          isAlignedRight: true,
                                          textColor: ColorManager.whiteColor,
                                          fontSize: AppSize.s20,
                                          text:
                                              '$channelName meeting starts in.')
                                    ])),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppPadding.p8),
                            child: Container(
                              height: AppSize.s90,
                              color: ColorManager.primaryColor,
                              width: AppSize.s2,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: SizedBox(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: AppSize.s55.h),
                                    child: CountdownTimer(
                                        controller: controller,
                                        endTime: endTime,
                                        onEnd: onEnd,
                                        widgetBuilder: (BuildContext context,
                                            CurrentRemainingTime? time) {
                                          if (time == null) {
                                            return Text(
                                              '0',
                                              style: TextStyle(
                                                  height: .2,
                                                  color:
                                                      ColorManager.primaryColor,
                                                  fontSize: AppSize.s80),
                                            );
                                          }
                                          return Text(
                                            '${time.sec}',
                                            style: TextStyle(
                                                height: .2,
                                                color:
                                                    ColorManager.primaryColor,
                                                fontSize: AppSize.s80),
                                          );
                                        }),
                                  ),

                                  //   Text(
                                  //     '60',

                                  // ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(left: AppSize.s7),
                                    child: CustomTextNoOverFlow(
                                      text: 'seconds',
                                      textColor: ColorManager.whiteColor,
                                      fontSize: AppSize.s20,
                                    ),
                                  )
                                ])),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSize.s15),
                    SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: AppSize.s80.w,
                            height: AppSize.s30,
                            decoration: BoxDecoration(
                              color: ColorManager.primaryColor,
                              border:
                                  Border.all(color: ColorManager.primaryColor),
                              borderRadius:
                                  BorderRadius.circular(AppSize.s20.r),
                            ),
                            child: InkWell(
                                onTap: onAccept,
                                child: Center(
                                  child: CustomText(
                                    text: AppStrings.accept,
                                    fontSize: FontSize.s14,
                                    textColor: ColorManager.blackTextColor,
                                  ),
                                )),
                          ),
                          SizedBox(width: AppSize.s10.w),
                          Container(
                            width: AppSize.s80.w,
                            height: AppSize.s30,
                            decoration: BoxDecoration(
                              color: ColorManager.primaryColor,
                              border:
                                  Border.all(color: ColorManager.primaryColor),
                              borderRadius:
                                  BorderRadius.circular(AppSize.s20.r),
                            ),
                            child: InkWell(
                                onTap: onReject,
                                child: Center(
                                  child: CustomText(
                                    text: AppStrings.decline,
                                    fontSize: FontSize.s14,
                                    textColor: ColorManager.blackTextColor,
                                  ),
                                )),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}
