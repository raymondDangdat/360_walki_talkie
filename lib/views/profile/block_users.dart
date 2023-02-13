import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
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
import '../../widgets/loading.dart';
import '../../widgets/nav_screens_header.dart';

class BlockUsers extends StatefulWidget {
  const BlockUsers({Key? key}) : super(key: key);

  @override
  State<BlockUsers> createState() => _BlockUsersState();
}

class _BlockUsersState extends State<BlockUsers> {
  final channelNameController = TextEditingController();
  bool channelNameFound = false;
  bool ready = false;
  bool refreshScreen = false;
  int tappedIndex = 99;
  bool isSearching = false;
  String channelName = "";
  String channelId = "";

  List<UserChannelModel> allChannels = [];
  List<UserChannelModel> searchList = [];
  QuerySnapshot? channelSnapshot;

  getChannels() async {
    return await FirebaseFirestore.instance.collection("channelNames").get();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final auth = Provider.of<AuthenticationProvider>(context, listen: false);
      allChannels.addAll(auth.userChannelsCreated);
    });
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthenticationProvider>();
    final channelProvider = context.watch<ChannelProvider>();

    fetchData({required UserChannelModel channel, required int index}) {
      FirebaseFirestore.instance
          .collection('channels')
          .doc(channel.channelId)
          .collection("members")
          .get()
          .then((QuerySnapshot querySnapshot) {
        Navigator.pop(context);
        setState(() {
          ready = true;
          channelSnapshot = querySnapshot;
        });
      });
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ColorManager.bgColor,
      body: SafeArea(
          child: Column(
        children: [
          SizedBox(height: AppSize.s20.h),
          NavScreen3(
            title: AppStrings.blockUser,
            positionSize: AppSize.s200,
          ),
          SizedBox(height: AppSize.s20),
          Expanded(
              child: authProvider.userChannelsCreated.isEmpty
                  ? Center(
                      child: CustomTextNoOverFlow(
                          textColor: ColorManager.primaryColor,
                          text: 'you have not created a channel yet,'))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: authProvider.userChannelsCreated.length,
                      itemBuilder: (context, index) {
                        final channel = authProvider.userChannelsCreated[index];
                        String initialString = '';

                        if (channel.channelName.length > 0) {
                          initialString = channel.channelName[0];
                        }

                        return Column(
                          children: [
                            InkWell(
                              onTap: () async {
                                setState(() {
                                  tappedIndex = index;
                                });
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) =>
                                        const LoadingIndicator());

                                fetchData(channel: channel, index: index);
                              },
                              child: Padding(
                                padding: EdgeInsets.only(bottom: AppSize.s3.h),
                                child: Container(
                                  height: AppSize.s52.h,
                                  width: double.infinity,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(left: AppSize.s16.w),
                                    child: Row(
                                      children: [
                                        ClipOval(
                                          child: Container(
                                            color: ColorManager.primaryColor,
                                            height: AppSize.s40.h,
                                            width: AppSize.s35.w,
                                            child: Center(
                                                child: CustomText(
                                              text: initialString,
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
                                            Builder(
                                              builder: (BuildContext context) {
                                                Timestamp myTimeStamp =
                                                    Timestamp.fromDate(DateTime
                                                        .now()); //To Tim

                                                DateTime dt =
                                                    (channel.createdAt ??
                                                            myTimeStamp)
                                                        .toDate();

                                                DateTime tempDate =
                                                    new DateFormat(
                                                            "yyyy-MM-dd hh:mm:ss")
                                                        .parse(dt.toString());
                                                String formattedDate =
                                                    DateFormat('dd MMM, yyyy')
                                                        .format(tempDate);

                                                return CustomText(
                                                  text:
                                                      'created on $formattedDate',
                                                  fontSize: FontSize.s12,
                                                  textColor:
                                                      ColorManager.primaryColor,
                                                );
                                              },
                                            )
                                          ],
                                        ),
                                        const Spacer(),
                                        SvgPicture.asset(
                                            AppImages.dropdownIcon),
                                        SizedBox(width: AppSize.s10),
                                      ],
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                ),
                              ),
                            ),
                            ready == true && tappedIndex == index
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        bottom: 15.h, left: 30.w),
                                    child: ListView(
                                      shrinkWrap: true,
                                      children: channelSnapshot!.docs
                                          .map((DocumentSnapshot document) {
                                        Map<String, dynamic> data = document
                                            .data()! as Map<String, dynamic>;

                                        Timestamp myTimeStamp =
                                            Timestamp.fromDate(
                                                DateTime.now()); //To Tim

                                        DateTime dt =
                                            (data['createdAt'] ?? myTimeStamp)
                                                .toDate();

                                        DateTime tempDate = new DateFormat(
                                                "yyyy-MM-dd hh:mm:ss")
                                            .parse(dt.toString());
                                        String formattedDate =
                                            DateFormat('dd MMM, yyyy')
                                                .format(tempDate);

                                        String initialString = '';

                                        if (data['username'].length > 0) {
                                          initialString = data['username'][0];
                                        }

                                        return data.isEmpty
                                            ? Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    AppSize.s18,
                                                    index == 0
                                                        ? AppSize.s10.h
                                                        : AppSize.s5,
                                                    AppSize.s10,
                                                    AppSize.s5),
                                                child: CustomTextNoOverFlow(
                                                  textColor:
                                                      ColorManager.primaryColor,
                                                  text:
                                                      'Channel has no member yet',
                                                ),
                                              )
                                            : Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    AppSize.s18,
                                                    index == 0
                                                        ? AppSize.s10.h
                                                        : AppSize.s5,
                                                    AppSize.s10,
                                                    AppSize.s5),
                                                child: SizedBox(
                                                  height: AppSize.s48.h,
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
                                                            text: initialString,
                                                            fontSize:
                                                                FontSize.s28,
                                                            textColor:
                                                                ColorManager
                                                                    .primaryColor,
                                                          )),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          width: AppSize.s10.w),
                                                      SizedBox(
                                                        width: AppSize.s150.w,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            CustomText(
                                                              text: data[
                                                                  'username'],
                                                              fontSize:
                                                                  FontSize.s16,
                                                              textColor:
                                                                  ColorManager
                                                                      .primaryColor,
                                                            ),
                                                            Expanded(
                                                              child:
                                                                  CustomTextNoOverFlow(
                                                                text:
                                                                    'created on $formattedDate',
                                                                fontSize:
                                                                    FontSize
                                                                        .s12,
                                                                textColor:
                                                                    ColorManager
                                                                        .primaryColor,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    AppSize.s8,
                                                                vertical:
                                                                    AppSize.s5),
                                                        width: AppSize.s70.w,
                                                        height: AppSize.s50,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: ColorManager
                                                                  .primaryColor),
                                                          color: data["isBlocked"] ==
                                                                  true
                                                              ? ColorManager
                                                                  .primaryColor
                                                              : null,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      AppSize
                                                                          .s20
                                                                          .r),
                                                        ),
                                                        child: InkWell(
                                                            onTap: () {
                                                              showDialog(
                                                                  barrierDismissible:
                                                                      false,
                                                                  context:
                                                                      context,
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      const LoadingIndicator());

                                                              if (data[
                                                                      'isBlocked'] ==
                                                                  false) {
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'channels')
                                                                    .doc(channel
                                                                        .channelId)
                                                                    .collection(
                                                                        "members")
                                                                    .doc(data[
                                                                        'userId'])
                                                                    .update({
                                                                  'isBlocked':
                                                                      true
                                                                }).then((value) {
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'users')
                                                                      .doc(data[
                                                                          'userId'])
                                                                      .collection(
                                                                          'channels')
                                                                      .doc(channel
                                                                          .channelId)
                                                                      .update({
                                                                    'isBlocked':
                                                                        true
                                                                  }).then((value) {
                                                                    fetchData(
                                                                        channel:
                                                                            channel,
                                                                        index:
                                                                            tappedIndex);
                                                                  });
                                                                });
                                                              } else {
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'channels')
                                                                    .doc(channel
                                                                        .channelId)
                                                                    .collection(
                                                                        "members")
                                                                    .doc(data[
                                                                        'userId'])
                                                                    .update({
                                                                  'isBlocked':
                                                                      false
                                                                }).then((value) {
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'users')
                                                                      .doc(data[
                                                                          'userId'])
                                                                      .collection(
                                                                          'channels')
                                                                      .doc(channel
                                                                          .channelId)
                                                                      .update({
                                                                    'isBlocked':
                                                                        false
                                                                  }).then((value) {
                                                                    fetchData(
                                                                        channel:
                                                                            channel,
                                                                        index:
                                                                            tappedIndex);
                                                                  });
                                                                });
                                                              }
                                                            },
                                                            child: Center(
                                                              child: CustomText(
                                                                  text: data["isBlocked"] ==
                                                                          true
                                                                      ? 'unblock'
                                                                      : 'block',
                                                                  fontSize:
                                                                      FontSize
                                                                          .s14,
                                                                  textColor: data[
                                                                              "isBlocked"] ==
                                                                          true
                                                                      ? ColorManager
                                                                          .blackTextColor
                                                                      : ColorManager
                                                                          .primaryColor),
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                      }).toList(),
                                    ),
                                  )
                                : Container()
                          ],
                        );
                      })),
        ],
      )),
    );
  }
}
