import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:walkie_talkie_360/widgets/reusable_widget.dart';

import '../resources/color_manager.dart';
import '../resources/font_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/value_manager.dart';
import 'custom_text.dart';

class ChannelTypeWidget extends StatelessWidget {
  final String channelType;
  final String channelDescription;
  final Color channelTypeTextColor;
  final Color channelTypeContainerColor;
  final Color bigContainerColor;
  final Color bigContainerBorderColor;
  final Color descriptionTextColor;
  final Color buttonTextColor;
  final Color buttonBgColor;
  final Color buttonBorderColor;
  const ChannelTypeWidget({Key? key, required this.channelType,
   required this.channelDescription,
   required this.channelTypeTextColor, required this.channelTypeContainerColor,
  required this.bigContainerColor, required this.bigContainerBorderColor,
  required this.descriptionTextColor, required this.buttonBgColor,
  required this.buttonBorderColor, required this.buttonTextColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.loose,
        children: <Widget>[
          // Max Size Widget
          Container(
            height: AppSize.s210.h,
            width: AppSize.s323.w,
            decoration: BoxDecoration(
                color: bigContainerColor,
                borderRadius: BorderRadius.circular(AppSize.s40),
                border: Border.all(color: bigContainerBorderColor)
            ),
          ),
          Positioned(
            top: -40,
            child: Container(
              height: AppSize.s58.h,
              width: AppSize.s323.w,
              decoration: BoxDecoration(
                  color: channelTypeContainerColor,
                  borderRadius: BorderRadius.circular(AppSize.s40)
              ),
              alignment: Alignment.center,
              child: CustomTextWithLineHeight(text: channelType, textColor: channelTypeTextColor, fontSize: FontSize.s26,),
            ),
          ),
          Positioned(
              top: AppSize.s30.h,
              left: AppSize.s60.w,
              right: AppSize.s60.w,
              child: CustomTextWithLineHeight(text: channelDescription, textColor: descriptionTextColor,)
          ),
          Positioned(
              top: AppSize.s160.h,
              left: AppSize.s60.w,
              right: AppSize.s60.w,
              child: WalkieButtonBordered(context: context, onTap: (){}, title: AppStrings.clickToCreate, textColor: buttonTextColor, borderColor: ColorManager.deepOrange)
          ),
        ],
      ),
    );
  }
}
