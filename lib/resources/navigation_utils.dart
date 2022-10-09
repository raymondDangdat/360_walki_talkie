import 'package:flutter/material.dart';
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

void openAddChannelByName(BuildContext context) async {
  Navigator.pushNamed(context, Routes.addByChannelName);
}

void openCreateBrandNewChannel(BuildContext context) async {
  Navigator.pushNamed(context, Routes.createBrandNewChannel);
}

void openCreateSubChannel(BuildContext context) async {
  Navigator.pushNamed(context, Routes.createSubChannel);
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

void openSettingScreen(BuildContext context) async {
  Navigator.pushNamed(context, Routes.settingsScreen);
}
