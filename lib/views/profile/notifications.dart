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

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
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
      body: SafeArea(
          child: Column(
        children: [
          SizedBox(height: AppSize.s20.h),
          NavScreen3(
            title: AppStrings.notification,
            positionSize: AppSize.s200,
          ),
          Expanded(
              child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSize.s15, AppSize.s20, AppSize.s10, 0),
                child: Row(
                  children: [
                    CustomText(
                        textColor: ColorManager.primaryColor,
                        fontWeight: FontWeightManager.bold,
                        text: 'today'),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppSize.s8, vertical: AppSize.s5),
                      width: AppSize.s70.w,
                      decoration: BoxDecoration(
                        color: ColorManager.primaryColor,
                        borderRadius: BorderRadius.circular(AppSize.s20.r),
                      ),
                      child: InkWell(
                          onTap: () {},
                          child: Center(
                            child: CustomText(
                              text: 'All',
                              fontSize: FontSize.s14,
                              textColor: ColorManager.blackTextColor,
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              SizedBox(
                  child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(
                        AppSize.s10,
                        index == 0 ? AppSize.s10.h : AppSize.s5,
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
                                text: 'e',
                                fontSize: FontSize.s28,
                                textColor: ColorManager.blackTextColor,
                              )),
                            ),
                          ),
                          SizedBox(width: AppSize.s10.w),
                          SizedBox(
                            width: AppSize.s150.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  text: 'Electrical department',
                                  fontSize: FontSize.s16,
                                  textColor: ColorManager.primaryColor,
                                ),
                                CustomText(
                                  text: 'created on 23 Sept, 2020',
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
                                borderRadius:
                                    BorderRadius.circular(AppSize.s20.r),
                                border: Border.all(
                                    color: ColorManager.primaryColor)),
                            child: InkWell(
                              onTap: () {
                               
                              },
                              child: Row(
                                children: [
                                  //SvgPicture.asset(AppImages.ey),
                                  Icon(Icons.remove_red_eye_outlined,
                                      size: AppSize.s18,
                                      color: ColorManager.primaryColor),
                                  Spacer(),
                                  CustomText(
                                    text: 'view',
                                    fontSize: FontSize.s14,
                                    textColor: ColorManager.primaryColor,
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              )),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSize.s15, AppSize.s20, AppSize.s10, 0),
                child: CustomText(
                    textColor: ColorManager.primaryColor,
                    fontWeight: FontWeightManager.bold,
                    text: 'yesterday'),
              ),
              SizedBox(
                  child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(
                        AppSize.s10,
                        index == 0 ? AppSize.s10.h : AppSize.s5,
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
                                text: 'e',
                                fontSize: FontSize.s28,
                                textColor: ColorManager.blackTextColor,
                              )),
                            ),
                          ),
                          SizedBox(width: AppSize.s10.w),
                          SizedBox(
                            width: AppSize.s150.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  text: 'Electrical department',
                                  fontSize: FontSize.s16,
                                  textColor: ColorManager.primaryColor,
                                ),
                                CustomText(
                                  text: 'created on 23 Sept, 2020',
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
                                borderRadius:
                                    BorderRadius.circular(AppSize.s20.r),
                                border: Border.all(
                                    color: ColorManager.primaryColor)),
                            child: InkWell(
                              onTap: () {

                              },
                              child: Row(
                                children: [
                                  //SvgPicture.asset(AppImages.ey),
                                  Icon(Icons.remove_red_eye_outlined,
                                      size: AppSize.s18,
                                      color: ColorManager.primaryColor),
                                  Spacer(),
                                  CustomText(
                                    text: 'view',
                                    fontSize: FontSize.s14,
                                    textColor: ColorManager.primaryColor,
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              )),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSize.s15, AppSize.s20, AppSize.s10, 0),
                child: CustomText(
                    textColor: ColorManager.primaryColor,
                    fontWeight: FontWeightManager.bold,
                    text: 'older'),
              ),
              SizedBox(
                  child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(
                        AppSize.s10,
                        index == 0 ? AppSize.s10.h : AppSize.s5,
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
                                text: 'e',
                                fontSize: FontSize.s28,
                                textColor: ColorManager.blackTextColor,
                              )),
                            ),
                          ),
                          SizedBox(width: AppSize.s10.w),
                          SizedBox(
                            width: AppSize.s150.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  text: 'Electrical department',
                                  fontSize: FontSize.s16,
                                  textColor: ColorManager.primaryColor,
                                ),
                                CustomText(
                                  text: 'created on 23 Sept, 2020',
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
                                borderRadius:
                                    BorderRadius.circular(AppSize.s20.r),
                                border: Border.all(
                                    color: ColorManager.primaryColor)),
                            child: InkWell(
                              onTap: () {

                              },
                              child: Row(
                                children: [
                                  //SvgPicture.asset(AppImages.ey),
                                  Icon(Icons.remove_red_eye_outlined,
                                      size: AppSize.s18,
                                      color: ColorManager.primaryColor),
                                  Spacer(),
                                  CustomText(
                                    text: 'view',
                                    fontSize: FontSize.s14,
                                    textColor: ColorManager.primaryColor,
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              )),
            ],
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