import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:walkie_talkie_360/provider/authentication_provider.dart';
import 'package:walkie_talkie_360/views/create_brand_new_channel/models/user_channel_model.dart';
import '../../models/chat_model.dart';
import '../../resources/color_manager.dart';
import '../../resources/constanst.dart';
import '../../resources/font_manager.dart';
import '../../resources/image_manager.dart';
import '../../resources/value_manager.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/nav_screens_header.dart';

class MessageChat extends StatefulWidget {
  const MessageChat({Key? key}) : super(key: key);

  @override
  State<MessageChat> createState() => _MessageChatState();
}

class _MessageChatState extends State<MessageChat> {
  final channelNameController = TextEditingController();
  bool showBottomSheet = true;
  final chatController = TextEditingController();

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
    final message = messages[3];
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: ColorManager.bgColor,
        body: SafeArea(
            child: Column(
              children: [
                SizedBox(height: AppSize.s46.h),
                Container(
                  height: AppSize.s54.h,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChatNavScreen(
                        menuTitle: 'clement bako',
                        subtitle: '24 Sept. 2020',
                        withLeading: false,
                        menuIconPath: AppImages.messageIcon,
                        drawerAction: () {
                          _scaffoldKey.currentState?.openEndDrawer();
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          height: AppSize.s22.h,
                        ),
                        Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: AppSize.s24.w),
                              child: ListView.builder(
                                  itemCount: message.messages.length,
                                  itemBuilder: (context, index) {
                                    final chat = message.messages[index];
                                    return Padding(
                                        padding: EdgeInsets.only(bottom: AppSize.s16.h),
                                        child: !chat.isSender
                                            ? Padding(
                                          padding: const EdgeInsets.only(
                                              right: AppSize.s120),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  child: CustomTextWithLineHeight(
                                                    fontWeight: FontWeight.w400,
                                                    isCenterAligned: false,
                                                    textColor: ColorManager.primaryColor,
                                                    text: chat.senderName,
                                                  )),
                                              Container(
                                                constraints: BoxConstraints(
                                                    minWidth: AppSize.s186.w,
                                                    maxWidth:
                                                    MediaQuery.of(context).size.width *
                                                        0.6),
                                                padding: EdgeInsets.all(AppSize.s16.r),
                                                decoration: BoxDecoration(
                                                    color: ColorManager.primaryColor,
                                                    borderRadius: BorderRadius.only(
                                                      topRight:
                                                      Radius.circular(AppSize.s16.r),
                                                      bottomRight:
                                                      Radius.circular(AppSize.s16.r),
                                                      bottomLeft:
                                                      Radius.circular(AppSize.s16.r),
                                                    )),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                        child: CustomTextWithLineHeight(
                                                          textColor: ColorManager.blackTextColor,
                                                          isCenterAligned: false,
                                                          text: chat.message,
                                                        )),
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(
                                                          vertical: AppSize.s8.h),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                        children: [
                                                          CustomText(
                                                            text: chat.time,
                                                            textColor:
                                                            ColorManager.blackTextColor,
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                            : Padding(
                                          padding: const EdgeInsets.only(
                                              left: AppSize.s120),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                  child: CustomTextWithLineHeight(
                                                    fontWeight: FontWeight.w400,
                                                    isCenterAligned: false,
                                                    textColor: ColorManager.primaryColor,
                                                    text: "Me",
                                                  )),
                                              Container(
                                                constraints: BoxConstraints(
                                                    minWidth: AppSize.s186.w,
                                                    maxWidth:
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                        0.6),
                                                padding: EdgeInsets.all(
                                                    AppSize.s16.r),
                                                decoration: BoxDecoration(
                                                    color: ColorManager
                                                        .primaryColor,
                                                    borderRadius:
                                                    BorderRadius.only(
                                                      topLeft: Radius.circular(
                                                          AppSize.s16.r),
                                                      bottomRight:
                                                      Radius.circular(
                                                          AppSize.s16.r),
                                                      bottomLeft:
                                                      Radius.circular(
                                                          AppSize.s16.r),
                                                    )),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                        child: CustomTextWithLineHeight(
                                                          isCenterAligned: false,
                                                          textColor: ColorManager.blackTextColor,
                                                          text: chat.message,
                                                        )),
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(
                                                          vertical: AppSize.s8.h),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                        children: [
                                                          CustomText(
                                                            text: chat.time,
                                                            textColor:
                                                            ColorManager.blackTextColor,
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )

                                    );
                                  }),
                            )),
                      ],
                    ))
              ],
            )),
        bottomSheet: showBottomSheet
            ? BottomSheet(
            elevation: 0,
            onClosing: () {
              // Do something
            },
            builder: (BuildContext ctx) => Container(
                width: double.infinity,
                height: AppSize.s80.h,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(
                    horizontal: AppSize.s24.w, vertical: AppSize.s8.h),
                child: Padding(
                  padding: EdgeInsets.only(bottom: AppSize.s18.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: chatController,
                          autovalidateMode:
                          AutovalidateMode.onUserInteraction,
                          cursorColor: ColorManager.bgColor,
                          autofocus: true,
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              color: ColorManager.bgColor,
                              fontSize: FontSize.s16),
                          onChanged: (value) async {},
                          decoration: InputDecoration(
                            filled: true,
                            counterText: "",
                            fillColor: ColorManager.whiteColor,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: AppSize.s20.w,
                                vertical: AppSize.s15.h),
                            hintText: "Type a message",
                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(AppSize.s12.r),
                              borderSide: BorderSide(
                                  color: ColorManager.bgColor, width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(AppSize.s12.r),
                              borderSide: BorderSide(
                                  color: ColorManager.bgColor, width: 1),
                            ),

                            focusedBorder: OutlineInputBorder(
                              gapPadding: 0.0,
                              borderRadius:
                              BorderRadius.circular(AppSize.s12.r),
                              borderSide: BorderSide(
                                  color: ColorManager.bgColor, width: 1),
                            ),
                            hintStyle:
                            const TextStyle(fontSize: FontSize.s16),
                            labelStyle:
                            const TextStyle(fontSize: FontSize.s16),
                            errorStyle: TextStyle(
                                color: ColorManager.redColor,
                                fontSize: FontSize.s16),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: AppSize.s16.w,
                      ),
                      SvgPicture.asset(
                          "assets/images/icon/send_chat_button.svg")
                    ],
                  ),
                )))
            : null);
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
