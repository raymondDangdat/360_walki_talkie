import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:walkie_talkie_360/models/channel_model.dart';
import 'package:walkie_talkie_360/provider/authentication_provider.dart';
import 'package:walkie_talkie_360/resources/font_manager.dart';
import 'package:walkie_talkie_360/resources/navigation_utils.dart';
import 'package:walkie_talkie_360/widgets/reusable_widget.dart';

import '../../../resources/color_manager.dart';
import '../../../resources/image_manager.dart';
import '../../../resources/strings_manager.dart';
import '../../../resources/value_manager.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/nav_screens_header.dart';

class CreateQRCode extends StatelessWidget {
  const CreateQRCode({Key? key, required this.searchChannelModel})
      : super(key: key);

  final SearchChannelModel searchChannelModel;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthenticationProvider>();
    return Scaffold(
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
                children: const [NavScreensHeader()],
              ),
            ),
            SizedBox(
              height: AppSize.s144.h,
            ),
            SizedBox(
              child: Container(
                  color: Colors.white,
                  child: QrImage(
                    data: <String, dynamic>{
                      "channelId": searchChannelModel.channelId,
                      "title": searchChannelModel.channelName
                    }.toString(),
                    version: QrVersions.auto,
                    size: 320,
                    gapless: false,
                  )),
            ),
            SizedBox(
              height: AppSize.s19.h,
            ),

            SizedBox(
              height: AppSize.s19.h,
            ),
            WalkieButtonBordered(
                context: context,
                onTap: () {
                  openNavScreen(context);
                },
                title: AppStrings.returnToDashboard,
                textColor: ColorManager.primaryColor,
                borderColor: ColorManager.primaryColor)
          ],
        ),
      )),
    );
  }
}
