import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'package:walkie_talkie_360/provider/authentication_provider.dart';
import 'package:walkie_talkie_360/provider/channel_provider.dart';
import 'package:walkie_talkie_360/resources/color_manager.dart';
import 'package:walkie_talkie_360/resources/font_manager.dart';
import 'package:walkie_talkie_360/resources/image_manager.dart';
import 'package:walkie_talkie_360/resources/strings_manager.dart';
import 'package:walkie_talkie_360/resources/value_manager.dart';
import 'package:walkie_talkie_360/widgets/custom_text.dart';

class ChatView extends StatelessWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthenticationProvider>();
    final channelProvider = context.watch<ChannelProvider>();
    return SafeArea(
      child: Column(
        children: [
          // SizedBox(height: AppSize.s20.h,),
          // const NavScreensHeader(),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: AppSize.s11.h,
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: AppSize.s21.h,
                      bottom: AppSize.s21.h,
                    ),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(AppImages.dashboardStats),
                          fit: BoxFit.cover),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: AppSize.s29.w,
                        ),
                        Image.asset(AppImages.wkt),
                        SizedBox(
                          width: AppSize.s40.w,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  CustomTextWithLineHeight(
                                    text:
                                        "${authProvider.userChannelsCreated.length}",
                                    textColor: ColorManager.textColor,
                                    fontSize: FontSize.s48,
                                  ),
                                  SizedBox(
                                      width: AppSize.s89.w,
                                      child: CustomTextWithLineHeight(
                                        text: AppStrings.channelCreated,
                                        textColor: ColorManager.textColor,
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  CustomTextWithLineHeight(
                                    text:
                                        "${authProvider.userChannelsConnected.length}",
                                    textColor: ColorManager.textColor,
                                    fontSize: FontSize.s48,
                                  ),
                                  SizedBox(
                                      width: AppSize.s89.w,
                                      child: CustomTextWithLineHeight(
                                        text: AppStrings.channelsConnectedTo,
                                        textColor: ColorManager.textColor,
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  CustomTextWithLineHeight(
                                    text: "0",
                                    textColor: ColorManager.textColor,
                                    fontSize: FontSize.s48,
                                  ),
                                  SizedBox(
                                      width: AppSize.s89.w,
                                      child: CustomTextWithLineHeight(
                                        text: AppStrings.messageReceived,
                                        textColor: ColorManager.textColor,
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  CustomTextWithLineHeight(
                                    text: "4",
                                    textColor: ColorManager.textColor,
                                    fontSize: FontSize.s48,
                                  ),
                                  SizedBox(
                                      width: AppSize.s89.w,
                                      child: CustomTextWithLineHeight(
                                        text: AppStrings.chatMessage,
                                        textColor: ColorManager.textColor,
                                      )),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: AppSize.s9.h,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: AppSize.s4.w),
                        child: CustomTextWithLineHeight(
                          text: AppStrings.channelCreated,
                          textColor: ColorManager.textColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: AppSize.s9.h,
                  ),
                  SizedBox(
                    height: AppSize.s200.h,
                    child: authProvider.userChannelsCreated.isNotEmpty
                        ? ListView.builder(
                            itemCount: authProvider.userChannelsCreated.length,
                            itemBuilder: (context, index) {
                              final channel =
                                  authProvider.userChannelsCreated[index];
                              return InkWell(
                                onTap: () {
                                  channelProvider.setSelectedChannel(channel);
                                  channelProvider.getChannelMembers(
                                      context, channel.channelId);
                                },
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(bottom: AppSize.s3.h),
                                  child: Container(
                                    height: AppSize.s52.h,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: ColorManager.textColor,
                                        image: const DecorationImage(
                                            image: AssetImage(
                                                AppImages.dashboardStats),
                                            fit: BoxFit.cover)),
                                    child: CustomTextWithLineHeight(
                                        text: channel.channelName,
                                        textColor: ColorManager.whiteColor),
                                    alignment: Alignment.center,
                                  ),
                                ),
                              );
                            })
                        : CustomTextWithLineHeight(
                            text: "No Created Channels",
                            textColor: ColorManager.textColor,
                            fontSize: FontSize.s24,
                          ),
                  ),
                  SizedBox(
                    height: AppSize.s9.h,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: AppSize.s4.w),
                        child: CustomTextWithLineHeight(
                          text: AppStrings.channelsConnectedTo,
                          textColor: ColorManager.textColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: AppSize.s9.h,
                  ),
                  SizedBox(
                    height: AppSize.s200.h,
                    child: authProvider.userChannelsConnected.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                                authProvider.userChannelsConnected.length,
                            itemBuilder: (context, index) {
                              final channel =
                                  authProvider.userChannelsConnected[index];
                              return Padding(
                                  padding:
                                      EdgeInsets.only(bottom: AppSize.s3.h),
                                  child: ExpansionWidget(
                                      initiallyExpanded: false,
                                      titleBuilder: (double animationValue, _,
                                          bool isExpanded, toggleFunction) {
                                        return InkWell(
                                          onTap: () =>
                                              toggleFunction(animated: true),
                                          child: Container(
                                            height: AppSize.s52.h,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                color: ColorManager.textColor,
                                                image: const DecorationImage(
                                                    image: AssetImage(AppImages
                                                        .dashboardStats),
                                                    fit: BoxFit.cover)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: AppSize.s10),
                                                    child: SizedBox(
                                                        child: SvgPicture.asset(
                                                            AppImages
                                                                .mainChannelIcon)),
                                                  ),
                                                  Expanded(
                                                      child: Text(
                                                          channel.channelName,
                                                          style: TextStyle(
                                                              color: ColorManager
                                                                  .whiteColor))),
                                                  Transform.rotate(
                                                    angle: math.pi *
                                                        animationValue /
                                                        2,
                                                    child: const Icon(
                                                        Icons.arrow_right,
                                                        size: 40),
                                                    alignment: Alignment.center,
                                                  )
                                                ],
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                          ),
                                        );
                                      },
                                      content: ListView.builder(
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: authProvider
                                              .userChannelsConnected.length,
                                          itemBuilder: (context, index) {
                                            final channel = authProvider
                                                .userChannelsConnected[index];
                                            return Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: AppSize.s3.h),
                                                child: ExpansionWidget(
                                                  initiallyExpanded: false,
                                                  titleBuilder:
                                                      (double animationValue,
                                                          _,
                                                          bool isExpaned,
                                                          toogleFunction) {
                                                    return InkWell(
                                                      onTap: () {




                                                      },
                                                      child: Container(
                                                        height: AppSize.s52.h,
                                                        width: double.infinity,
                                                        decoration: const BoxDecoration(
                                                            image: DecorationImage(
                                                                image: AssetImage(
                                                                    AppImages
                                                                        .subChannelItem),
                                                                fit: BoxFit
                                                                    .cover)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .only(
                                                                    right: AppSize
                                                                        .s10),
                                                                child: SizedBox(
                                                                    child: SvgPicture.asset(
                                                                        AppImages
                                                                            .subChannelIcon)),
                                                              ),
                                                              Expanded(
                                                                  child: Text(
                                                                channel
                                                                    .channelName,
                                                                style: TextStyle(
                                                                    color: ColorManager
                                                                        .whiteColor),
                                                              )),
                                                            ],
                                                          ),
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                      ),
                                                    );
                                                  },
                                                  content: const SizedBox(),
                                                ));
                                          })));
                            })
                        : CustomTextWithLineHeight(
                            text: "No Connected Channels",
                            textColor: ColorManager.textColor,
                            fontSize: FontSize.s24,
                          ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
