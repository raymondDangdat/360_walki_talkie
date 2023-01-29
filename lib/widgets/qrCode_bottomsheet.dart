import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../resources/color_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/value_manager.dart';
import 'custom_text.dart';

customQrCodeBottomSheet(
    {required BuildContext context,
    required String channelId,
    required String channelTitle}) {
  ScreenshotController screenshotController = ScreenshotController();

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

  return showBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        color: ColorManager.primaryColor,
        child: SizedBox(
          height: AppSize.s500.h,
          width: double.infinity,
          child: Column(
            children: [
              Container(
                color: ColorManager.primaryColor,
                child: TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    label: CustomText(
                      textColor: ColorManager.bgColor,
                      text: AppStrings.close,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.close,
                      color: ColorManager.bgColor,
                    )),
              ),
              Expanded(
                child: Container(
                  color: ColorManager.bgColor,
                  child: SizedBox(
                    child: Screenshot<Widget>(
                      controller: screenshotController,
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            QrImage(
                              backgroundColor: ColorManager.whiteColor,
                              data: jsonEncode(<String, dynamic>{
                                "channelId": channelId,
                                "title": channelTitle,
                              }),
                              version: QrVersions.auto,
                              size: 320,
                              gapless: false,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: AppSize.s10),
                              child: SizedBox(
                                height: AppSize.s30,
                                child: CustomText(
                                    fontSize: AppSize.s15,
                                    fontWeight: FontWeight.bold,
                                    text: "Scan to join $channelTitle"),
                              ),
                            ),
                            IconButton(
                                constraints: BoxConstraints(),
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  _shareQrCode();
                                },
                                icon: Icon(
                                  Icons.share,
                                  color: ColorManager.bgColor,
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
