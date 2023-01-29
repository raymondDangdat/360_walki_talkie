import 'package:flutter/material.dart';

import '../resources/color_manager.dart';
import '../resources/font_manager.dart';
import '../resources/navigation_utils.dart';
import '../resources/strings_manager.dart';
import '../resources/value_manager.dart';
import 'custom_text.dart';

Drawer customDrawer(
    {required BuildContext context, required bool fromSecondMenu}) {
  return Drawer(
    backgroundColor: ColorManager.primaryColor,
    child: ListView(
      children: [

       ListTile(title:  CustomText(text: 'my walkie talkie',
         fontSize: AppSize.s30,
         textColor: ColorManager.blackTextColor.withOpacity(.2),
       )),


        drawerItem(
            onTap: () {
              Navigator.pop(context);
              openAllChannels(fromSecondMenu: fromSecondMenu, context: context);
            },
            title: AppStrings.allChannels),

        Divider(color: ColorManager.blackColor.withOpacity(.2), height: 0,),

        drawerItem(
            onTap: () {
              Navigator.pop(context);
              openAddChannelByQRCode(
                  context: context, fromSecondMenu: fromSecondMenu);
            },
            title: AppStrings.joinChannelViaQrCode),
        drawerItem(
            onTap: () {
              Navigator.pop(context);
              openCreateBrandNewChannel(context);
            },
            title: AppStrings.createNewChannel),
        drawerItem(
            onTap: () {
              Navigator.pop(context);
              openCreateSubChannel(
                  fromSecondMenu: fromSecondMenu, context: context);
            },
            title: AppStrings.createSubChannel),
        drawerItem(
            onTap: () {
              openSetMeetingAppt(
                  fromSecondMenu: fromSecondMenu, context: context);
            },
            title: AppStrings.setMeeting),
        drawerItem(
            onTap: () {
              Navigator.pop(context);
              openManageChannelUsers(context);
            },
            title: AppStrings.manageChannelMembers),
        drawerItem(
            onTap: () {
              Navigator.pop(context);
              openManageMessage(
                  fromSecondMenu: fromSecondMenu, context: context);
            },
            title: AppStrings.manageMessages),
        drawerItem(
            onTap: () {
              Navigator.pop(context);
              openProfileScreen(context);
            },
            title: AppStrings.profile),
        drawerItem(
            onTap: () {
              Navigator.pop(context);
              openSettingScreen(context);
            },
            title: AppStrings.settings),
        drawerItem(
            onTap: () {
              Navigator.pop(context);
              openCreateSubChannel(
                  fromSecondMenu: fromSecondMenu, context: context);
            },
            title: AppStrings.helpAndFeedbacks),
      ],
    ),
  );
}

SizedBox drawerItem({
  required Function() onTap,
  required String title,
}) {
  return SizedBox(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(color: ColorManager.blackColor.withOpacity(.2), height: 0,),
        Flexible(
          fit: FlexFit.loose,
          child: ListTile(
            contentPadding: EdgeInsets.only(left: AppPadding.p35),
            visualDensity: VisualDensity(horizontal: 0, vertical: -4),
            minLeadingWidth: 0,
            minVerticalPadding: 0,
            horizontalTitleGap: 10,
            dense: true,
            onTap: onTap,
            title: CustomText(
              text: title,
              textColor: ColorManager.blackTextColor,
              fontWeight: FontWeight.w300,
              fontSize: FontSize.s16,
            ),
          ),
        ),
        Divider(color: ColorManager.blackColor.withOpacity(.2), height: 0,),
      ],
    ),
  );
}
