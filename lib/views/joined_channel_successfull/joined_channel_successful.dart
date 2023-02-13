import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:walkie_talkie_360/provider/authentication_provider.dart';
import 'package:walkie_talkie_360/resources/font_manager.dart';
import 'package:walkie_talkie_360/resources/navigation_utils.dart';
import 'package:walkie_talkie_360/widgets/customDrawer.dart';
import 'package:walkie_talkie_360/widgets/reusable_widget.dart';
import '../../resources/color_manager.dart';
import '../../resources/image_manager.dart';
import '../../resources/strings_manager.dart';
import '../../resources/value_manager.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/nav_screens_header.dart';

class JoinedChannelSuccessful extends StatelessWidget {
  const JoinedChannelSuccessful({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    final authProvider = context.watch<AuthenticationProvider>();
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: customDrawer(context: context, fromSecondMenu: false),
      backgroundColor: ColorManager.bgColor,
      body: SafeArea(child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: AppSize.s46.h,),
            Container(
              height: AppSize.s54.h,
              decoration: BoxDecoration(
                  color: ColorManager.textColor
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  NavScreensHeader(onTapDrawer: () {

                    _scaffoldKey.currentState?.openEndDrawer();
                  },)
                ],
              ),
            ),

            SizedBox(height: AppSize.s144.h,),
            SvgPicture.asset(AppImages.checkedIcon),

            SizedBox(height: AppSize.s19.h,),

            CustomTextWithLineHeight(
              text: AppStrings.yourrequest,
              textColor: ColorManager.primaryColor,),

            CustomTextWithLineHeight(
              text: "[${authProvider.channelNameJoined}]",
              textColor: ColorManager.primaryColor,
              fontWeight: FontWeightManager.bold,
              fontSize: FontSize.s24,
            ),

            CustomTextWithLineHeight(
              text: AppStrings.channelSuccessfully,
              textColor: ColorManager.primaryColor,),

            SizedBox(height: AppSize.s19.h,),

            WalkieButtonBordered(
                context: context,
                onTap: (){
                  openNavScreen(context);
                },
                title: AppStrings.returnToDashboard,
                textColor: ColorManager.primaryColor,
                borderColor: ColorManager.primaryColor)

          ],
        ),
      )),
    );
  }
}

