import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:walkie_talkie_360/provider/channel_provider.dart';
import 'package:walkie_talkie_360/resources/font_manager.dart';

import '../../resources/color_manager.dart';
import '../../resources/image_manager.dart';
import '../../resources/strings_manager.dart';
import '../../resources/value_manager.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/nav_screens_header.dart';

class ChannelMembersChats extends StatelessWidget {
  const ChannelMembersChats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final channelProvider = context.watch<ChannelProvider>();
    return Scaffold(
      backgroundColor: ColorManager.bgColor,

      body: SafeArea(
        child: Column(
          children: [
            // SizedBox(height: AppSize.s20.h,),
            const NavScreensHeader(),

            SizedBox(height: AppSize.s52.h,),

            CustomTextWithLineHeight(text: AppStrings.userName, textColor: ColorManager.textColor,),

            SizedBox(height: AppSize.s38.h,),

            SizedBox(
              width: AppSize.s250.w,
                height: AppSize.s250.w,
                child: SvgPicture.asset(AppImages.tapToTalk)),

            SizedBox(height: AppSize.s40.h,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSize.s33),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(AppImages.speaker),
                  SvgPicture.asset(AppImages.option),

                ],
              ),
            ),

            SizedBox(height: AppSize.s15.h,),
            
            Container(
              height: AppSize.s52.h,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                      AppImages.dashboardStats), fit: BoxFit.cover),
            ),
              alignment: Alignment.center,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSize.s18.w),
                    child: CustomTextWithLineHeight(
                        text: "Channel: ${channelProvider.selectedChannel.channelName} | ${channelProvider.channelMembers.length} Member(s)",
                      textColor: const Color.fromRGBO(248, 201, 158, 1),
                      fontSize: FontSize.s16, fontWeight: FontWeightManager.semiBold,
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
