import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:walkie_talkie_360/resources/routes_manager.dart';

void openAccountCreateScreen(BuildContext context) async {
  Navigator.pushNamed(context, Routes.createAccount);
}

void openGetStartedScreen(BuildContext context) async {
  Navigator.pushNamed(context, Routes.getStartedScreen);
}

void openNewGetStartedScreen(BuildContext context) async {
  Navigator.pushReplacementNamed(context, Routes.newGetStartedScreen);
}

void openChannelTypeScreen(BuildContext context) async {
  Navigator.pushNamed(context, Routes.channelTypes);
}

void openNavScreen(BuildContext context) async {
  Navigator.pushReplacementNamed(context, Routes.navScreenView);
}

void openChannelJoinedScreen(BuildContext context) async {
  Navigator.pushReplacementNamed(context, Routes.channelJoinedSuccessfully);
}

void openSubChannelJoinedScreen(BuildContext context) async {
  Navigator.pushReplacementNamed(context, Routes.subChannelJoinedSuccessfully);
}

void openAddChannelByName(
    {required BuildContext context, required bool fromSecondMenu}) async {
  fromSecondMenu
      ? Navigator.pushReplacementNamed(context, Routes.addByChannelName)
      : Navigator.pushNamed(context, Routes.addByChannelName);
}

void openAddChannelByQRCode(
    {required BuildContext context, required bool fromSecondMenu}) async {
  fromSecondMenu
      ? Navigator.pushReplacementNamed(context, Routes.addByQRCode)
      : Navigator.pushNamed(context, Routes.addByQRCode);
}

void openQRRequestSent(
    {required BuildContext context, required bool fromSecondMenu, required Barcode result}) async {
  fromSecondMenu
      ? Navigator.pushReplacementNamed(context, Routes.qrRequestSent, arguments: result)
      : Navigator.pushNamed(context, Routes.qrRequestSent);
}


void openCreateBrandNewChannel(BuildContext context) async {
  Navigator.pushNamed(context, Routes.createBrandNewChannel);
}

void openCreateSubChannel(
    {required BuildContext context, required bool fromSecondMenu}) async {
  fromSecondMenu
      ? Navigator.pushReplacementNamed(context, Routes.createSubChannel)
      : Navigator.pushNamed(context, Routes.createSubChannel);
}

void openAllChannels(
    {required BuildContext context, required bool fromSecondMenu}) async {
  fromSecondMenu
      ? Navigator.pushReplacementNamed(context, Routes.allChannelList)
      : Navigator.pushNamed(context, Routes.allChannelList);
}

void openViewChannels(
    {required BuildContext context, required bool fromSecondMenu}) async {
  fromSecondMenu
      ? Navigator.pushReplacementNamed(context, Routes.viewChannel)
      : Navigator.pushNamed(context, Routes.viewChannel);
}

void openChannelChat(
    {required BuildContext context, required bool fromSecondMenu}) async {
  fromSecondMenu
      ? Navigator.pushReplacementNamed(context, Routes.channelChat)
      : Navigator.pushNamed(context, Routes.channelChat);
}

void openMessageChat(
    {required BuildContext context, required bool fromSecondMenu}) async {
  fromSecondMenu
      ? Navigator.pushReplacementNamed(context, Routes.messageChat)
      : Navigator.pushNamed(context, Routes.messageChat);
}

void openSetMeetingAppt(
    {required BuildContext context, required bool fromSecondMenu}) async {
  fromSecondMenu
      ? Navigator.pushReplacementNamed(context, Routes.setMeetingAppointment)
      : Navigator.pushNamed(context, Routes.setMeetingAppointment);
}

void openManageMessage(
    {required BuildContext context, required bool fromSecondMenu}) async {
  fromSecondMenu
      ? Navigator.pushReplacementNamed(context, Routes.manageMessage)
      : Navigator.pushNamed(context, Routes.manageMessage);
}

void openUserManager(BuildContext context) async {
  Navigator.pushNamed(context, Routes.completeSubChannel);
}

void openCompleteSubChannel(BuildContext context) async {
  Navigator.pushNamed(context, Routes.completeSubChannel);
}

void openGenerateChannelQrCode(BuildContext context) async {
  Navigator.pushNamed(context, Routes.generateChannelQrCode);
}

void openFixPasswordScreen(BuildContext context) async {
  Navigator.pushNamed(context, Routes.fixPasswordScreen);
}

void openLoginScreen(BuildContext context) async {
  Navigator.pushNamed(context, Routes.loginScreen);
}

void openHowItWorksScreen(BuildContext context) async {
  Navigator.pushNamed(context, Routes.howItWorksScreen);
}

void openChannelMembersChats(BuildContext context) async {
  Navigator.pushNamed(context, Routes.channelMembersChats);
}

void openSubChannelMembersChats(BuildContext context) async {
  Navigator.pushNamed(context, Routes.subChannelMembersChats);
}

void openProfileScreen(BuildContext context) async {
  Navigator.pushNamed(context, Routes.profileScreen);
}

void openUpdateProfile(BuildContext context) async {
  Navigator.pushNamed(context, Routes.updateProfile);
}

void openResetPassword(BuildContext context) async {
  Navigator.pushNamed(context, Routes.resetPassword);
}

void openNotifications(BuildContext context) async {
  Navigator.pushNamed(context, Routes.notifications);
}

void openBlockChannels(BuildContext context) async {
  Navigator.pushNamed(context, Routes.blockChannel);
}

void openBlockUsers(BuildContext context) async {
  Navigator.pushNamed(context, Routes.blockUser);
}

void openManageChannelUsers(BuildContext context) async {
  Navigator.pushNamed(context, Routes.manageUsers);
}

void openSettingScreen(BuildContext context) async {
  Navigator.pushNamed(context, Routes.settingsScreen);
}

void openTermsAndConditions(BuildContext context) async {
  Navigator.pushNamed(context, Routes.termsAndConditions);
}

void openPrivacyPolicy(BuildContext context) async {
  Navigator.pushNamed(context, Routes.privacyPolicy);
}

void openFAQ(BuildContext context) async {
  Navigator.pushNamed(context, Routes.faq);
}
