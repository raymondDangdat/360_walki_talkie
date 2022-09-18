import 'dart:async';
import 'package:audio_session/audio_session.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:get/state_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:walkie_talkie_360/provider/authentication_provider.dart';
import 'package:walkie_talkie_360/provider/channel_provider.dart';
import 'package:walkie_talkie_360/resources/font_manager.dart';
import 'package:walkie_talkie_360/service/concretes/audio_player_adapter.dart';
import 'package:walkie_talkie_360/views/chat_display_view.dart';
import 'package:walkie_talkie_360/views/nav_screen/chats/chat_view.dart';

import '../../models/chat_records_model.dart';
import '../../resources/color_manager.dart';
import '../../resources/image_manager.dart';
import '../../resources/strings_manager.dart';
import '../../resources/value_manager.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/nav_screens_header.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';

const theSource = AudioSource.microphone;

class ChannelMembersChats extends StatefulWidget {
  const ChannelMembersChats({Key? key}) : super(key: key);

  @override
  State<ChannelMembersChats> createState() => _ChannelMembersChatsState();
}

class _ChannelMembersChatsState extends State<ChannelMembersChats> {
  bool isPlayingMsg = false, isRecording = false, isSending = false;
  String recordFilePath = "";

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthenticationProvider>();
    final channelProvider = context.watch<ChannelProvider>();

    return Scaffold(
        backgroundColor: ColorManager.bgColor,
        body: Stack(children: [
          const AudioStreaming(),
          ChannelMembersChatBody(
              authProvider: authProvider, channelProvider: channelProvider)
        ]));
  }
}

class AudioStreaming extends StatefulWidget {
  const AudioStreaming({
    Key? key,
  }) : super(key: key);

  @override
  State<AudioStreaming> createState() => _AudioStreamingState();
}

class _AudioStreamingState extends State<AudioStreaming> {
  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthenticationProvider>();
    final channelProvider = context.watch<ChannelProvider>();
    final Stream<QuerySnapshot> _recordingStream = FirebaseFirestore.instance
        .collection('channelRoom')
        .doc(channelProvider.selectedChannel.channelId)
        .collection('chats')
        .where("sendBy", isNotEqualTo: authProvider.userInfo.userName)
        .snapshots();

    return channelProvider.isRecording == true
        ? const SizedBox()
        : StreamBuilder(
            stream: _recordingStream,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading");
              }

              final records = snapshot.data!.docs.map((doc) {
                return ChatRecordsModel.fromSnapshot(doc);
              }).toList();
              records.sort((a, b) {
                int aDate = a.timeStamp.microsecondsSinceEpoch;
                int bDate = b.timeStamp.microsecondsSinceEpoch;
                return aDate.compareTo(bDate);
              });

              if (records[records.length - 1].record == null ||
                  records[records.length - 1].record == '') {
                if (kDebugMode) {
                  print("The path is empty");
                }
              } else {
                channelProvider
                    .downloadEncryptedFile(
                        url: records[records.length - 1].record)
                    .then((value) {
                  channelProvider
                      .decryptFile(encryptedFile: value.file.path)
                      .then((result) async {
                    final player = AudioPlayer();
                    await player.play(UrlSource(result));
                    channelProvider.deletePlayedSound(
                        currentDocId: records[records.length - 1].id);
                  });
                });
              }
              return const SizedBox();
            });
  }
}

class ChannelMembersChatBody extends StatefulWidget {
  const ChannelMembersChatBody({
    Key? key,
    required this.authProvider,
    required this.channelProvider,
  }) : super(key: key);

  final AuthenticationProvider authProvider;
  final ChannelProvider channelProvider;

  @override
  State<ChannelMembersChatBody> createState() => _ChannelMembersChatBodyState();
}

class _ChannelMembersChatBodyState extends State<ChannelMembersChatBody> {
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('channels')
        .doc(widget.channelProvider.selectedChannel.channelId)
        .collection("members")
        .doc(widget.authProvider.userInfo.userID)
        .update({'isOnline': true});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const NavScreensHeader(),
          SizedBox(height: AppSize.s52.h),
          CustomTextWithLineHeight(
            text: AppStrings.userName,
            textColor: ColorManager.textColor,
          ),
          SizedBox(height: AppSize.s38.h),
          SizedBox(
              width: AppSize.s250.w,
              height: AppSize.s250.w,
              child: GestureDetector(
                  onTapDown: (_) async => widget.channelProvider.recordSound(),
                  onTapUp: (_) async {
                    widget.channelProvider.stopRecord().then((value) async {
                      await widget.channelProvider.sendSound(
                          user: widget.authProvider.userInfo.userName);
                    });
                  },
                  child: widget.channelProvider.isRecording
                      ? Lottie.asset(AppImages.recordingAnimation)
                      : SvgPicture.asset(AppImages.tapToTalk))),
          SizedBox(height: AppSize.s40.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSize.s33),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(AppImages.speaker),
                InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ChatDisplayView()));
                    },
                    child: SvgPicture.asset(AppImages.option)),
              ],
            ),
          ),
          SizedBox(height: AppSize.s15.h),
          Expanded(
              child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('channels')
                  .doc(widget.channelProvider.selectedChannel.channelId)
                  .collection("members")
                  .where("isOnline", isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return Column(
                    children: [
                      SizedBox(
                          child: Container(
                        height: AppSize.s52.h,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(AppImages.dashboardStats),
                              fit: BoxFit.cover),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: AppSize.s18.w),
                              child: CustomTextWithLineHeight(
                                text:
                                    "Channel: ${widget.channelProvider.selectedChannel.channelName} | ${snapshot.data?.docs.length} Member${snapshot.data?.docs.length == 1 ? "" : "s"} ",
                                textColor:
                                    const Color.fromRGBO(248, 201, 158, 1),
                                fontSize: FontSize.s16,
                                fontWeight: FontWeightManager.semiBold,
                              ),
                            ),
                          ],
                        ),
                      )),
                      Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            widget.channelProvider.isRecording
                                ? FirebaseFirestore.instance
                                    .collection('channels')
                                    .doc(widget.channelProvider.selectedChannel
                                        .channelId)
                                    .collection("members")
                                    .doc(widget.authProvider.userInfo.userID)
                                    .update({'isPushed': true})
                                : FirebaseFirestore.instance
                                    .collection('channels')
                                    .doc(widget.channelProvider.selectedChannel
                                        .channelId)
                                    .collection("members")
                                    .doc(widget.authProvider.userInfo.userID)
                                    .update({'isPushed': false});

                            return snapshot.data?.docs[index]["isOnline"] ==
                                    true
                                ? Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: AppSize.s2.h),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: AppSize.s24.w),
                                      width: double.infinity,
                                      height: AppSize.s42.h,
                                      decoration: const BoxDecoration(
                                        color:
                                            Color.fromRGBO(255, 213, 79, 0.2),
                                      ),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                              AppImages.memberIcon),
                                          SizedBox(width: AppSize.s16.w),
                                          Expanded(
                                            child: CustomText(
                                              text: snapshot.data?.docs[index]
                                                  ["userFullName"],
                                              textColor: const Color.fromRGBO(
                                                  238, 233, 219, 1),
                                              fontSize: 16,
                                            ),
                                          ),
                                          snapshot.data?.docs[index]
                                                      ["isPushed"] ==
                                                  true
                                              ? SvgPicture.asset(
                                                  AppImages.memberSpeaking)
                                              : const SizedBox(),
                                        ],
                                      ),
                                    ),
                                  )
                                : const SizedBox();
                            // return buildItem( context, snapshot.data?.docs[index]);
                          },
                        ),
                      )
                    ],
                  );
                } else {
                  return Container();
                }
              },
            ),
          ))
        ],
      ),
    );
  }

  @override
  void dispose() {
    FirebaseFirestore.instance
        .collection('channels')
        .doc(widget.channelProvider.selectedChannel.channelId)
        .collection("members")
        .doc(widget.authProvider.userInfo.userID)
        .update({'isOnline': false});
    super.dispose();
  }
}
