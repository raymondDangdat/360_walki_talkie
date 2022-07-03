
import 'package:flutter/material.dart';
import 'package:walkie_talkie_360/resources/routes_manager.dart';


void openAccountCreateScreen(BuildContext context) async{
  Navigator.pushNamed(context, Routes.createAccount);
}

void openGetStartedScreen(BuildContext context) async{
  Navigator.pushNamed(context, Routes.getStartedScreen);
}

void openChannelTypeScreen(BuildContext context) async{
  Navigator.pushNamed(context, Routes.channelTypes);
}

void openNavScreen(BuildContext context) async{
  Navigator.pushReplacementNamed(context, Routes.navScreenView);
}
