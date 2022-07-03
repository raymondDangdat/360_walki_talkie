import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:walkie_talkie_360/views/nav_screen/channel/channel_view.dart';
import 'package:walkie_talkie_360/views/nav_screen/chats/chat_view.dart';
import 'package:walkie_talkie_360/views/nav_screen/contact/contact_view.dart';
import 'package:walkie_talkie_360/views/nav_screen/message/message_view.dart';

import '../../resources/color_manager.dart';
import '../../resources/image_manager.dart';
import '../../resources/value_manager.dart';

class NavScreenView extends StatefulWidget {
  const NavScreenView({Key? key}) : super(key: key);

  @override
  State<NavScreenView> createState() => _NavScreenViewState();
}

class _NavScreenViewState extends State<NavScreenView> {

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
    return Scaffold(
      backgroundColor: ColorManager.bgColor,
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
