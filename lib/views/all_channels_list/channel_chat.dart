import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:walkie_talkie_360/provider/authentication_provider.dart';
import 'package:walkie_talkie_360/views/create_brand_new_channel/models/user_channel_model.dart';
import '../../models/chat_model.dart';
import '../../provider/channel_provider.dart';
import '../../resources/color_manager.dart';
import '../../resources/constanst.dart';
import '../../resources/font_manager.dart';
import '../../resources/image_manager.dart';
import '../../resources/strings_manager.dart';
import '../../resources/value_manager.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/nav_screens_header.dart';

class ChannelChat extends StatefulWidget {
  const ChannelChat({Key? key}) : super(key: key);

  @override
  State<ChannelChat> createState() => _ChannelChatState();
}

class _ChannelChatState extends State<ChannelChat> {
  late ScrollController _scrollController;
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

  getChannels() async {
    return await FirebaseFirestore.instance.collection("channelNames").get();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final auth = Provider.of<AuthenticationProvider>(context, listen: false);
      allChannels.addAll(auth.userChannelsConnected);
      allChannels.addAll(auth.userChannelsCreated);
    });
    setState(() {});
    _scrollController = ScrollController();

  }



  void scrollToBottom() {
    final bottomOffset = _scrollController.position.maxScrollExtent;
    _scrollController.animateTo(
      bottomOffset,
      duration: Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final channelProvider = context.watch<ChannelProvider>();
    final authProvider = context.watch<AuthenticationProvider>();
    final selectedChannel = channelProvider.selectedChannel;

    final message = messages[3];

    Timestamp myTimeStamp = Timestamp.fromDate(DateTime.now());

    var dt = (selectedChannel.createdAt.toDate() ?? myTimeStamp);

    DateTime tempDate =
        new DateFormat("yyyy-MM-dd hh:mm:ss").parse(dt.toString());
    String formattedDate = DateFormat('dd MMM, yyyy').format(tempDate);

    String initialString = '';

    if (selectedChannel.channelName.length > 0) {
      initialString = selectedChannel.channelName[0];
    }

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: ColorManager.bgColor,
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('channels')
              .doc(channelProvider.selectedChannel.channelId)
              .collection("chats")
              .orderBy('createdAt', descending: false)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData && snapshot.data.docs != null) {
              return SafeArea(
                child: Column(
                  children: [
                    Container(
                      height: AppSize.s54.h,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ChatNavScreen(
                            initialString: initialString,
                            menuTitle:
                                '${channelProvider.selectedChannel.channelName}',
                            subtitle: 'created on $formattedDate',
                            withLeading: true,
                            submenuIcon: AppImages.channelIconPeople,
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
                          height: AppSize.s5.h,
                        ),
                        Expanded(
                            child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: AppSize.s24.w),
                          child: ListView.builder(
                              controller: _scrollController,
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                final chat = snapshot.data.docs[index];

                                Timestamp myTimeStamp =
                                    Timestamp.fromDate(DateTime.now());

                                var dt =
                                    (chat['createdAt'].toDate() ?? myTimeStamp);

                                DateTime tempDate =
                                    new DateFormat("yyyy-MM-dd hh:mm:ss")
                                        .parse(dt.toString());

                                String formattedDate =
                                    DateFormat.jm().format(tempDate);

                                return Padding(
                                    padding:
                                        EdgeInsets.only(bottom: index ==  snapshot.data.docs.length - 1 ? AppSize.s90.h : AppSize.s15.h),
                                    child: chat['userId'] ==
                                            authProvider.userInfo.userID
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                left: AppSize.s120),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Container(
                                                    child:
                                                        CustomTextWithLineHeight(
                                                  fontWeight: FontWeight.w400,
                                                  isCenterAligned: false,
                                                  textColor:
                                                      ColorManager.primaryColor,
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
                                                        topLeft:
                                                            Radius.circular(
                                                                AppSize.s16.r),
                                                        bottomRight:
                                                            Radius.circular(
                                                                AppSize.s16.r),
                                                        bottomLeft:
                                                            Radius.circular(
                                                                AppSize.s16.r),
                                                      )),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                          child:
                                                              CustomTextWithLineHeight(
                                                        isCenterAligned: false,
                                                        textColor: ColorManager
                                                            .blackTextColor,
                                                        text: chat['message'],
                                                      )),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical:
                                                                    AppSize
                                                                        .s8.h),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            CustomText(
                                                              text:
                                                                  formattedDate,
                                                              textColor:
                                                                  ColorManager
                                                                      .blackTextColor,
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
                                                right: AppSize.s120),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                    child:
                                                        CustomTextWithLineHeight(
                                                  fontWeight: FontWeight.w400,
                                                  isCenterAligned: false,
                                                  textColor:
                                                      ColorManager.primaryColor,
                                                  text: chat['userName'],
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
                                                        topRight:
                                                            Radius.circular(
                                                                AppSize.s16.r),
                                                        bottomRight:
                                                            Radius.circular(
                                                                AppSize.s16.r),
                                                        bottomLeft:
                                                            Radius.circular(
                                                                AppSize.s16.r),
                                                      )),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                          child:
                                                              CustomTextWithLineHeight(
                                                        textColor: ColorManager
                                                            .blackTextColor,
                                                        isCenterAligned: false,
                                                        text: chat['message'],
                                                      )),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical:
                                                                    AppSize
                                                                        .s8.h),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            CustomText(
                                                              text:
                                                                  formattedDate,
                                                              textColor:
                                                                  ColorManager
                                                                      .blackTextColor,
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ));
                              }),
                        )),
                      ],
                    )),

                  ],
                ),
              );
            }
            return SizedBox();
          },
        ),
        bottomSheet: showBottomSheet
            ? BottomSheet(
                elevation: 0,
                onClosing: () {
                  // Do something
                },

                builder: (BuildContext ctx) => Container(
                      width: double.infinity,
                      height: AppSize.s65.h,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                          horizontal: AppSize.s8.w, vertical: AppSize.s8.h),
                      child: Column(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: chatController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              cursorColor: ColorManager.bgColor,
                              autofocus: true,
                              maxLines: null,
                              minLines: null,
                              expands: true,
                              scrollPadding: EdgeInsets.zero,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                  color: ColorManager.bgColor,
                                  fontSize: FontSize.s16),

                              onChanged: (value) async {

                              },

                              onTap: (){
                               scrollToBottom();
                              },

                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () {
                                    if (chatController.text.isNotEmpty) {
                                      channelProvider
                                          .sendChannelChat(
                                          authProvider.userInfo.userName,
                                          chatController.text)
                                          .then((value) {
                                        scrollToBottom();
                                        chatController.clear();
                                      });
                                    }
                                    },
                                    icon: Icon(Icons.send)),
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
                        ],
                      ),
                    ))
            : null);
  }
}
