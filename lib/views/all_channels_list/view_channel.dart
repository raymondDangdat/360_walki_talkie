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

class ViewChannel extends StatefulWidget {
  const ViewChannel({Key? key}) : super(key: key);

  @override
  State<ViewChannel> createState() => _ViewChannelState();
}

class _ViewChannelState extends State<ViewChannel> {
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
                      menuTitle: 'electrical department',
                      withLeading: true,
                      menuIconPath: AppImages.channelIconPeople,
                      drawerAction: () {
                        _scaffoldKey.currentState?.openEndDrawer();
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.fromLTRB(
                            AppSize.s10,
                            index == 0 ? AppSize.s25.h : AppSize.s5,
                            AppSize.s10,
                            AppSize.s5),
                        child: SizedBox(
                          height: AppSize.s40.h,
                          width: double.infinity,
                          child: Row(
                            children: [
                              ClipOval(
                                child: Container(
                                  color: ColorManager.primaryColor,
                                  height: AppSize.s40.h,
                                  width: AppSize.s35.w,
                                  child: Center(
                                      child: CustomText(
                                        text: 'C',
                                        fontSize: FontSize.s28,
                                        textColor: ColorManager.blackTextColor,
                                      )),
                                ),
                              ),
                              SizedBox(width: AppSize.s10.w),
                              SizedBox(
                                width: AppSize.s200.w,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomText(
                                      text: 'Clement Bako',
                                      fontSize: FontSize.s16,
                                      textColor: ColorManager.primaryColor,
                                    ),
                                    CustomText(
                                      text: '5 minutes ago',
                                      fontSize: FontSize.s12,
                                      textColor: ColorManager.primaryColor,
                                    )
                                  ],
                                ),
                              ),
                              Spacer(),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: AppSize.s8, vertical: AppSize.s5),
                                width: AppSize.s70.w,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(AppSize.s20.r),
                                    border:
                                    Border.all(color: ColorManager.primaryColor)),
                                child: Row(
                                  children: [
                                    //SvgPicture.asset(AppImages.ey),
                                    Icon(Icons.mic_none,
                                        size: AppSize.s18,
                                        color: ColorManager.primaryColor),
                                    Spacer(),
                                    CustomText(
                                      text: 'talk',
                                      fontSize: FontSize.s14,
                                      textColor: ColorManager.primaryColor,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ))
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
