import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:walkie_talkie_360/resources/image_manager.dart';
import 'package:walkie_talkie_360/widgets/reusable_widget.dart';

import '../../resources/color_manager.dart';
import '../../resources/strings_manager.dart';
import '../../resources/value_manager.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/nav_screens_header.dart';
import 'models/channel_type_model.dart';

class CreateBrandNewChannel extends StatefulWidget {
  const CreateBrandNewChannel({Key? key}) : super(key: key);

  @override
  State<CreateBrandNewChannel> createState() => _CreateBrandNewChannelState();
}

class _CreateBrandNewChannelState extends State<CreateBrandNewChannel> {
  ChannelTypeModel? selectedChannelType;
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
              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage(AppImages.headerBgImage), fit: BoxFit.cover)
              ),
              alignment: Alignment.center,
              child: const NavScreensHeader(),
            ),


            SizedBox(height: AppSize.s28.h,),

            CustomTextWithLineHeight(text: AppStrings.createAChannel, textColor: ColorManager.textColor,),
            SizedBox(height: AppSize.s19.h,),

            Padding(padding: EdgeInsets.symmetric(horizontal: AppSize.s25.w),
              child: Column(
                children: [
                  CustomTextField(
                    hint: AppStrings.enterChannelName,
                    labelText: AppStrings.enterChannelName,
                  ),

                  SizedBox(height: AppSize.s8.h,),

                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  isExpanded: true,
                                  hint: Row(
                                    children: const [
                                      Expanded(
                                          child: DropdownButtonHint(hint: "Select Channel Type",)),
                                    ],
                                  ),
                                  items: channelTypes
                                      .map((item) => DropdownMenuItem<ChannelTypeModel>(
                                      value: item,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                                DropdownButtonText(text: item.channelType),
                                        ],
                                      )))
                                      .toList(),
                                  value: selectedChannelType,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedChannelType = value as ChannelTypeModel;
                                    });
                                  },
                                  icon: Icon(Icons.arrow_drop_down, color: ColorManager.textColor,),
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

                  SizedBox(height: AppSize.s8.h,),

                  CustomTextField(
                    hint: AppStrings.channelPassword,
                    labelText: AppStrings.channelPassword,
                  ),

                  SizedBox(height: AppSize.s8.h,),

                  CustomTextField(
                    hint: AppStrings.channelDescription,
                    labelText: AppStrings.channelDescription,
                  ),

                  SizedBox(height: AppSize.s8.h,),

                  CustomTextField(
                    hint: AppStrings.chooseLanguage,
                    labelText: AppStrings.chooseLanguage,
                  ),

                ],
              ),)





          ],
        ),
      )),
    );
  }
}
