import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:walkie_talkie_360/resources/strings_manager.dart';
import 'package:walkie_talkie_360/views/all_channels_list/all_channel_list.dart';
import 'package:walkie_talkie_360/views/all_channels_list/view_channel.dart';
import 'package:walkie_talkie_360/views/channel_users_list_and_chats/channel_members_chats.dart';
import 'package:walkie_talkie_360/views/channels_type_view/channel_types_view.dart';
import 'package:walkie_talkie_360/views/create_brand_new_channel/create_brand_new_channel.dart';
import 'package:walkie_talkie_360/views/fix_password_screen/fix_password_screen.dart';
import 'package:walkie_talkie_360/views/generate_channel_qr_code/generate_channel_qr_code.dart';
import 'package:walkie_talkie_360/views/how_it_works/how_it_works_screen.dart';
import 'package:walkie_talkie_360/views/join_channel/add_channel_by_qr_code.dart';
import 'package:walkie_talkie_360/views/join_channel/qr_code_request_sent.dart';
import 'package:walkie_talkie_360/views/joined_channel_successfull/joined_channel_successful.dart';
import 'package:walkie_talkie_360/views/joined_channel_successfull/joined_sub_channel_successful.dart';
import 'package:walkie_talkie_360/views/manage_messages/manage_messages.dart';
import 'package:walkie_talkie_360/views/nav_screen/nav_screen_view.dart';
import 'package:walkie_talkie_360/views/new_get_started_screen/new_get_started_screen.dart';
import 'package:walkie_talkie_360/views/profile/block_channel.dart';
import 'package:walkie_talkie_360/views/profile/block_users.dart';
import 'package:walkie_talkie_360/views/profile/edit_profile.dart';
import 'package:walkie_talkie_360/views/profile/manage_channel_users.dart';
import 'package:walkie_talkie_360/views/profile/profile_screen.dart';
import 'package:walkie_talkie_360/views/profile/reset_password.dart';
import 'package:walkie_talkie_360/views/set_meeting_appointment/set_meeting_appointment.dart';
import 'package:walkie_talkie_360/views/settings_view/faq.dart';
import 'package:walkie_talkie_360/views/settings_view/privacy_policy.dart';
import 'package:walkie_talkie_360/views/settings_view/terms_conditions.dart';
import 'package:walkie_talkie_360/views/splash_view/splash_view.dart';
import 'package:walkie_talkie_360/views/sub_channel_members_chat/sub_channel_members_chat.dart';
import '../views/all_channels_list/channel_chat.dart';
import '../views/create_account_view/create_account_view.dart';
import '../views/create_sub_channel/complete_sub_channel.dart';
import '../views/create_sub_channel/create_sub_channel.dart';
import '../views/get_started_screen/get_started_screen.dart';
import '../views/join_channel/add_channel_by_name.dart';
import '../views/login_screen/login_screen.dart';
import '../views/manage_messages/message_chat.dart';
import '../views/on_boarding_screen/on_boarding.dart';
import '../views/profile/notifications.dart';
import '../views/settings_view/settings_screen.dart';

class Routes {
  static const initialRoute = "/";
  static const onBoarding = "/on_boarding";
  static const createAccount = "/create_account";
  static const getStartedScreen = "/get_started_screen";
  static const newGetStartedScreen = "/new_get_started_screen";
  static const channelTypes = "/channel_types";
  static const viewChannel = "/view_channel";
  static const channelChat = "/channel_chat";
  static const navScreenView = "/nav_screen";
  static const messageChat = "/MessageChat";
  static const updateProfile = "/UpdateProfile";
  static const addByChannelName = "/add_by_channel_name";
  static const createBrandNewChannel = "/create_brand_new_channel";
  static const createSubChannel = "/create_sub_channel";
  static const allChannelList = "/allChannelList";
  static const manageMessage = "/manageMessage";
  static const notifications = "/Notifications";
  static const setMeetingAppointment = "/setMeetingAppointment";
  static const completeSubChannel = "/complete_sub_channel";
  static const blockUser= "/blockuser";
  static const termsAndConditions= "/TermsAndConditions";
  static const privacyPolicy  = "/PrivacyPolicy";
  static const blockChannel= "/block user";
  static const generateChannelQrCode = "/generate_qr_code";
  static const loginScreen = "/login_screen";
  static const fixPasswordScreen = "/fix_password_screen";
  static const howItWorksScreen = "/how_it_works";
  static const profileScreen = "/profile_screen";
  static const resetPassword = "/ResetPassword";
  static const channelMembersChats = "/channel_members_chats";
  static const subChannelMembersChats = "/sub_channel_members_chats";
  static const settingsScreen = "/settings_screen";
  static const channelJoinedSuccessfully = "/channel_joined_successfully";
  static const subChannelJoinedSuccessfully = "/sub_channel_joined_successfully";
  static const faq = "/faqScreen";
  static const addByQRCode = "/AddByQRCode";
  static const qrRequestSent = "/qrRequestSentScreen";
  static const manageUsers = "/manageUsers";
}

class RouteGenerator {

  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  static Future<dynamic>? navigateTo(String routeName, {Object? args}) {
    return navigatorKey.currentState?.pushNamed(routeName, arguments: args);
  }

  static Future<dynamic>? navigateOff(String routeName, {Object? args}) {
    return navigatorKey.currentState
        ?.pushReplacementNamed(routeName, arguments: args);
  }

  static goBack() {
    return navigatorKey.currentState?.canPop();
  }


  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    final args = routeSettings.arguments;
    switch (routeSettings.name) {
      case Routes.initialRoute:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case Routes.onBoarding:
        return MaterialPageRoute(builder: (_) => const OnBoardingView());
      case Routes.createAccount:
        return MaterialPageRoute(builder: (_) => const CreateAccountView());
      case Routes.getStartedScreen:
        return MaterialPageRoute(builder: (_) => const GetStartedScreen());
      case Routes.newGetStartedScreen:
        return MaterialPageRoute(builder: (_) => const NewGetStartedScreen());
      case Routes.channelTypes:
        return MaterialPageRoute(builder: (_) => const ChannelTypesView());
      case Routes.navScreenView:
        return MaterialPageRoute(builder: (_) => const NavScreenView());
      case Routes.addByChannelName:
        return MaterialPageRoute(builder: (_) => const AddChannelByName());
      case Routes.createBrandNewChannel:
        return MaterialPageRoute(builder: (_) => const CreateBrandNewChannel());
      case Routes.createSubChannel:
        return MaterialPageRoute(builder: (_) => const CreateSubChannel());
      case Routes.allChannelList:
        return MaterialPageRoute(builder: (_) => const AllChannelList());
      case Routes.viewChannel:
        return MaterialPageRoute(builder: (_) => const ViewChannel());
      case Routes.channelChat:
        return MaterialPageRoute(builder: (_) => const ChannelChat());
      case Routes.setMeetingAppointment:
        return MaterialPageRoute(builder: (_) => const SetMeetingAppointment());
      case Routes.setMeetingAppointment:
        return MaterialPageRoute(builder: (_) => const SetMeetingAppointment());
      case Routes.completeSubChannel:
        return MaterialPageRoute(builder: (_) =>  const CompleteSubChannel());
      case Routes.generateChannelQrCode:
        return MaterialPageRoute(builder: (_) => const GenerateChannelQrCode());
      case Routes.loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.fixPasswordScreen:
        return MaterialPageRoute(builder: (_) => const FixPasswordScreen());
      case Routes.howItWorksScreen:
        return MaterialPageRoute(builder: (_) => const HowItWorks());
      case Routes.profileScreen:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case Routes.updateProfile:
        return MaterialPageRoute(builder: (_) => const UpdateProfile());
      case Routes.notifications:
        return MaterialPageRoute(builder: (_) => const Notifications());
      case Routes.resetPassword:
        return MaterialPageRoute(builder: (_) => const ResetPassword());
      case Routes.blockChannel:
        return MaterialPageRoute(builder: (_) => const BlockChannels());
      case Routes.blockUser:
        return MaterialPageRoute(builder: (_) => const BlockUsers());

      case Routes.manageUsers:
        return MaterialPageRoute(builder: (_) => const ManageChannelUsers());
      case Routes.channelMembersChats:
        return MaterialPageRoute(builder: (_) => const ChannelMembersChats());
      case Routes.subChannelMembersChats:
        return MaterialPageRoute(builder: (_) => const SubChannelMembersChats());

      case Routes.manageMessage:
        return MaterialPageRoute(builder: (_) => const ManageMessages());

      case Routes.messageChat:
        return MaterialPageRoute(builder: (_) => const MessageChat());

      case Routes.settingsScreen:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

      case Routes.channelJoinedSuccessfully:
        return MaterialPageRoute(
            builder: (_) => const JoinedChannelSuccessful());


      case Routes.subChannelJoinedSuccessfully:
        return MaterialPageRoute(
            builder: (_) => const JoinedSubChannelSuccessful());


      case Routes.privacyPolicy:
        return MaterialPageRoute(
            builder: (_) => const PrivacyPolicy());

      case Routes.termsAndConditions:
        return MaterialPageRoute(
            builder: (_) => const TermsAndConditions());

      case Routes.faq:
        return MaterialPageRoute(
            builder: (_) => const FaqScreen());

      case Routes.addByQRCode:
        return MaterialPageRoute(
            builder: (_) => const AddChannelByQRCode());

      case Routes.qrRequestSent:
        return MaterialPageRoute(
            builder: (_) =>  QrCodeRequestSubmitted(result: args as Barcode));


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
