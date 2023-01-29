import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../resources/color_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/image_manager.dart';
import '../../resources/navigation_utils.dart';
import '../../resources/value_manager.dart';
import '../../widgets/custom_text.dart';

class MessagesWidget extends StatelessWidget {
  const MessagesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return     Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                  AppSize.s10,
                  index == 0 ? AppSize.s25.h : AppSize.s5,
                  AppSize.s10,
                  AppSize.s5),
              child: SizedBox(
                height: AppSize.s40.h,
                width: double.infinity,
                child: Row(
                  children: [
                    ClipOval(
                      child: Container(
                        color: ColorManager.primaryColor,
                        height: AppSize.s40.h,
                        width: AppSize.s35.w,
                        child: Center(
                            child: CustomText(
                              text: 'C',
                              fontSize: FontSize.s28,
                              textColor: ColorManager.blackTextColor,
                            )),
                      ),
                    ),
                    SizedBox(width: AppSize.s10.w),
                    SizedBox(
                      width: AppSize.s200.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            text: 'Clement Bako',
                            fontSize: FontSize.s16,
                            textColor: ColorManager.primaryColor,
                          ),
                          CustomText(
                            text: '5 minutes ago',
                            fontSize: FontSize.s12,
                            textColor: ColorManager.primaryColor,
                          )
                        ],
                      ),
                    ),

                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppSize.s8, vertical: AppSize.s5),
                        width: AppSize.s100.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppSize.s20.r),
                            border:
                            Border.all(color: ColorManager.primaryColor)),
                        child: InkWell(
                          onTap: () {
                            openMessageChat(context: context, fromSecondMenu: false);
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset(AppImages.profileEmailIcon),
                              Spacer(),
                              CustomText(
                                text: 'message',
                                fontSize: FontSize.s14,
                                textColor: ColorManager.primaryColor,
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ));
  }
}
