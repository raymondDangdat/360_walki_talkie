import 'package:flutter/material.dart';
import 'package:walkie_talkie_360/resources/strings_manager.dart';
import 'package:walkie_talkie_360/views/channels_type_view/channel_types_view.dart';

import '../views/create_account_view/create_account_view.dart';
import '../views/get_started_screen/get_started_screen.dart';
import '../views/on_boarding_screen/on_boarding_two.dart';


class Routes {
  static const String initialRoute = "/";
  static const String onBoarding = "/on_boarding";
  static const String createAccount = "/create_account";
  static const String getStartedScreen = "/get_started_screen";
  static const String channelTypes = "/channel_types";

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
