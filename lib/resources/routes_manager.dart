import 'package:flutter/material.dart';
import 'package:walkie_talkie_360/resources/strings_manager.dart';
import 'package:walkie_talkie_360/views/add_channel_by_name/add_channel_by_name.dart';
import 'package:walkie_talkie_360/views/channels_type_view/channel_types_view.dart';
import 'package:walkie_talkie_360/views/create_brand_new_channel/create_brand_new_channel.dart';
import 'package:walkie_talkie_360/views/fix_password_screen/fix_password_screen.dart';
import 'package:walkie_talkie_360/views/generate_channel_qr_code/generate_channel_qr_code.dart';
import 'package:walkie_talkie_360/views/how_it_works/how_it_works_screen.dart';
import 'package:walkie_talkie_360/views/nav_screen/nav_screen_view.dart';

import '../views/create_account_view/create_account_view.dart';
import '../views/get_started_screen/get_started_screen.dart';
import '../views/login_screen/login_screen.dart';
import '../views/on_boarding_screen/on_boarding.dart';


class Routes {
  static const initialRoute = "/";
  static const onBoarding = "/on_boarding";
  static const createAccount = "/create_account";
  static const getStartedScreen = "/get_started_screen";
  static const channelTypes = "/channel_types";
  static const navScreenView = "/nav_screen";
  static const addByChannelName = "/add_by_channel_name";
  static const createBrandNewChannel = "/create_brand_new_channel";
  static const generateChannelQrCode = "/generate_qr_code";
  static const loginScreen = "/login_screen";
  static const fixPasswordScreen = "/fix_password_screen";
  static const howItWorksScreen = "/how_it_works";

}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.onBoarding:
        return MaterialPageRoute(builder: (_) => const OnBoardingView());
      case Routes.createAccount:
        return MaterialPageRoute(builder: (_) => const CreateAccountView());
      case Routes.getStartedScreen:
        return MaterialPageRoute(builder: (_) => const GetStartedScreen());
      case Routes.channelTypes:
        return MaterialPageRoute(builder: (_) => const ChannelTypesView());
      case Routes.navScreenView:
        return MaterialPageRoute(builder: (_) => const NavScreenView());
      case Routes.addByChannelName:
        return MaterialPageRoute(builder: (_) => const AddChannelByName());
      case Routes.createBrandNewChannel:
        return MaterialPageRoute(builder: (_) => const CreateBrandNewChannel());
      case Routes.generateChannelQrCode:
        return MaterialPageRoute(builder: (_) => const GenerateChannelQrCode());
      case Routes.loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.fixPasswordScreen:
        return MaterialPageRoute(builder: (_) => const FixPasswordScreen());
      case Routes.howItWorksScreen:
        return MaterialPageRoute(builder: (_) => const HowItWorks());
      default:
        return undefinedRoute();
    }
  }

  static Route<dynamic> undefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: const Text(AppStrings.noRouteFound),
              ),
              body: const Center(
                child: Text(AppStrings.noRouteFound),
              ),
            ));
  }
}
