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

class ManageChannelUsers extends StatefulWidget {
  const ManageChannelUsers({Key? key}) : super(key: key);

  @override
  State<ManageChannelUsers> createState() => _ManageChannelUsersState();
}

class _ManageChannelUsersState extends State<ManageChannelUsers> {
  final channelNameController = TextEditingController();

  bool channelNameFound = false;
  bool isSearching = false;
  String channelName = "";
  String channelId = "";

  List<UserChannelModel> allChannels = [];
  List<UserChannelModel> searchList = [];
  QuerySnapshot? channelSnapshot;

  // void getAllChannels() async {
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
    final authProvider = context.watch<AuthenticationProvider>();
    final channelProvider = context.watch<ChannelProvider>();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ColorManager.bgColor,
      body: SafeArea(
          child: Column(
        children: [
          SizedBox(height: AppSize.s20.h),
          NewNavScreen(
            withDrawer: false,
            menuTitle: AppStrings.manageChannelMembers,
            drawerAction: () {},
          ),
          SizedBox(height: AppSize.s20),
          Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: authProvider.userChannelsConnected.length,
                  itemBuilder: (context, index) {
                    final channel = authProvider.userChannelsConnected[index];
                    return Column(
                      children: [
                        InkWell(
                          onTap: () async {
                            if (channelProvider
                                    .channelConnectedIndexToShowSubChannels ==
                                index) {
                              channelProvider
                                  .showConnectedSubChannelsAtIndex(-1);
                            } else {
                              final subChannels =
                                  await channelProvider.getChannelSubChannels(
                                      context, channel.channelId, channel);
                              if (subChannels.isEmpty) {
                                //if the list of sub channels is empty, take user to push and talk screen
                                channelProvider.setSelectedChannel(channel);
                                channelProvider.getChannelMembers(
                                    context, channel.channelId);
                              } else {
                                //show sub-channels
                                channelProvider
                                    .showConnectedSubChannelsAtIndex(index);
                              }
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.only(bottom: AppSize.s3.h),
                            child: Container(
                              height: AppSize.s52.h,
                              width: double.infinity,
                              child: Padding(
                                padding: EdgeInsets.only(left: AppSize.s16.w),
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
                                          textColor:
                                              ColorManager.blackTextColor,
                                        )),
                                      ),
                                    ),
                                    SizedBox(
                                      width: AppSize.s10.w,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomTextWithLineHeight(
                                            text: channel.channelName,
                                            textColor:
                                                ColorManager.primaryColor),
                                        CustomText(
                                          text: 'created on 23 Sept, 2020',
                                          fontSize: FontSize.s12,
                                          textColor: ColorManager.primaryColor,
                                        )
                                      ],
                                    ),
                                    const Spacer(),
                                    SvgPicture.asset(AppImages.dropdownIcon),
                                    SizedBox(width: AppSize.s10),
                                  ],
                                ),
                              ),
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                        channelProvider.channelConnectedIndexToShowSubChannels ==
                                    index &&
                                !channelProvider.isLoadingSubChannels
                            ? Padding(
                                padding: EdgeInsets.only(
                                    bottom: channelProvider.subChannels.isEmpty
                                        ? 0
                                        : 3.h),
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: channelProvider
                                            .subChannels.isEmpty
                                        ? channelProvider.subChannels.length
                                        : channelProvider.subChannels.length,
                                    itemBuilder: (context, index) {
                                      final subChannel =
                                          channelProvider.subChannels[index];
                                      return Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            AppSize.s18,
                                            index == 0
                                                ? AppSize.s10.h
                                                : AppSize.s5,
                                            AppSize.s10,
                                            AppSize.s5),
                                        child: SizedBox(
                                          height: AppSize.s40.h,
                                          width: double.infinity,
                                          child: Row(
                                            children: [
                                              ClipOval(
                                                child: Container(
                                                  color: ColorManager
                                                      .primaryColor
                                                      .withOpacity(.4),
                                                  height: AppSize.s40.h,
                                                  width: AppSize.s35.w,
                                                  child: Center(
                                                      child: CustomText(
                                                    text: 'c',
                                                    fontSize: FontSize.s28,
                                                    textColor: ColorManager
                                                        .primaryColor,
                                                  )),
                                                ),
                                              ),
                                              SizedBox(width: AppSize.s10.w),
                                              SizedBox(
                                                width: AppSize.s150.w,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    CustomText(
                                                      text: 'Clement Bako',
                                                      fontSize: FontSize.s16,
                                                      textColor: ColorManager
                                                          .primaryColor,
                                                    ),
                                                    CustomText(
                                                      text:
                                                          'created on 23 Sept, 2020',
                                                      fontSize: FontSize.s12,
                                                      textColor: ColorManager
                                                          .primaryColor,
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: AppSize.s8,
                                                    vertical: AppSize.s5),
                                                width: AppSize.s70.w,
                                                height: AppSize.s50,
                                                decoration: BoxDecoration(
                                                  color:
                                                      ColorManager.primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          AppSize.s20.r),
                                                ),
                                                child: InkWell(
                                                    onTap: () {},
                                                    child: Center(
                                                      child: CustomText(
                                                          text: 'remove',
                                                          fontSize:
                                                              FontSize.s14,
                                                          textColor: ColorManager
                                                              .blackTextColor),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              )
                            : Container()
                      ],
                    );
                  })),
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
