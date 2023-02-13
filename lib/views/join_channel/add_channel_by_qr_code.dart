import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:walkie_talkie_360/provider/authentication_provider.dart';
import 'package:walkie_talkie_360/provider/channel_provider.dart';
import 'package:walkie_talkie_360/resources/routes_manager.dart';
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

class AddChannelByQRCode extends StatefulWidget {
  const AddChannelByQRCode({Key? key}) : super(key: key);

  @override
  State<AddChannelByQRCode> createState() => _AddChannelByQRCodeState();
}

class _AddChannelByQRCodeState extends State<AddChannelByQRCode> {
  final channelNameController = TextEditingController();

  bool channelNameFound = false;
  bool isSearching = false;
  String channelName = "";
  String channelId = "";

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

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  void initState() {
    super.initState();
    getAllChannels();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthenticationProvider>();
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
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
            CustomTextWithLineHeight(
              fontSize: AppSize.s25,
              fontWeight: FontWeightManager.bold,
              text: AppStrings.scanqrcodetojion,
              textColor: ColorManager.textColor,
            ),
            SizedBox(
              height: AppSize.s30.h,
            ),
            Container(
                height: AppSize.s198.h,
                width: AppSize.s180.w,
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                      borderColor: Colors.red,
                      borderRadius: 5,
                      borderLength: 35,
                      borderWidth: 5,
                      cutOutSize: scanArea),
                )),
            SizedBox(
              height: AppSize.s40,
            ),
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: AppSize.s130.w,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          controller?.toggleFlash();
                        },
                        icon: Icon(
                          Icons.light_mode_sharp,
                          color: ColorManager.blackColor,
                        ),
                        label: CustomText(
                          text: 'Toggle Flash',
                        ),
                      ),
                    ),
                    SizedBox(width: AppSize.s10),
                    SizedBox(
                      width: AppSize.s130.w,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          controller?.flipCamera();
                        },
                        icon: Icon(
                          Icons.camera_front,
                          color: ColorManager.blackColor,
                        ),
                        label: CustomText(
                          text: 'Flip Camera',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Consumer(
              builder: (BuildContext context, value, Widget? child) {
                final ref = context.watch<ChannelProvider>();
                return SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ref.isCameraPaused == true
                            ? Expanded(
                                child: Container(
                                  width: AppSize.s130.w,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: AppPadding.p40),
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      ref.pausePlayQRCamera();
                                      controller?.resumeCamera();
                                    },
                                    icon: Icon(
                                      Icons.play_arrow,
                                      color: ColorManager.blackColor,
                                    ),
                                    label: CustomText(
                                      text: 'Resume Camera',
                                    ),
                                  ),
                                ),
                              )
                            : Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: AppPadding.p40),
                                  width: AppSize.s130.w,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      ref.pausePlayQRCamera();
                                      controller?.pauseCamera();
                                    },
                                    icon: Icon(
                                      Icons.pause,
                                      color: ColorManager.blackColor,
                                    ),
                                    label: CustomText(
                                      text: 'Pause Camera',
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      )),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
        Navigator.pushReplacementNamed(context, Routes.qrRequestSent,
            arguments: result);
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
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
