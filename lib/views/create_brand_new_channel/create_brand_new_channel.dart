import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:walkie_talkie_360/provider/authentication_provider.dart';
import 'package:walkie_talkie_360/provider/channel_provider.dart';
import 'package:walkie_talkie_360/resources/image_manager.dart';
import 'package:walkie_talkie_360/views/create_brand_new_channel/models/image_status_model.dart';
import 'package:walkie_talkie_360/widgets/reusable_widget.dart';

import '../../resources/color_manager.dart';
import '../../resources/navigation_utils.dart';
import '../../resources/strings_manager.dart';
import '../../resources/value_manager.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/nav_screens_header.dart';
import 'models/channel_category.dart';
import 'models/channel_type_model.dart';


class CreateBrandNewChannel extends StatefulWidget {
  const CreateBrandNewChannel({Key? key}) : super(key: key);

  @override
  State<CreateBrandNewChannel> createState() => _CreateBrandNewChannelState();
}

class _CreateBrandNewChannelState extends State<CreateBrandNewChannel> {
  ChannelTypeModel? selectedChannelType;
  CategoryModel? selectedCategory;
  ImageStatusModel? selectedImageStatus;
  bool allowLocationSharing = false;
  bool allowUserTalkToAdmin =  false;
  bool moderatorCanInterrupt = false;
  final channelNameController = TextEditingController();
  final channelPasswordController = TextEditingController();
  final channelDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthenticationProvider>();
    return Scaffold(
      backgroundColor: ColorManager.bgColor,
      body: SafeArea(child: Column(
        children: [
          // SizedBox(height: AppSize.s46.h,),

          Container(
            height: AppSize.s54.h,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(AppImages.headerBgImage), fit: BoxFit.cover)
            ),
            alignment: Alignment.center,
            child: const NavScreensHeader(),
          ),

          Expanded(child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [

                SizedBox(height: AppSize.s28.h,),

                CustomTextWithLineHeight(
                  text: AppStrings.createAChannel,
                  textColor: ColorManager.textColor,),
                SizedBox(height: AppSize.s19.h,),

                Padding(padding: EdgeInsets.symmetric(horizontal: AppSize.s25.w),
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: channelNameController,
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
                                          child: DropdownButtonHint(
                                            hint: AppStrings.channelType,)),
                                    ],
                                  ),
                                  items: channelTypes
                                      .map((item) => DropdownMenuItem<ChannelTypeModel>(
                                      value: item,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          DropdownButtonText(
                                              text: item.channelType),
                                        ],
                                      )))
                                      .toList(),
                                  value: selectedChannelType,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedChannelType = value as ChannelTypeModel;
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

                      SizedBox(height: AppSize.s8.h,),

                      CustomTextField(
                        controller: channelPasswordController,
                        hint: AppStrings.channelPassword,
                        labelText: AppStrings.channelPassword,
                      ),

                      SizedBox(height: AppSize.s8.h,),

                      CustomTextField(
                        controller: channelDescriptionController,
                        hint: AppStrings.channelDescription,
                        labelText: AppStrings.channelDescription,
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
                                          child: DropdownButtonHint(
                                            hint: AppStrings.chooseCategory,)),
                                    ],
                                  ),
                                  items: categories
                                      .map((item) => DropdownMenuItem<CategoryModel>(
                                      value: item,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          DropdownButtonText(text: item.categoryTitle),
                                        ],
                                      )))
                                      .toList(),
                                  value: selectedCategory,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCategory = value as CategoryModel;
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
                                          child: DropdownButtonHint(
                                            hint: AppStrings.imageStatus,)),
                                    ],
                                  ),
                                  items: imageStatuses
                                      .map((item) => DropdownMenuItem<ImageStatusModel>(
                                      value: item,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          DropdownButtonText(text: item.image),
                                        ],
                                      )))
                                      .toList(),
                                  value: selectedImageStatus,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedImageStatus = value as ImageStatusModel;
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

                      SizedBox(height: AppSize.s22.h,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextWithLineHeight(
                            text: AppStrings.allowLocationSharing,
                            textColor: ColorManager.textColor,),

                          InkWell(
                              onTap: (){
                                setState(() {
                                  allowLocationSharing = !allowLocationSharing;
                                });
                              },
                              child: SvgPicture.asset(
                                  allowLocationSharing ?
                                  AppImages.checked : AppImages.unCheckedBox)),
                        ],
                      ),

                      SizedBox(height: AppSize.s11.h,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextWithLineHeight(
                            text: AppStrings.allowUserToTalkToAdmin,
                            textColor: ColorManager.textColor,),

                          InkWell(
                              onTap: (){
                                setState(() {
                                  allowUserTalkToAdmin = !allowUserTalkToAdmin;
                                });
                              },
                              child: SvgPicture.asset(allowUserTalkToAdmin ?
                              AppImages.checked : AppImages.unCheckedBox)),
                        ],
                      ),

                      SizedBox(height: AppSize.s11.h,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextWithLineHeight(
                            text: AppStrings.moderatorCanInterruptMessages,
                            textColor: ColorManager.textColor,),

                          InkWell(
                              onTap: (){
                                setState(() {
                                  moderatorCanInterrupt = !moderatorCanInterrupt;
                                });
                              },
                              child: SvgPicture.asset(moderatorCanInterrupt ?
                              AppImages.checked : AppImages.unCheckedBox)),
                        ],
                      ),
                      SizedBox(height: AppSize.s30.h,),
                      Consumer<ChannelProvider>(
                          builder: (ctx, channelProvider, child) {
                          WidgetsBinding.instance.
                          addPostFrameCallback((_) {
                            if(channelProvider.resMessage != '') {
                              showTopSnackBar(
                                context,
                                CustomSnackBar.info(
                                  message: channelProvider.resMessage,
                                  backgroundColor:
                                  ColorManager.primaryColor,
                                ),
                              );
                              ///Clear the response message to avoid duplicate
                              channelProvider.clear();
                            }
                          });
                          return WalkieButton(
                              height: AppSize.s51.h,
                              width: AppSize.s255.w,
                              context: context, onTap: ()async{
                            final isCreated = await channelProvider.createBrandNewChannel(
                                context, channelNameController.text.trim(),
                                selectedChannelType!.channelType,
                                channelPasswordController.text.trim(),
                                channelDescriptionController.text.trim(),
                                selectedCategory!.categoryTitle,
                                selectedImageStatus!.slug,
                                allowLocationSharing, allowUserTalkToAdmin,
                                moderatorCanInterrupt, authProvider);
                            if(isCreated){
                              authProvider.getUserChannels(
                                  FirebaseAuth.instance.currentUser!.uid);
                              openNavScreen(context);
                            }
                          }, title: AppStrings.createChannel);
                        }
                      ),
                      SizedBox(height: AppSize.s20.h,)
                    ],
                  ),)
              ],
            ),
          ))
        ],
      )),
    );
  }
}
