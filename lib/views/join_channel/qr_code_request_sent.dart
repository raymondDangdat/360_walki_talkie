import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:walkie_talkie_360/provider/authentication_provider.dart';
import 'package:walkie_talkie_360/provider/channel_provider.dart';
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

class QrCodeRequestSubmitted extends StatefulWidget {
  final Barcode result;
  const QrCodeRequestSubmitted({Key? key, required this.result})
      : super(key: key);

  @override
  State<QrCodeRequestSubmitted> createState() => _QrCodeRequestSubmittedState();
}

class _QrCodeRequestSubmittedState extends State<QrCodeRequestSubmitted> {
  final channelNameController = TextEditingController();

  bool channelNameFound = false;
  bool isSearching = false;

  List<SearchChannelModel> allChannels = [];
  List<SearchChannelModel> searchList = [];
  QuerySnapshot? channelSnapshot;

  void getAllChannels() async {
    await getChannels().then((value) {
      channelSnapshot = value;
      allChannels = channelSnapshot!.docs
          .map((doc) => SearchChannelModel.fromSnapshot(doc))
          .toList();
      print("Channels length: ${allChannels.length}");
      isSearching = false;
      setState(() {});
    });
  }

  getChannels() async {
    return await FirebaseFirestore.instance.collection("channelNames").get();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.

  @override
  void initState() {
    super.initState();
    getAllChannels();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final channelProvider =
          Provider.of<ChannelProvider>(context, listen: false);
      final authProvider =
          Provider.of<AuthenticationProvider>(context, listen: false);
      channelProvider.saveChannelInfoToUser(
          jsonDecode(widget.result.code!)['channelId'],
          jsonDecode(widget.result.code!)['title'],
          false);

      channelProvider.saveMemberInChannel(
          context,
          jsonDecode(widget.result.code!)['channelId'],
          jsonDecode(widget.result.code!)['title'],
          false,
          authProvider);
    });
  }

  ScreenshotController screenshotController = ScreenshotController();
  // sendRequest() {
  //   print('sendong');
  //   Consumer(
  //     builder: (BuildContext context, value, Widget? child) {
  //       final authProvider = context.watch<AuthenticationProvider>();
  //       final channelProvider = context.watch<ChannelProvider>();
  //
  //       channelProvider.saveChannelInfoToUser(
  //           jsonDecode(result.code!)['channelId'],
  //           jsonDecode(result.code!)['title'],
  //           false);
  //
  //       channelProvider.saveMemberInChannel(
  //           context,
  //           jsonDecode(result.code!)['channelId'],
  //           jsonDecode(result.code!)['title'],
  //           false,
  //           authProvider);
  //
  //       return SizedBox();
  //     },
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthenticationProvider>();
    final channelProvider = context.watch<ChannelProvider>();
    final decoded = jsonDecode(widget.result.code!);

    Future.delayed(Duration(seconds: 1), () {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        channelProvider.saveChannelInfoToUser(
            decoded['channelId'], decoded['title'], false);

        channelProvider.saveMemberInChannel(
            context,
            jsonDecode(widget.result.code!)['channelId'],
            jsonDecode(widget.result.code!)['title'],
            false,
            authProvider);
      });
    });

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ColorManager.bgColor,
      endDrawer: customDrawer(context: context, fromSecondMenu: false),
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
                  NewNavScreen(
                    withDrawer: false,
                    menuTitle: AppStrings.joinChannelViaQrCode,
                    drawerAction: () {
                      _scaffoldKey.currentState?.openEndDrawer();
                    },
                  )
                ],
              ),
            ),
            SizedBox(
              height: AppSize.s30.h,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p10),
              child: CustomTextWithLineHeight(
                fontSize: AppSize.s25,
                fontWeight: FontWeightManager.bold,
                text: AppStrings.requestSubmitted,
                textColor: ColorManager.textColor,
              ),
            ),
            SizedBox(
              height: AppSize.s40,
            ),
            SizedBox(
              child: Screenshot<Widget>(
                controller: screenshotController,
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      QrImage(
                        backgroundColor: ColorManager.whiteColor,
                        data: <String, dynamic>{
                          "channelId": decoded['channelId'],
                          "title": decoded['title'],
                        }.toString(),
                        version: QrVersions.auto,
                        size: 320,
                        gapless: false,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: AppSize.s40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p40),
              child: CustomTextNoOverFlow(
                fontSize: FontSize.s20,
                textColor: ColorManager.primaryColor,
                isCentered: true,
                text:
                    'Your request to join ${decoded['title']} has been sent successfully. Wait for admin to accept your request to admit you. ',
              ),
            ),
          ],
        ),
      )),
    );
  }
}
