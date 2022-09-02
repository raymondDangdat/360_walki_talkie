import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:walkie_talkie_360/resources/navigation_utils.dart';
import 'package:walkie_talkie_360/resources/strings_manager.dart';
import 'package:walkie_talkie_360/views/nav_screen/channel/channel_view.dart';
import 'package:walkie_talkie_360/views/nav_screen/chats/chat_view.dart';
import 'package:walkie_talkie_360/views/nav_screen/contact/contact_view.dart';
import 'package:walkie_talkie_360/views/nav_screen/message/message_view.dart';

import '../../provider/authentication_provider.dart';
import '../../resources/color_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/image_manager.dart';
import '../../widgets/custom_text.dart';

class NavScreenView extends StatefulWidget {
  const NavScreenView({Key? key}) : super(key: key);

  @override
  State<NavScreenView> createState() => _NavScreenViewState();
}

class _NavScreenViewState extends State<NavScreenView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    ChatView(),
    MessageView(),
    ContactView(),
    ChannelView()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthenticationProvider>();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ColorManager.bgColor,
      endDrawer: Drawer(
        backgroundColor: ColorManager.primaryColor,
          child: ListView(
            children: [
              ListTile(
                onTap: (){
                  Navigator.pop(context);
                  openProfileScreen(context);
                },
                leading: const Icon(Icons.account_circle),
                title: CustomText(text: AppStrings.profile,
                  textColor: ColorManager.blackTextColor,
                  fontWeight: FontWeight.w300,
                  fontSize: FontSize.s20,
                ),
              ),
              ListTile(
                onTap: (){
                  Navigator.pop(context);
                  openSettingScreen(context);
                },
                leading: const Icon(Icons.settings),
                title: CustomText(text: AppStrings.settings,
                    textColor: ColorManager.blackTextColor,
                    fontWeight: FontWeight.w300,
                    fontSize: FontSize.s20,
              ),)
            ],
          ),
      ),
      appBar: AppBar(
        backgroundColor: ColorManager.primaryColor,
        title: CustomTextWithLineHeight(text: authProvider.userInfo.fullName,
          textColor: ColorManager.blackTextColor,
          fontWeight: FontWeight.w300,
          fontSize: FontSize.s20,),
        leading: Image.asset(AppImages.three60Small),
        actions: [
          InkWell(
            onTap: (){
              _scaffoldKey.currentState?.openEndDrawer();
            },
              child: SvgPicture.asset(AppImages.menuIcon)),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: ColorManager.bgColor,
        // showSelectedLabels: true,
        // showUnselectedLabels: true,
        enableFeedback: false,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(AppImages.chatIcon),
            label: "",
            activeIcon: SvgPicture.asset(AppImages.chatIcon),
            backgroundColor: ColorManager.textColor,
          ),
          BottomNavigationBarItem(
            icon:SvgPicture.asset(AppImages.messageIcon),
            activeIcon: SvgPicture.asset(AppImages.messageIcon),
            label: "",
            backgroundColor: ColorManager.textColor,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(AppImages.contactIocn),
            activeIcon: SvgPicture.asset(AppImages.contactIocn),
            label: "",
            backgroundColor: ColorManager.textColor,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(AppImages.channelIcon),
            activeIcon: SvgPicture.asset(AppImages.channelIcon,),
            label: "",
            backgroundColor: ColorManager.textColor,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: ColorManager.blackTextColor,
        unselectedItemColor: ColorManager.darkTextColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
