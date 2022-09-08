import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encryptor/encryptor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:walkie_talkie_360/provider/authentication_provider.dart';
import 'package:walkie_talkie_360/provider/channel_provider.dart';
import 'package:walkie_talkie_360/resources/font_manager.dart';
import 'package:walkie_talkie_360/views/chat_display_view.dart';
import 'package:walkie_talkie_360/views/nav_screen/chats/chat_view.dart';

import '../../resources/color_manager.dart';
import '../../resources/constanst.dart';
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

  // // sendMsg() {
  // //   setState(() {
  // //     isSending = true;
  // //   });
  // //   String msg = _tec.text.trim();
  // //   print('here');
  // //   if (msg.isNotEmpty) {
  // //     var ref = FirebaseFirestore.instance
  // //         .collection('messages')
  // //         .doc(chatRoomID)
  // //         .collection(chatRoomID)
  // //         .doc(DateTime.now().millisecondsSinceEpoch.toString());
  // //     FirebaseFirestore.instance.runTransaction((transaction) async {
  // //       await transaction.set(ref, {
  // //         "senderId": userID,
  // //         "anotherUserId": widget.docs['id'],
  // //         "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
  // //         "content": msg,
  // //         "type": 'text'
  // //       });
  // //     });
  // //     scrollController.animateTo(0.0,
  // //         duration: Duration(milliseconds: 500), curve: Curves.bounceInOut);
  // //     setState(() {
  // //       isSending = false;
  // //     });
  // //   } else {
  // //     print("Hello");
  // //   }
  // // }
  //
  // sendAudioMsg(String audioMsg, ChannelProvider channelProvider) async {
  //   if (audioMsg.isNotEmpty) {
  //     var ref = FirebaseFirestore.instance
  //         .collection('channels')
  //         .doc(channelProvider.selectedChannel.channelId).collection("chats")
  //         .doc(DateTime.now().millisecondsSinceEpoch.toString());
  //     await FirebaseFirestore.instance.runTransaction((transaction) async {
  //       await transaction.set(ref, {
  //         "senderId": FirebaseAuth.instance.currentUser!.uid,
  //         "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
  //         "content": audioMsg,
  //         "type": 'audio'
  //       });
  //     }).then((value) {
  //       setState(() {
  //         isSending = false;
  //       });
  //     });
  //     scrollController.animateTo(0.0,
  //         duration: Duration(milliseconds: 100), curve: Curves.bounceInOut);
  //   } else {
  //     print("Hello");
  //   }
  // }
  //
  // Future _loadFile(String url) async {
  //   final bytes = await readBytes(Uri.parse(url));
  //   final dir = await getApplicationDocumentsDirectory();
  //   final file = File('${dir.path}/audio.mp3');
  //
  //   await file.writeAsBytes(bytes);
  //   if (await file.exists()) {
  //     setState(() {
  //       recordFilePath = file.path;
  //       isPlayingMsg = true;
  //       print(isPlayingMsg);
  //     });
  //     await play();
  //     setState(() {
  //       isPlayingMsg = false;
  //       print(isPlayingMsg);
  //     });
  //   }
  // }
  // int i = 0;
  //
  // Future<String> getFilePath() async {
  //   Directory storageDirectory = await getApplicationDocumentsDirectory();
  //   String sdPath = storageDirectory.path + "/record";
  //   var d = Directory(sdPath);
  //   if (!d.existsSync()) {
  //     d.createSync(recursive: true);
  //   }
  //   return sdPath + "/test_${i++}.mp3";
  // }
  //
  //
  //
  // uploadAudio() async{
  //   UploadTask? uploadTask;
  //   final  firebaseStorageRef = FirebaseStorage.instance
  //       .ref()
  //       .child(
  //       'profilepics/audio${DateTime.now().millisecondsSinceEpoch.toString()}}.jpg');
  //
  //   UploadTask task = firebaseStorageRef.putFile(File(recordFilePath));
  //   final snapshot =  await uploadTask?.whenComplete(() => null);
  //   task.whenComplete(() => null).then((value) async {
  //     print('##############done#########');
  //     var audioURL = await value.ref.getDownloadURL();
  //     String strVal = audioURL.toString();
  //     await sendAudioMsg(strVal);
  //   }).catchError((e) {
  //     print(e);
  //   });
  // }

  @override
  void initState() {
    super.initState();
  }

  // StreamBuilder(
  // stream: FirebaseFirestore.instance
  //     .collection('channelRoom')
  //     .doc(
  // channelProvider.selectedChannel.channelId)
  //     .collection('chats')
  //     .orderBy('timeStamp')
  //     .limitToLast(1)
  //     .snapshots(),
  // builder: (BuildContext context,
  //     AsyncSnapshot<dynamic> snapshot) {
  // if (snapshot.hasError) {
  // return const Text('Something went wrong');
  // }
  //
  // if (snapshot.connectionState ==
  // ConnectionState.waiting) {
  // return const Text("Loading");
  // }
  // snapshot.data!.docs
  //     .map((DocumentSnapshot document) {
  // if (document.exists) {
  // Map<String, dynamic> data =
  // document.data() as Map<String, dynamic>;
  //
  // play() async {
  // final player = AudioPlayer();
  // await player.play(data['record']);
  // }
  //
  // print('This is the new link ${data['record']}');
  //
  // play(); //Calling the player
  // }
  // }).toList();
  // return const SizedBox();
  // });
  //

  @override
  Widget build(BuildContext context) {
    final channelProvider = context.watch<ChannelProvider>();
    final authProvider = context.watch<AuthenticationProvider>();

    return Scaffold(
        backgroundColor: ColorManager.bgColor,
        body: Stack(children: [
          AudioStreaming(
              channelProvider: channelProvider,
              authenticationProvider: authProvider),
          ChannelMembersChatBody(
              channelProvider: channelProvider, authProvider: authProvider)
        ]));
  }
}

class AudioStreaming extends StatefulWidget {
  const AudioStreaming(
      {Key? key,
      required this.channelProvider,
      required this.authenticationProvider})
      : super(key: key);

  final ChannelProvider channelProvider;
  final AuthenticationProvider authenticationProvider;
  @override
  State<AudioStreaming> createState() => _AudioStreamingState();
}

class _AudioStreamingState extends State<AudioStreaming> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _recordingStream = FirebaseFirestore.instance
        .collection('channelRoom')
        .doc(widget.channelProvider.selectedChannel.channelId)
        .collection('chats')
        .orderBy('timeStamp', descending: false)
        .limitToLast(1)
        .snapshots();

    return widget.channelProvider.isRecording
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

              snapshot.data!.docs.map((DocumentSnapshot document) {
                if (document.exists) {
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  play() async {
                    final player = AudioPlayer();
                    final decryptedLink = widget.channelProvider.decryptData(
                        encryptedData: data['record'],
                        encryptionKey:
                            widget.authenticationProvider.userInfo.userID);
                    await player.play(decryptedLink);
                  }
                  play(); //Calling the player
                }
              }).toList();

              return const SizedBox();
            });
  }
}

class ChannelMembersChatBody extends StatelessWidget {
  const ChannelMembersChatBody({
    Key? key,
    required this.channelProvider,
    required this.authProvider,
  }) : super(key: key);

  final ChannelProvider channelProvider;
  final AuthenticationProvider authProvider;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // SizedBox(height: AppSize.s20.h,),
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
                  onTapDown: (_) async => channelProvider.recordSound(),
                  onTapUp: (_) async {
                    channelProvider.stopRecord().then((value) {
                      channelProvider.sendSound(
                          user: authProvider.userInfo.userName);
                      // channelProvider.uploadSound(
                      //     user: authProvider.userInfo.userName);
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

          SizedBox(
            height: AppSize.s15.h,
          ),

          Container(
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
                  padding: EdgeInsets.symmetric(horizontal: AppSize.s18.w),
                  child: CustomTextWithLineHeight(
                    text:
                        "Channel: ${channelProvider.selectedChannel.channelName} | ${channelProvider.channelMembers.length} Member(s)",
                    textColor: const Color.fromRGBO(248, 201, 158, 1),
                    fontSize: FontSize.s16,
                    fontWeight: FontWeightManager.semiBold,
                  ),
                ),
              ],
            ),
          ),

          // Expanded(child: ListView.builder(
          //   itemCount: channelProvider.channelMembers.length,
          //     itemBuilder: (context, index){
          //     final member = channelProvider.channelMembers[index];
          //       return Padding(
          //         padding: EdgeInsets.symmetric(vertical: AppSize.s2.h),
          //         child: Container(
          //           padding: EdgeInsets.symmetric(horizontal: AppSize.s24.w),
          //           width: double.infinity,
          //           height: AppSize.s42.h,
          //           decoration: const BoxDecoration(
          //             color: Color.fromRGBO(255, 213, 79, 0.2),
          //           ),
          //           child: Row(
          //             children: [
          //               SvgPicture.asset(AppImages.memberIcon),
          //               SizedBox(width: AppSize.s16.w,),
          //               Expanded(
          //                 child: CustomText(text: member.userFullName,
          //                   textColor: const Color.fromRGBO(238, 233, 219, 1),
          //                   fontSize: 16,
          //                 ),
          //               ),
          //
          //               SvgPicture.asset(AppImages.memberSpeaking),
          //
          //             ],
          //           ),
          //         ),
          //       );
          //     })),

          Expanded(
              child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('channels')
                  .doc(channelProvider.selectedChannel.channelId)
                  .collection("members")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSize.s2.h),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: AppSize.s24.w),
                          width: double.infinity,
                          height: AppSize.s42.h,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(255, 213, 79, 0.2),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(AppImages.memberIcon),
                              SizedBox(
                                width: AppSize.s16.w,
                              ),
                              Expanded(
                                child: CustomText(
                                  text: snapshot.data?.docs[index]
                                      ["userFullName"],
                                  textColor:
                                      const Color.fromRGBO(238, 233, 219, 1),
                                  fontSize: 16,
                                ),
                              ),
                              SvgPicture.asset(AppImages.memberSpeaking),
                            ],
                          ),
                        ),
                      );
                      // return buildItem( context, snapshot.data?.docs[index]);
                    },
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
}
