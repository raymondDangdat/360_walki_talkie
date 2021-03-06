import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:walkie_talkie_360/views/create_brand_new_channel/models/dummy_channels.dart';

import '../../resources/color_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/image_manager.dart';
import '../../resources/strings_manager.dart';
import '../../resources/value_manager.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/nav_screens_header.dart';
import '../../widgets/reusable_widget.dart';

class GenerateChannelQrCode extends StatefulWidget {
  const GenerateChannelQrCode({Key? key}) : super(key: key);

  @override
  State<GenerateChannelQrCode> createState() => _GenerateChannelQrCodeState();
}

class _GenerateChannelQrCodeState extends State<GenerateChannelQrCode> {
  DummyChannels? selectedChannel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.bgColor,
      body: SafeArea(child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: AppSize.s46.h,),

            Container(
              height: AppSize.s54.h,
              decoration: BoxDecoration(
                  color: ColorManager.textColor
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  NavScreensHeader()
                ],
              ),
            ),



            SizedBox(height: AppSize.s34.h,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSize.s50.w),
              child: CustomTextWithLineHeight(text: AppStrings.generateChannelQrCode, fontSize: FontSize.s24, textColor: ColorManager.primaryColor,),
            ),
            SizedBox(height: AppSize.s34.h,),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSize.s50.w),
              child: CustomTextWithLineHeight(text: AppStrings.youCanCreateAs, fontSize: FontSize.s16, textColor: ColorManager.primaryColor,),
            ),

            SizedBox(height: AppSize.s34.h,),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSize.s50.w),
              child: Row(
                children: [
                  Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          hint: Row(
                            children: const [
                              Expanded(
                                  child: DropdownButtonHint(hint: AppStrings.chooseChannelHere,)),
                            ],
                          ),
                          items: dummyChannels
                              .map((item) => DropdownMenuItem<DummyChannels>(
                              value: item,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  DropdownButtonText(
                                    width: MediaQuery.of(context).size.width * 0.5,
                                      text: item.title),
                                ],
                              )))
                              .toList(),
                          value: selectedChannel,
                          onChanged: (value) {
                            setState(() {
                              selectedChannel = value as DummyChannels;
                            });
                          },
                          icon: SvgPicture.asset(AppImages.dropdownIcon),
                          iconSize: 14,
                          buttonHeight: 50,
                          buttonPadding:
                          const EdgeInsets.only(left: 14, right: 14),
                          buttonDecoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(AppSize.s6.r),
                            border: Border.all(
                              color: ColorManager.textColor,
                            ),
                            color: ColorManager.bgColor,
                          ),
                          itemHeight: 40,
                          dropdownPadding: null,
                          dropdownDecoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(AppSize.s4.r),
                            color: ColorManager.deepOrange,
                          ),
                          dropdownElevation: 8,
                          selectedItemHighlightColor:
                          ColorManager.bgColor,
                          scrollbarAlwaysShow: false,
                          offset: const Offset(0, 0),
                        ),
                      )
                  ),
                ],
              ),
            ),

            SizedBox(height: AppSize.s26.h,),
            
            WalkieButton(context: context, onTap: (){}, title: AppStrings.createQrCode)

          ],
        ),
      )),
    );
  }
}
