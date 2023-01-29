import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:walkie_talkie_360/models/channel_model.dart';
import 'package:walkie_talkie_360/provider/authentication_provider.dart';
import 'package:walkie_talkie_360/resources/navigation_utils.dart';
import 'package:walkie_talkie_360/widgets/customDrawer.dart';
import 'package:walkie_talkie_360/widgets/custom_text.dart';
import 'package:walkie_talkie_360/widgets/reusable_widget.dart';
import '../../../resources/color_manager.dart';
import '../../../resources/strings_manager.dart';
import '../../../resources/value_manager.dart';
import '../../../widgets/nav_screens_header.dart';

class CreateQRCode extends StatefulWidget {
  const CreateQRCode({Key? key, required this.searchChannelModel})
      : super(key: key);
  final SearchChannelModel searchChannelModel;

  @override
  _CreateQRCodeState createState() => _CreateQRCodeState();
}

class _CreateQRCodeState extends State<CreateQRCode> {
  ScreenshotController screenshotController = ScreenshotController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthenticationProvider>();

    return Scaffold(
      backgroundColor: ColorManager.bgColor,
      key: _scaffoldKey,
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
                children:  [NavScreensHeader(onTapDrawer: () { _scaffoldKey.currentState?.openEndDrawer(); },)],
              ),
            ),
            SizedBox(
              height: AppSize.s90.h,
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
                        data: jsonEncode(<String, dynamic>{
                          "channelId": widget.searchChannelModel.channelId,
                          "title": widget.searchChannelModel.channelName
                        }),
                        version: QrVersions.auto,
                        size: 320,
                        gapless: false,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: AppSize.s10),
                        child: SizedBox(
                          height: AppSize.s50,
                          child: CustomText(
                              fontSize: AppSize.s15,
                              fontWeight: FontWeight.bold,
                              text:
                                  "Scan to join ${widget.searchChannelModel.channelName}"),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: AppSize.s55.h,
            ),
            Row(
              children: [
                const SizedBox(width: AppSize.s20),
                Expanded(
                  flex: 3,
                  child: WalkieButtonBordered(
                      context: context,
                      onTap: () {
                        openNavScreen(context);
                      },
                      title: AppStrings.returnToDashboard,
                      textColor: ColorManager.primaryColor,
                      borderColor: ColorManager.primaryColor),
                ),
                Expanded(
                    child: IconButton(
                        onPressed: () {
                          _shareQrCode();
                        },
                        icon: Icon(
                          Icons.share,
                          color: ColorManager.primaryColor,
                          size: AppSize.s35,
                        )))
              ],
            )
          ],
        ),
      )),
    );
  }

  _shareQrCode() async {
    final directory = (await getApplicationDocumentsDirectory()).path;
    await screenshotController.capture().then((Uint8List? image) async {
      if (image != null) {
        try {
          String fileName = DateTime.now().microsecondsSinceEpoch.toString();
          final imagePath = await File('$directory/$fileName.png').create();
          print(imagePath);
          if (imagePath != null) {
            await imagePath.writeAsBytes(image);
            Share.shareXFiles([XFile(imagePath.path)]);
          }
        } catch (error) {}
      }
    }).catchError((onError) {
      print('Error --->> $onError');
    });
  }
}
