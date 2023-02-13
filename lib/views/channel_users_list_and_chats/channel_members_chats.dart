import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:walkie_talkie_360/provider/authentication_provider.dart';
import 'package:walkie_talkie_360/provider/channel_provider.dart';
import 'package:walkie_talkie_360/resources/font_manager.dart';
import 'package:walkie_talkie_360/widgets/new_user_prompt.dart';
import '../../models/chat_records_model.dart';
import '../../resources/color_manager.dart';
import '../../resources/image_manager.dart';
import '../../resources/strings_manager.dart';
import '../../resources/value_manager.dart';
import '../../widgets/customDrawer.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/loading.dart';
import '../../widgets/nav_screens_header.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import '../../widgets/qrCode_bottomsheet.dart';

const theSource = AudioSource.microphone;

class ChannelMembersChats extends StatefulWidget {
  const ChannelMembersChats({Key? key}) : super(key: key);

  @override
  State<ChannelMembersChats> createState() => _ChannelMembersChatsState();
}

class _ChannelMembersChatsState extends State<ChannelMembersChats>
    with WidgetsBindingObserver {
  bool isPlayingMsg = false, isRecording = false, isSending = false;
  String recordFilePath = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        //Execute the code here when user come back the app.
        FirebaseFirestore.instance
            .collection('channels')
            .doc(Provider.of<ChannelProvider>(context, listen: false)
                .selectedChannel
                .channelId)
            .collection("members")
            .doc(Provider.of<AuthenticationProvider>(context, listen: false)
                .userInfo
                .userID)
            .update({'isOnline': true});
        break;
      case AppLifecycleState.paused:
        //Execute the code the when user leave the app
        FirebaseFirestore.instance
            .collection('channels')
            .doc(Provider.of<ChannelProvider>(context, listen: false)
                .selectedChannel
                .channelId)
            .collection("members")
            .doc(Provider.of<AuthenticationProvider>(context, listen: false)
                .userInfo
                .userID)
            .update({'isOnline': false});
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthenticationProvider>();
    final channelProvider = context.watch<ChannelProvider>();
    return Scaffold(
        backgroundColor: ColorManager.bgColor,
        body: Stack(children: [
          const AudioStreaming(),
          ChannelMembersChatBody(
            channelProvider: channelProvider,
            authProvider: authProvider,
          )
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

              if (records.isEmpty) {
                print("Records is empty for now");
              } else {
                final records = snapshot.data!.docs.map((doc) {
                  return ChatRecordsModel.fromSnapshot(doc);
                }).toList();
                records.sort((a, b) {
                  int aDate = a.timeStamp.microsecondsSinceEpoch;
                  int bDate = b.timeStamp.microsecondsSinceEpoch;
                  return aDate.compareTo(bDate);
                });

                playAudio() async {
                  final player = AudioPlayer();
                  await player
                      .play(UrlSource(records[records.length - 1].record));
                  channelProvider.deleteChannelPlayedSound(
                      currentDocId: records[records.length - 1].id);
                }

                playAudio();

                // channelProvider
                //     .downloadEncryptedFile(
                //         url: records[records.length - 1].record)
                //     .then((value) {
                //   channelProvider
                //       .decryptFile(encryptedFile: value.file.path)
                //       .then((result) async {
                //     final player = AudioPlayer();
                //     await player.play(UrlSource(result));
                //     channelProvider.deleteChannelPlayedSound(
                //         currentDocId: records[records.length - 1].id);
                //   });
                // });

              }
              return const SizedBox();
            });
  }
}

class ChannelMembersChatBody extends StatefulWidget {
  final ChannelProvider channelProvider;
  final AuthenticationProvider authProvider;
  const ChannelMembersChatBody({
    Key? key,
    required this.channelProvider,
    required this.authProvider,
  }) : super(key: key);

  // final AuthenticationProvider authProvider;
  // final ChannelProvider channelProvider;

  @override
  State<ChannelMembersChatBody> createState() => _ChannelMembersChatBodyState();
}

class _ChannelMembersChatBodyState extends State<ChannelMembersChatBody> {
  String currentSpeaker = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final channelProvider =
          Provider.of<ChannelProvider>(context, listen: false);
      final authProvider =
          Provider.of<AuthenticationProvider>(context, listen: false);
      FirebaseFirestore.instance
          .collection('channels')
          .doc(channelProvider.selectedChannel.channelId)
          .collection("members")
          .doc(authProvider.userInfo.userID)
          .update({'isOnline': true});
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final channelProvider = context.watch<ChannelProvider>();
    final authProvider = context.watch<AuthenticationProvider>();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   provider.showPrompt == true ? buildNewUserDialog(context: context) : null;
    // });

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorManager.bgColor,
        key: _scaffoldKey,
        endDrawer: customDrawer(context: context, fromSecondMenu: true),
        body: Column(
          children: [
            NavScreensHeader(
              onTapDrawer: () {
                _scaffoldKey.currentState?.openEndDrawer();
              },
            ),
            SizedBox(height: AppSize.s52.h),

            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('channels')
                  .doc(channelProvider.selectedChannel.channelId)
                  .collection("members")
                  .where('isAdmin', isEqualTo: true)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData &&
                    snapshot.data.docs != null &&
                    snapshot.data.docs.isNotEmpty) {
                  if (snapshot.data.docs[0]['userId'] ==
                      authProvider.userInfo.userID) {
                    return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('channels')
                          .doc(channelProvider.selectedChannel.channelId)
                          .collection("waitingRoom")
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.hasData &&
                            snapshot.data.docs != null &&
                            snapshot.data.docs.isNotEmpty) {
                          buildNewUserDialog(
                              context: context,
                              userName: snapshot.data.docs[0]['userFullName'],
                              onAccept: () async {
                                print('accepted');

                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(authProvider.userInfo.userID)
                                    .collection('channels')
                                    .doc(channelProvider
                                        .selectedChannel.channelId)
                                    .update({'isApproved': true});

                                Navigator.pop(context);
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) =>
                                        const LoadingIndicator());

                                channelProvider
                                    .approveMemberToChannel(
                                        channelID: channelProvider
                                            .selectedChannel.channelId,
                                        channelName: channelProvider
                                            .selectedChannel.channelName,
                                        userId: snapshot.data.docs[0]['userId'],
                                        userName: snapshot.data.docs[0]
                                            ['username'],
                                        userFullName: snapshot.data.docs[0]
                                            ['userFullName'])
                                    .then((value) {
                                  Navigator.pop(context);
                                  return ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          backgroundColor:
                                              ColorManager.greenColor,
                                          content: CustomText(
                                            textColor: ColorManager.whiteColor,
                                            text: 'request accepted',
                                          )));
                                }).onError((error, stackTrace) {
                                  return ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          backgroundColor:
                                              ColorManager.redColor,
                                          content: CustomText(
                                            textColor: ColorManager.whiteColor,
                                            text:
                                                'Error Occurred ${error.toString()}',
                                          )));
                                });
                              },
                              onReject: () {
                                FirebaseFirestore.instance
                                    .collection('channels')
                                    .doc(channelProvider
                                        .selectedChannel.channelId)
                                    .collection("waitingRoom")
                                    .doc(snapshot.data.docs[0]['userId'])
                                    .delete()
                                    .then((value) {
                                  Navigator.pop(context);
                                  return ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          backgroundColor:
                                              ColorManager.greenColor,
                                          content: CustomText(
                                            textColor: ColorManager.whiteColor,
                                            text: 'request rejected',
                                          )));
                                }).onError((error, stackTrace) {
                                  Navigator.pop(context);
                                  return ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          backgroundColor:
                                              ColorManager.redColor,
                                          content: CustomText(
                                            textColor: ColorManager.whiteColor,
                                            text:
                                                'Error Occurred ${error.toString()}',
                                          )));
                                });
                              });
                        }
                        return CustomTextWithLineHeight(
                            text: "", textColor: ColorManager.textColor);
                      },
                    );
                  }
                }
                return CustomTextWithLineHeight(
                    text: "", textColor: ColorManager.textColor);
              },
            ),

            //Check for new members that are pending
            // StreamBuilder(
            //   stream: FirebaseFirestore.instance
            //       .collection('channels')
            //       .doc(channelProvider.selectedChannel.channelId)
            //       .collection("members")
            //       .where("isMember", isEqualTo: false)
            //       .snapshots(),
            //   builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            //     if (snapshot.hasData &&
            //         snapshot.data.docs != null &&
            //         snapshot.data.docs.isNotEmpty) {
            //       buildNewUserDialog(
            //           context: context,
            //           userName: snapshot.data.docs[0]['userFullName'],
            //           onAccept: () {
            //             showDialog(
            //                 barrierDismissible: false,
            //                 context: context,
            //                 builder: (BuildContext context) => const LoadingIndicator());
            //             Navigator.pop(context);
            //             FirebaseFirestore.instance
            //                 .collection('channels')
            //                 .doc(widget
            //                     .channelProvider.selectedChannel.channelId)
            //                 .collection("members")
            //                 .doc(snapshot.data.docs[0]['userId'])
            //                 .update({'isMember': true}).then((value) {
            //               Navigator.pop(context);
            //               return ScaffoldMessenger.of(context)
            //                   .showSnackBar(SnackBar(
            //                       backgroundColor: ColorManager.greenColor,
            //                       content: CustomText(
            //                         textColor: ColorManager.whiteColor,
            //                         text: 'User Added Successfully',
            //                       )));
            //             }).onError((error, stackTrace) {
            //               return ScaffoldMessenger.of(context)
            //                   .showSnackBar(SnackBar(
            //                       backgroundColor: ColorManager.redColor,
            //                       content: CustomText(
            //                         textColor: ColorManager.whiteColor,
            //                         text: 'Error Occurred ${error.toString()}',
            //                       )));
            //             });
            //           },
            //           onReject: () {
            //             FirebaseFirestore.instance
            //                 .collection('channels')
            //                 .doc(widget
            //                 .channelProvider.selectedChannel.channelId)
            //                 .collection("members")
            //                 .doc(snapshot.data.docs[0]['userId'])
            //                 .delete().then((value) {
            //               Navigator.pop(context);
            //               return ScaffoldMessenger.of(context)
            //                   .showSnackBar(SnackBar(
            //                   backgroundColor: ColorManager.greenColor,
            //                   content: CustomText(
            //                     textColor: ColorManager.whiteColor,
            //                     text: 'request rejected',
            //                   )));
            //             }).onError((error, stackTrace) {
            //               return ScaffoldMessenger.of(context)
            //                   .showSnackBar(SnackBar(
            //                   backgroundColor: ColorManager.redColor,
            //                   content: CustomText(
            //                     textColor: ColorManager.whiteColor,
            //                     text: 'Error Occurred ${error.toString()}',
            //                   )));
            //             });
            //           });
            //     }
            //     return CustomTextWithLineHeight(
            //         text: "", textColor: ColorManager.textColor);
            //   },
            // ),

//stream the data for who is currently talking
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('channels')
                  .doc(channelProvider.selectedChannel.channelId)
                  .collection("members")
                  .where("isPushed", isEqualTo: true)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData &&
                    snapshot.data.docs != null &&
                    snapshot.data.docs.isNotEmpty) {
                  return CustomTextWithLineHeight(
                      text: snapshot.data.docs[0]['userFullName'] ==
                              authProvider.userInfo.fullName
                          ? AppStrings.youAreTalking
                          : "${snapshot.data.docs[0]['userFullName']} is talking...",
                      textColor: ColorManager.textColor);
                }
                return CustomTextWithLineHeight(
                    text: "", textColor: ColorManager.textColor);
              },
            ),
            SizedBox(height: AppSize.s38.h),
            SizedBox(
                width: AppSize.s250.w,
                height: AppSize.s250.w,
                child: GestureDetector(
                    onTapDown: (_) async {
                      return channelProvider.recordSound();
                    },
                    onTapUp: (_) async {
                      channelProvider.stopRecord().then((value) async {
                        await channelProvider.sendSound(
                            user: authProvider.userInfo.userName);
                      });
                    },
                    child: channelProvider.isRecording
                        ? Lottie.asset(AppImages.recordingAnimation)
                        : SvgPicture.asset(AppImages.tapToTalk))),
            SizedBox(height: AppSize.s40.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSize.s33),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () {
                        VolumeController().getVolume();
                      },
                      child: SvgPicture.asset(AppImages.speaker)),
                  InkWell(
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => const ChatDisplayView()));
                        customQrCodeBottomSheet(
                            context: context,
                            channelId:
                                '${channelProvider.selectedChannel.channelId}',
                            channelTitle:
                                '${channelProvider.selectedChannel.channelName}');
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  width: 2, color: ColorManager.primaryColor)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset(
                              AppImages.qrcode,
                              color: ColorManager.primaryColor,
                            ),
                          ))),
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
                    .doc(channelProvider.selectedChannel.channelId)
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
                                      "Channel: ${channelProvider.selectedChannel.channelName} | ${snapshot.data?.docs.length} Member${snapshot.data?.docs.length == 1 ? "" : "s"} ",
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
                              print(authProvider.userInfo.userID);
                              channelProvider.isRecording
                                  ? FirebaseFirestore.instance
                                      .collection('channels')
                                      .doc(channelProvider
                                          .selectedChannel.channelId)
                                      .collection("members")
                                      .doc(authProvider.userInfo.userID)
                                      .update({'isPushed': true})
                                  : FirebaseFirestore.instance
                                      .collection('channels')
                                      .doc(channelProvider
                                          .selectedChannel.channelId)
                                      .collection("members")
                                      .doc(authProvider.userInfo.userID)
                                      .update({'isPushed': false});

                              if (snapshot.data?.docs[index]["isOnline"] ==
                                  true) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: AppSize.s2.h),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: AppSize.s24.w),
                                    width: double.infinity,
                                    height: AppSize.s42.h,
                                    decoration: const BoxDecoration(
                                      color: Color.fromRGBO(255, 213, 79, 0.2),
                                    ),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(AppImages.memberIcon),
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
                                        if (snapshot.data?.docs[index]
                                                ["isPushed"] ==
                                            true)
                                          SvgPicture.asset(
                                              AppImages.memberSpeaking)
                                        else
                                          const SizedBox(),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
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
