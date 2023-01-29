import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:walkie_talkie_360/provider/authentication_provider.dart';
import 'package:walkie_talkie_360/provider/channel_provider.dart';
import 'package:walkie_talkie_360/views/create_brand_new_channel/models/user_channel_model.dart';
import 'package:walkie_talkie_360/widgets/reusable_widget.dart';

import '../../models/channel_model.dart';
import '../../resources/color_manager.dart';
import '../../resources/constanst.dart';
import '../../resources/font_manager.dart';
import '../../resources/image_manager.dart';
import '../../resources/navigation_utils.dart';
import '../../resources/strings_manager.dart';
import '../../resources/value_manager.dart';
import '../../widgets/customDrawer.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/nav_screens_header.dart';
import 'messages_widget.dart';

class ManageMessages extends StatefulWidget {
  const ManageMessages({Key? key}) : super(key: key);

  @override
  State<ManageMessages> createState() => _ManageMessagesState();
}

class _ManageMessagesState extends State<ManageMessages> {
  final channelNameController = TextEditingController();

  bool channelNameFound = false;
  bool isSearching = false;
  String channelName = "";
  String channelId = "";

  List<UserChannelModel> allChannels = [];
  List<UserChannelModel> searchList = [];
  QuerySnapshot? channelSnapshot;

  // void getAllChannels() async {
  //
  //
  //   await getChannels().then((value) {
  //     channelSnapshot = value;
  //     allChannels = channelSnapshot!.docs
  //         .map((doc) => SearchChannelModel.fromSnapshot(doc))
  //         .toList();
  //     print("Channels length: ${allChannels.length}");
  //     isSearching = false;
  //     setState(() {});
  //   });
  // }

  getChannels() async {
    return await FirebaseFirestore.instance.collection("channelNames").get();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final auth = Provider.of<AuthenticationProvider>(context, listen: false);

      allChannels.addAll(auth.userChannelsConnected);
      allChannels.addAll(auth.userChannelsCreated);
    });
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ColorManager.bgColor,
      endDrawer: customDrawer(context: context, fromSecondMenu: true),
      body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: AppSize.s46.h),
              Container(
                height: AppSize.s54.h,
                decoration: BoxDecoration(color: ColorManager.textColor),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NewNavScreen(
                      menuTitle: 'message',
                     iconHeight: 23,

                     withTrailing: true,
                      menuIconPath: AppImages.profileEmailIcon,
                      drawerAction: () {
                        _scaffoldKey.currentState?.openEndDrawer();
                      },
                    ),
                  ],
                ),
              ),

              MessagesWidget(),
            ],
          )),
    );
  }

  void searchUserName(BuildContext context, String value) async {
    try {
      DocumentSnapshot doc =
      await channelNamesCollection.doc(value.toLowerCase()).get();
      setState(() {
        // print("Docs: $doc");
      });

      if (doc.exists) {
        print("Username exist");
        setState(() {
          channelNameFound = true;
          isSearching = false;
          channelId = doc['channelId'];
          channelName = doc['channelName'];
        });
      } else {
        setState(() {
          channelNameFound = false;
          isSearching = false;
        });
        // print("Username not taken");
      }
    } catch (e) {
      // print("Error: ${e.toString()}");

    }

    setState(() {
      isSearching = false;
    });
  }
}
