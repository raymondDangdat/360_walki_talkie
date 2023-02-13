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
import 'package:walkie_talkie_360/widgets/customDrawer.dart';
import 'package:walkie_talkie_360/widgets/reusable_widget.dart';
import '../../resources/color_manager.dart';
import '../../resources/constanst.dart';
import '../../resources/font_manager.dart';
import '../../resources/image_manager.dart';
import '../../resources/navigation_utils.dart';
import '../../resources/strings_manager.dart';
import '../../resources/value_manager.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/nav_screens_header.dart';

class MangeMembers extends StatefulWidget {
  const MangeMembers({Key? key}) : super(key: key);

  @override
  State<MangeMembers> createState() => _MangeMembersState();
}

class _MangeMembersState extends State<MangeMembers> {
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: customDrawer(context: context, fromSecondMenu: false),
      backgroundColor: ColorManager.bgColor,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: AppSize.s46.h,
            ),
            Container(
              height: AppSize.s54.h,
              decoration: BoxDecoration(color: ColorManager.textColor),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NavScreensHeader(
                    onTapDrawer: () {
                      _scaffoldKey.currentState?.openEndDrawer();
                    },
                  )
                ],
              ),
            ),
            SizedBox(
              height: AppSize.s21.h,
            ),
            Image.asset(AppImages.three60Circle),
            SizedBox(
              height: AppSize.s19.h,
            ),
            CustomTextWithLineHeight(
              text: AppStrings.addASubChannelByName,
              textColor: ColorManager.textColor,
            ),
            SizedBox(
              height: AppSize.s19.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSize.s73.w),
              child: Column(
                children: [
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.r),
                        color: ColorManager.textFilledColor,
                      ),
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: channelNameController,
                        cursorColor: ColorManager.textColor,
                        autofocus: false,
                        maxLines: 1,
                        onChanged: (String value) {
                          setState(() {
                            isSearching = true;
                            if (allChannels.isNotEmpty && value.isNotEmpty) {
                              searchList = allChannels
                                  .where((element) => element.channelName
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                                  .toList();
                              print("Length: ${searchList.length}");
                            } else {
                              searchList = [];
                            }
                          });

                          // searchUserName(context, value);
                        },
                        maxLength: 20,
                        style: TextStyle(
                            color: ColorManager.textColor,
                            fontSize: FontSize.s16),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: ColorManager.bgColor,
                            hintText: AppStrings.chooseChannelName,
                            labelText: AppStrings.chooseChannelName,
                            counterText: "",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.r),
                              borderSide: BorderSide(
                                  color: ColorManager.textColor, width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.r),
                              borderSide: BorderSide(
                                  color: ColorManager.textColor, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              gapPadding: 0.0,
                              borderRadius: BorderRadius.circular(5.r),
                              borderSide: BorderSide(
                                  color: ColorManager.textColor, width: 1),
                            ),
                            hintStyle: TextStyle(
                                color: ColorManager.textColor,
                                fontSize: FontSize.s16),
                            labelStyle: TextStyle(
                                color: ColorManager.textColor,
                                fontSize: FontSize.s16)),
                      )),
                  Container(
                    height: searchList.length * 35,
                    padding: EdgeInsets.symmetric(
                        horizontal: AppSize.s16.w, vertical: AppSize.s11.h),
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(106, 88, 40, 1),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(
                              AppSize.s20.r,
                            ),
                            bottomRight: Radius.circular(
                              AppSize.s20.r,
                            ))),
                    child: ListView.builder(
                        itemCount: searchList.length,
                        itemBuilder: (context, index) {
                          final channel = searchList[index];
                          return InkWell(
                            onTap: () {
                              setState(() {
                                channelNameController.text =
                                    channel.channelName;
                                channelNameFound = true;
                                channelId = channel.channelId;
                                channelName = channel.channelName;
                                final channelModel = UserChannelModel(
                                  userId: '',
                                  channelId: channel.channelId,
                                  channelName: channel.channelName,
                                  createdAt: channel.createdAt,
                                  isCreated: false,
                                  isBlocked: false,
                                  isApproved: false,
                                );
                                context
                                    .read<ChannelProvider>()
                                    .setSelectedChannel(channelModel);
                                searchList = [];
                              });
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: channel.channelName,
                                  textColor: ColorManager.primaryColor,
                                ),
                                if (index != searchList.length - 1)
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: AppSize.s7.h),
                                    child: SvgPicture.asset(
                                        AppImages.channelDivider),
                                  ),
                              ],
                            ),
                          );
                        }),
                  ),
                  SizedBox(
                    height: AppSize.s30.h,
                  ),
                  CustomTextWithLineHeight(
                    text: AppStrings.ifYouKnowTheSubChannelName,
                    textColor: ColorManager.textColor,
                  ),
                  SizedBox(
                    height: AppSize.s45.h,
                  ),
                ],
              ),
            ),
            Consumer<ChannelProvider>(builder: (ctx, channelProvider, child) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (channelProvider.resMessage != '') {
                  showTopSnackBar(
                    context,
                    CustomSnackBar.info(
                      message: channelProvider.resMessage,
                      backgroundColor: ColorManager.primaryColor,
                    ),
                  );

                  ///Clear the response message to avoid duplicate
                  channelProvider.clear();
                }
              });
              return WalkieButton(
                  height: AppSize.s51.h,
                  width: AppSize.s290.w,
                  context: context,
                  onTap: () async {
                    if (channelNameFound) {
                      openCompleteSubChannel(context);
                    } else {
                      showTopSnackBar(
                        context,
                        CustomSnackBar.info(
                          message: "No Channel found yet",
                          backgroundColor: ColorManager.primaryColor,
                        ),
                      );
                    }
                  },
                  title: AppStrings.chooseMainChannel);
            })
          ],
        ),
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
