import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:walkie_talkie_360/provider/authentication_provider.dart';
import 'package:walkie_talkie_360/provider/channel_provider.dart';
import 'package:walkie_talkie_360/resources/color_manager.dart';
import 'package:walkie_talkie_360/resources/font_manager.dart';
import 'package:walkie_talkie_360/resources/image_manager.dart';
import 'package:walkie_talkie_360/resources/strings_manager.dart';
import 'package:walkie_talkie_360/resources/value_manager.dart';
import 'package:walkie_talkie_360/widgets/custom_text.dart';

import '../../set_meeting_appointment/meeting_alert_widget.dart';

class ChatView extends StatefulWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late CountdownTimerController controller;
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60;

  @override
  void initState() {
    super.initState();
    controller = CountdownTimerController(endTime: endTime);
    buildAlertDialog();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  buildAlertDialog() {
    return Future.delayed(Duration(seconds: 1))
        .then((value) => showGeneralDialog(
              anchorPoint: Offset(0, 90),
              context: context,
              barrierColor: Colors.black.withOpacity(0.5),
              pageBuilder: (_, __, ___) {
                return MeetingAlert(
                  controller: controller,
                  endTime: endTime,
                  onAccept: () {
                    if (controller.isRunning) {
                      controller.disposeTimer();
                    }
                    ;
                    Navigator.of(context).pop();
                  },
                  onReject: () {
                    if (controller.isRunning) {
                      controller.disposeTimer();
                    }
                    ;
                    Navigator.of(context).pop();
                  },
                  onEnd: () {
                    controller.disposeTimer();
                    Navigator.of(context).pop();
                  },
                );
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthenticationProvider>();
    final channelProvider = context.watch<ChannelProvider>();
    return SafeArea(
      child: Column(
        children: [
          // SizedBox(height: AppSize.s20.h,),
          // const NavScreensHeader(),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: AppSize.s11.h,
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: AppSize.s21.h,
                      bottom: AppSize.s21.h,
                    ),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(AppImages.dashboardStats),
                          fit: BoxFit.cover),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: AppSize.s29.w,
                        ),
                        Image.asset(AppImages.wkt),
                        SizedBox(
                          width: AppSize.s40.w,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  CustomTextWithLineHeight(
                                    text:
                                        "${authProvider.userChannelsCreated.length}",
                                    textColor: ColorManager.textColor,
                                    fontSize: FontSize.s48,
                                  ),
                                  SizedBox(
                                      width: AppSize.s89.w,
                                      child: CustomTextWithLineHeight(
                                        text: AppStrings.channelCreated,
                                        textColor: ColorManager.textColor,
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  CustomTextWithLineHeight(
                                    text:
                                        "${authProvider.userChannelsConnected.length}",
                                    textColor: ColorManager.textColor,
                                    fontSize: FontSize.s48,
                                  ),
                                  SizedBox(
                                      width: AppSize.s89.w,
                                      child: CustomTextWithLineHeight(
                                        text: AppStrings.channelsConnectedTo,
                                        textColor: ColorManager.textColor,
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  CustomTextWithLineHeight(
                                    text: "0",
                                    textColor: ColorManager.textColor,
                                    fontSize: FontSize.s48,
                                  ),
                                  SizedBox(
                                      width: AppSize.s89.w,
                                      child: CustomTextWithLineHeight(
                                        text: AppStrings.messageReceived,
                                        textColor: ColorManager.textColor,
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  CustomTextWithLineHeight(
                                    text: "4",
                                    textColor: ColorManager.textColor,
                                    fontSize: FontSize.s48,
                                  ),
                                  SizedBox(
                                      width: AppSize.s89.w,
                                      child: CustomTextWithLineHeight(
                                        text: AppStrings.chatMessage,
                                        textColor: ColorManager.textColor,
                                      )),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: AppSize.s9.h,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: AppSize.s4.w),
                        child: CustomTextWithLineHeight(
                          text: AppStrings.channelCreated,
                          textColor: ColorManager.textColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: AppSize.s9.h,
                  ),
                  SizedBox(
                    // height: AppSize.s200.h,
                    child: authProvider.userChannelsCreated.isNotEmpty
                        ? Column(
                            children: [
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      authProvider.userChannelsCreated.length,
                                  itemBuilder: (context, index) {
                                    final channel =
                                        authProvider.userChannelsCreated[index];
                                    return Column(
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            if (channelProvider
                                                    .channelCreatedIndexToShowSubChannels ==
                                                index) {
                                              channelProvider
                                                  .showCreatedSubChannelsAtIndex(
                                                      -1);
                                            } else {
                                              final subChannels =
                                                  await channelProvider
                                                      .getChannelSubChannels(
                                                          context,
                                                          channel.channelId,
                                                          channel);
                                              if (subChannels.isEmpty) {
                                                //if the list of sub channels is empty, take user to push and talk screen
                                                channelProvider
                                                    .setSelectedChannel(
                                                        channel);
                                                channelProvider
                                                    .getChannelMembers(context,
                                                        channel.channelId);
                                              } else {
                                                //show sub-channels
                                                channelProvider
                                                    .showCreatedSubChannelsAtIndex(
                                                        index);
                                              }
                                            }
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                bottom: AppSize.s3.h),
                                            child: Container(
                                              height: AppSize.s52.h,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  color: ColorManager.textColor,
                                                  image: const DecorationImage(
                                                      image: AssetImage(
                                                          AppImages
                                                              .dashboardStats),
                                                      fit: BoxFit.cover)),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: AppSize.s16.w),
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset(AppImages
                                                        .mainChannelIcon),
                                                    SizedBox(
                                                      width: AppSize.s10.w,
                                                    ),
                                                    CustomTextWithLineHeight(
                                                        text:
                                                            channel.channelName,
                                                        textColor: ColorManager
                                                            .whiteColor),
                                                  ],
                                                ),
                                              ),
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                        ),
                                        channelProvider.channelCreatedIndexToShowSubChannels ==
                                                    index &&
                                                !channelProvider
                                                    .isLoadingSubChannels
                                            ? Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: channelProvider
                                                            .subChannels.isEmpty
                                                        ? 0
                                                        : 3.h),
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    itemCount: channelProvider
                                                            .subChannels.isEmpty
                                                        ? channelProvider
                                                            .subChannels.length
                                                        : channelProvider
                                                            .subChannels.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final subChannel =
                                                          channelProvider
                                                                  .subChannels[
                                                              index];
                                                      print("In here");
                                                      return Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: AppSize
                                                                    .s3.h),
                                                        child: InkWell(
                                                          onTap: () {
                                                            if (index == 0) {
                                                              //  route to main channel push to talk
                                                              channelProvider
                                                                  .setSelectedChannel(
                                                                      channel);
                                                              channelProvider
                                                                  .getChannelMembers(
                                                                      context,
                                                                      channel
                                                                          .channelId);
                                                            } else {
                                                              //  sub channel push to talk
                                                              channelProvider
                                                                  .setSelectedChannel(
                                                                      channel);
                                                              channelProvider
                                                                  .updateSelectedSubChannel(
                                                                      subChannel);
                                                              channelProvider.searchUserInSubChannelName(
                                                                  authProvider
                                                                      .userInfo
                                                                      .userName,
                                                                  authProvider
                                                                      .userInfo
                                                                      .fullName);
                                                              channelProvider.getSubChannelMembers(
                                                                  context,
                                                                  channel
                                                                      .channelId,
                                                                  subChannel
                                                                      .subChannelId);
                                                            }
                                                          },
                                                          child: index == 0
                                                              ? Container(
                                                                  height:
                                                                      AppSize
                                                                          .s52
                                                                          .h,
                                                                  width: double
                                                                      .infinity,
                                                                  decoration: const BoxDecoration(
                                                                      image: DecorationImage(
                                                                          image: AssetImage(AppImages
                                                                              .subChannelItem),
                                                                          fit: BoxFit
                                                                              .cover)),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(8),
                                                                    child: Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(right: AppSize.s10),
                                                                          child:
                                                                              SizedBox(child: SvgPicture.asset(AppImages.mainChannelIcon)),
                                                                        ),
                                                                        Expanded(
                                                                            child:
                                                                                Text(
                                                                          subChannel
                                                                              .subChannelName,
                                                                          style:
                                                                              TextStyle(color: ColorManager.whiteColor),
                                                                        )),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                )
                                                              : Container(
                                                                  height:
                                                                      AppSize
                                                                          .s52
                                                                          .h,
                                                                  width: double
                                                                      .infinity,
                                                                  decoration: const BoxDecoration(
                                                                      image: DecorationImage(
                                                                          image: AssetImage(AppImages
                                                                              .subChannelItem),
                                                                          fit: BoxFit
                                                                              .cover)),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(8),
                                                                    child: Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(right: AppSize.s10),
                                                                          child:
                                                                              SizedBox(child: SvgPicture.asset(AppImages.subChannelIcon)),
                                                                        ),
                                                                        Expanded(
                                                                            child:
                                                                                Text(
                                                                          subChannel
                                                                              .subChannelName,
                                                                          style:
                                                                              TextStyle(color: ColorManager.whiteColor),
                                                                        )),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                ),
                                                        ),
                                                      );
                                                    }),
                                              )
                                            : Container()
                                      ],
                                    );
                                  }),
                            ],
                          )
                        : CustomTextWithLineHeight(
                            text: "No Created Channels",
                            textColor: ColorManager.textColor,
                            fontSize: FontSize.s24,
                          ),
                  ),
                  SizedBox(
                    height: AppSize.s9.h,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: AppSize.s4.w),
                        child: CustomTextWithLineHeight(
                          text: AppStrings.channelsConnectedTo,
                          textColor: ColorManager.textColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: AppSize.s9.h,
                  ),
                  SizedBox(
                    child: authProvider.userChannelsConnected.isNotEmpty
                        ? Column(
                            children: [
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      authProvider.userChannelsConnected.length,
                                  itemBuilder: (context, index) {
                                    final channel = authProvider
                                        .userChannelsConnected[index];
                                    return Column(
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            if (channelProvider
                                                    .channelConnectedIndexToShowSubChannels ==
                                                index) {
                                              channelProvider
                                                  .showConnectedSubChannelsAtIndex(
                                                      -1);
                                            } else {
                                              final subChannels =
                                                  await channelProvider
                                                      .getChannelSubChannels(
                                                          context,
                                                          channel.channelId,
                                                          channel);
                                              if (subChannels.isEmpty) {
                                                //if the list of sub channels is empty, take user to push and talk screen
                                                channelProvider
                                                    .setSelectedChannel(
                                                        channel);
                                                channelProvider
                                                    .getChannelMembers(context,
                                                        channel.channelId);
                                              } else {
                                                //show sub-channels
                                                channelProvider
                                                    .showConnectedSubChannelsAtIndex(
                                                        index);
                                              }
                                            }
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                bottom: AppSize.s3.h),
                                            child: Container(
                                              height: AppSize.s52.h,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  color: ColorManager.textColor,
                                                  image: const DecorationImage(
                                                      image: AssetImage(
                                                          AppImages
                                                              .dashboardStats),
                                                      fit: BoxFit.cover)),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: AppSize.s16.w),
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset(AppImages
                                                        .mainChannelIcon),
                                                    SizedBox(
                                                      width: AppSize.s10.w,
                                                    ),
                                                    CustomTextWithLineHeight(
                                                        text:
                                                            channel.channelName,
                                                        textColor: ColorManager
                                                            .whiteColor),
                                                  ],
                                                ),
                                              ),
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                        ),
                                        channelProvider.channelConnectedIndexToShowSubChannels ==
                                                    index &&
                                                !channelProvider
                                                    .isLoadingSubChannels
                                            ? Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: channelProvider
                                                            .subChannels.isEmpty
                                                        ? 0
                                                        : 3.h),
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    itemCount: channelProvider
                                                            .subChannels.isEmpty
                                                        ? channelProvider
                                                            .subChannels.length
                                                        : channelProvider
                                                            .subChannels.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final subChannel =
                                                          channelProvider
                                                                  .subChannels[
                                                              index];
                                                      return Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: AppSize
                                                                    .s3.h),
                                                        child: InkWell(
                                                          onTap: () {
                                                            if (index == 0) {
                                                              //  route to main channel push to talk
                                                              channelProvider
                                                                  .setSelectedChannel(
                                                                      channel);
                                                              channelProvider
                                                                  .getChannelMembers(
                                                                      context,
                                                                      channel
                                                                          .channelId);
                                                            } else {
                                                              //  sub channel push to talk
                                                              channelProvider
                                                                  .setSelectedChannel(
                                                                      channel);
                                                              channelProvider.searchUserInSubChannelName(
                                                                  authProvider
                                                                      .userInfo
                                                                      .userName,
                                                                  authProvider
                                                                      .userInfo
                                                                      .fullName);
                                                              channelProvider
                                                                  .updateSelectedSubChannel(
                                                                      subChannel);
                                                              channelProvider.getSubChannelMembers(
                                                                  context,
                                                                  channel
                                                                      .channelId,
                                                                  subChannel
                                                                      .subChannelId);
                                                            }
                                                          },
                                                          child: index == 0
                                                              ? Container(
                                                                  height:
                                                                      AppSize
                                                                          .s52
                                                                          .h,
                                                                  width: double
                                                                      .infinity,
                                                                  decoration: const BoxDecoration(
                                                                      image: DecorationImage(
                                                                          image: AssetImage(AppImages
                                                                              .subChannelItem),
                                                                          fit: BoxFit
                                                                              .cover)),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(8),
                                                                    child: Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(right: AppSize.s10),
                                                                          child:
                                                                              SizedBox(child: SvgPicture.asset(AppImages.mainChannelIcon)),
                                                                        ),
                                                                        Expanded(
                                                                            child:
                                                                                Text(
                                                                          subChannel
                                                                              .subChannelName,
                                                                          style:
                                                                              TextStyle(color: ColorManager.whiteColor),
                                                                        )),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                )
                                                              : Container(
                                                                  height:
                                                                      AppSize
                                                                          .s52
                                                                          .h,
                                                                  width: double
                                                                      .infinity,
                                                                  decoration: const BoxDecoration(
                                                                      image: DecorationImage(
                                                                          image: AssetImage(AppImages
                                                                              .subChannelItem),
                                                                          fit: BoxFit
                                                                              .cover)),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(8),
                                                                    child: Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(right: AppSize.s10),
                                                                          child:
                                                                              SizedBox(child: SvgPicture.asset(AppImages.subChannelIcon)),
                                                                        ),
                                                                        Expanded(
                                                                            child:
                                                                                Text(
                                                                          subChannel
                                                                              .subChannelName,
                                                                          style:
                                                                              TextStyle(color: ColorManager.whiteColor),
                                                                        )),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                ),
                                                        ),
                                                      );
                                                    }),
                                              )
                                            : Container()
                                      ],
                                    );
                                  }),
                            ],
                          )
                        // ListView.builder(
                        //         shrinkWrap: true,
                        //         physics: const NeverScrollableScrollPhysics(),
                        //         itemCount:
                        //             authProvider.userChannelsConnected.length,
                        //         itemBuilder: (context, index) {
                        //           final channel =
                        //               authProvider.userChannelsConnected[index];
                        //           return Padding(
                        //               padding:
                        //                   EdgeInsets.only(bottom: AppSize.s3.h),
                        //               child: ExpansionWidget(
                        //                   initiallyExpanded: false,
                        //                   titleBuilder: (double animationValue, _,
                        //                       bool isExpanded, toggleFunction) {
                        //                     return InkWell(
                        //                       onTap: () =>
                        //                           toggleFunction(animated: true),
                        //                       child: Container(
                        //                         height: AppSize.s52.h,
                        //                         width: double.infinity,
                        //                         decoration: BoxDecoration(
                        //                             color: ColorManager.textColor,
                        //                             image: const DecorationImage(
                        //                                 image: AssetImage(AppImages
                        //                                     .dashboardStats),
                        //                                 fit: BoxFit.cover)),
                        //                         child: Padding(
                        //                           padding: const EdgeInsets.all(8),
                        //                           child: Row(
                        //                             crossAxisAlignment:
                        //                                 CrossAxisAlignment.center,
                        //                             children: [
                        //                               Padding(
                        //                                 padding:
                        //                                     const EdgeInsets.only(
                        //                                         right: AppSize.s10),
                        //                                 child: SizedBox(
                        //                                     child: SvgPicture.asset(
                        //                                         AppImages
                        //                                             .mainChannelIcon)),
                        //                               ),
                        //                               Expanded(
                        //                                   child: Text(
                        //                                       channel.channelName,
                        //                                       style: TextStyle(
                        //                                           color: ColorManager
                        //                                               .whiteColor))),
                        //                               Transform.rotate(
                        //                                 angle: math.pi *
                        //                                     animationValue /
                        //                                     2,
                        //                                 child: const Icon(
                        //                                     Icons.arrow_right,
                        //                                     size: 40),
                        //                                 alignment: Alignment.center,
                        //                               )
                        //                             ],
                        //                           ),
                        //                         ),
                        //                         alignment: Alignment.center,
                        //                       ),
                        //                     );
                        //                   },
                        //                   content: ListView.builder(
                        //                       shrinkWrap: true,
                        //                       physics: const NeverScrollableScrollPhysics(),
                        //                       itemCount: authProvider
                        //                           .userChannelsConnected.length,
                        //                       itemBuilder: (context, index) {
                        //                         final channel = authProvider
                        //                             .userChannelsConnected[index];
                        //                         return Padding(
                        //                             padding: EdgeInsets.only(
                        //                                 bottom: AppSize.s3.h),
                        //                             child: ExpansionWidget(
                        //                               initiallyExpanded: false,
                        //                               titleBuilder:
                        //                                   (double animationValue,
                        //                                       _,
                        //                                       bool isExpaned,
                        //                                       toogleFunction) {
                        //                                 return InkWell(
                        //                                   onTap: () {
                        //                                   },
                        //                                   child: Container(
                        //                                     height: AppSize.s52.h,
                        //                                     width: double.infinity,
                        //                                     decoration: const BoxDecoration(
                        //                                         image: DecorationImage(
                        //                                             image: AssetImage(
                        //                                                 AppImages
                        //                                                     .subChannelItem),
                        //                                             fit: BoxFit
                        //                                                 .cover)),
                        //                                     child: Padding(
                        //                                       padding:
                        //                                           const EdgeInsets
                        //                                               .all(8),
                        //                                       child: Row(
                        //                                         crossAxisAlignment:
                        //                                             CrossAxisAlignment
                        //                                                 .center,
                        //                                         children: [
                        //                                           Padding(
                        //                                             padding: const EdgeInsets
                        //                                                     .only(
                        //                                                 right: AppSize
                        //                                                     .s10),
                        //                                             child: SizedBox(
                        //                                                 child: SvgPicture.asset(
                        //                                                     AppImages
                        //                                                         .subChannelIcon)),
                        //                                           ),
                        //                                           Expanded(
                        //                                               child: Text(
                        //                                             channel
                        //                                                 .channelName,
                        //                                             style: TextStyle(
                        //                                                 color: ColorManager
                        //                                                     .whiteColor),
                        //                                           )),
                        //                                         ],
                        //                                       ),
                        //                                     ),
                        //                                     alignment:
                        //                                         Alignment.center,
                        //                                   ),
                        //                                 );
                        //                               },
                        //                               content: const SizedBox(),
                        //                             ));
                        //                       })));
                        //         })
                        : CustomTextWithLineHeight(
                            text: "No Connected Channels",
                            textColor: ColorManager.textColor,
                            fontSize: FontSize.s24,
                          ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
