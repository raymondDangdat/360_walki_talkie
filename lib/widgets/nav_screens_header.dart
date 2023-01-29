import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../resources/color_manager.dart';
import '../resources/font_manager.dart';
import '../resources/image_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/value_manager.dart';
import '../views/nav_screen/nav_screen_view.dart';
import 'custom_text.dart';

import 'package:provider/provider.dart';
import 'package:walkie_talkie_360/provider/authentication_provider.dart';

class NavScreensHeader extends StatelessWidget {
  const NavScreensHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthenticationProvider>();
    return Container(
      height: AppSize.s54.h,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AppImages.headerBgImage), fit: BoxFit.cover)),
      alignment: Alignment.center,
      child: Row(
        children: [
          SizedBox(
            width: AppSize.s21.w,
          ),
          Image.asset(AppImages.three60Small),
          SizedBox(
            width: AppSize.s7.w,
          ),
          Expanded(
            child: CustomTextWithLineHeight(
              text: authProvider.userInfo.fullName,
              textColor: ColorManager.blackTextColor,
              fontWeight: FontWeight.w300,
              fontSize: FontSize.s20,
            ),
          ),
          SvgPicture.asset(AppImages.menuIcon),
          SizedBox(
            width: AppSize.s21.w,
          ),
        ],
      ),
    );
  }
}

class NewNavScreen extends StatelessWidget {
  final String menuTitle;
  final String? menuIconPath;
  final Color? iconColor;
  final double? iconHeight;
  final bool withLeading;
  final bool withTrailing;
  final bool withDrawer;
  final Function() drawerAction;
  const NewNavScreen(
      {Key? key,
      required this.menuTitle,
      required this.drawerAction,
      this.iconColor,
      this.iconHeight,
      this.menuIconPath,
      this.withTrailing = false,
      this.withLeading = false,
      this.withDrawer = true
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthenticationProvider>();
    return Container(
      height: AppSize.s54.h,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AppImages.headerBgImage), fit: BoxFit.cover)),
      alignment: Alignment.center,
      child: Row(
        children: [
          SizedBox(
            width: AppSize.s17.w,
          ),
          InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: SvgPicture.asset(AppImages.arrowLeftSvg)),
          SizedBox(
            width: AppSize.s16.w,
          ),
          withLeading && withTrailing == false
              ? Padding(
                  padding: const EdgeInsets.only(right: AppSize.s4),
                  child: ClipOval(
                    child: Container(
                      color: ColorManager.blackTextColor,
                      height: AppSize.s30.h,
                      width: AppSize.s25.w,
                      child: Center(
                          child: CustomText(
                        text: 'e',
                        fontSize: FontSize.s24,
                        textColor: ColorManager.primaryColor,
                      )),
                    ),
                  ),
                )
              : SizedBox(),
          CustomTextWithLineHeight(
            text: menuTitle,
            textColor: ColorManager.blackTextColor,
            fontWeight: FontWeight.w400,
            fontSize: FontSize.s20,
          ),
          SizedBox(
            width: AppSize.s10.w,
          ),
          withTrailing && withLeading == false
              ? SvgPicture.asset(
                  menuIconPath!,
                  color: iconColor ?? ColorManager.blackColor,
                  height: iconHeight,
                )
              : SizedBox(),
          const Spacer(),
        withDrawer ?   InkWell(
              onTap: drawerAction, child: SvgPicture.asset(AppImages.menuIcon)) : SizedBox(),
          SizedBox(
            width: AppSize.s21.w,
          ),
        ],
      ),
    );
  }
}

class ChatNavScreen extends StatelessWidget {
  final String menuTitle;
  final String subtitle;
  final String? submenuIcon;
  final String? menuIconPath;
  final bool withLeading;
  final bool withTrailing;
  final Function() drawerAction;
  const ChatNavScreen(
      {Key? key,
      required this.menuTitle,
      required this.subtitle,
      required this.drawerAction,
      this.submenuIcon,
      this.withTrailing = false,
      this.withLeading = false,
      this.menuIconPath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthenticationProvider>();
    return Container(
      height: AppSize.s54.h,
      alignment: Alignment.center,
      child: Row(
        children: [
          SizedBox(
            width: AppSize.s17.w,
          ),
          InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: SvgPicture.asset(AppImages.arrowLeftSvg,
                  color: ColorManager.primaryColor)),
          SizedBox(
            width: AppSize.s16.w,
          ),
          withLeading && withTrailing == false
              ? Padding(
                  padding: const EdgeInsets.only(right: AppSize.s4),
                  child: ClipOval(
                    child: Container(
                      color: ColorManager.primaryColor,
                      height: AppSize.s30.h,
                      width: AppSize.s25.w,
                      child: Center(
                          child: CustomText(
                        text: 'e',
                        fontSize: FontSize.s24,
                        textColor: ColorManager.blackTextColor,
                      )),
                    ),
                  ),
                )
              : SizedBox(),
          SizedBox(
            width: AppSize.s7.w,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextWithLineHeight(
                text: menuTitle,
                textColor: ColorManager.primaryColor,
                fontWeight: FontWeight.w400,
                fontSize: FontSize.s20,
              ),
              CustomTextWithLineHeight(
                text: subtitle,
                textColor: ColorManager.primaryColor,
                fontWeight: FontWeight.w300,
                fontSize: FontSize.s12,
              ),
            ],
          ),
          SizedBox(
            width: AppSize.s10.w,
          ),
          withTrailing && withLeading == false
              ? SvgPicture.asset(submenuIcon!)
              : SizedBox(),
          const Spacer(),
          SvgPicture.asset(
            menuIconPath ?? AppImages.chatIconFill,
            color: ColorManager.primaryColor,
          ),
          SizedBox(
            width: AppSize.s21.w,
          ),
        ],
      ),
    );
  }
}

class NavScreen3 extends StatelessWidget {
  final String title;
  final double positionSize;

  const NavScreen3({Key? key, required this.title, required this.positionSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
        Spacer(),
        Stack(fit: StackFit.loose, children: [
          Container(
            // width: AppSize.s156.w,
            padding: EdgeInsets.symmetric(horizontal: AppSize.s30.w),
            height: AppSize.s48.w,
            decoration: BoxDecoration(
                color: ColorManager.bgColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppSize.s23.r),
                    bottomLeft: Radius.circular(AppSize.s23.r)),
                border: Border.all(color: ColorManager.primaryColor)),
            alignment: Alignment.center,
            child: CustomText(
              text: title,
              textColor: ColorManager.primaryColor,
              fontSize: FontSize.s20,
            ),
          ),
          Positioned(
            left: positionSize,
            child: Container(
              width: AppSize.s10.w,
              padding: EdgeInsets.symmetric(horizontal: AppSize.s30.w),
              height: AppSize.s48.w,
              decoration: BoxDecoration(
                  color: ColorManager.bgColor,
                  border: Border(
                    top: BorderSide(color: ColorManager.primaryColor),
                    bottom: BorderSide(color: ColorManager.primaryColor),
                  )),
              alignment: Alignment.center,
            ),
          ),
        ])
      ],
    );
  }
}
