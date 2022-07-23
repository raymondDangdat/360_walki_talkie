import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:walkie_talkie_360/provider/authentication_provider.dart';
import 'package:walkie_talkie_360/provider/channel_provider.dart';
import 'package:walkie_talkie_360/resources/color_manager.dart';
import 'package:walkie_talkie_360/resources/font_manager.dart';
import 'package:walkie_talkie_360/resources/image_manager.dart';
import 'package:walkie_talkie_360/resources/strings_manager.dart';
import 'package:walkie_talkie_360/resources/value_manager.dart';
import 'package:walkie_talkie_360/widgets/custom_text.dart';



import '../../../widgets/nav_screens_header.dart';

class ChatView extends StatelessWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthenticationProvider>();
    final channelProvider = context.watch<ChannelProvider>();
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: AppSize.s20.h,),
          const NavScreensHeader(),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: AppSize.s11.h,),
                  Container(
                    padding: EdgeInsets.only(top: AppSize.s21.h, bottom:
                    AppSize.s21.h,),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(image: AssetImage(AppImages.dashboardStats),
                          fit: BoxFit.cover),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: AppSize.s29.w,),
                        Image.asset(AppImages.wkt),

                        SizedBox(width: AppSize.s40.w,),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  CustomTextWithLineHeight(text: "${authProvider.userChannelsCreated.length}",
                                    textColor: ColorManager.textColor,
                                    fontSize: FontSize.s48,),
                                  SizedBox(
                                      width: AppSize.s89.w,
                                      child: CustomTextWithLineHeight(
                                        text: AppStrings.channelCreated ,
                                        textColor: ColorManager.textColor,)),
                                ],
                              ),

                              Row(
                                children: [
                                  CustomTextWithLineHeight(text: "${authProvider.userChannelsConnected.length}",
                                    textColor: ColorManager.textColor,
                                    fontSize: FontSize.s48,),
                                  SizedBox(
                                      width: AppSize.s89.w,
                                      child: CustomTextWithLineHeight(
                                        text: AppStrings.channelsConnectedTo ,
                                        textColor: ColorManager.textColor,)),
                                ],
                              ),

                              Row(
                                children: [
                                  CustomTextWithLineHeight(
                                    text: "0", textColor: ColorManager.textColor,
                                    fontSize: FontSize.s48,),
                                  SizedBox(
                                      width: AppSize.s89.w,
                                      child: CustomTextWithLineHeight(
                                        text: AppStrings.messageReceived,
                                        textColor: ColorManager.textColor,)),
                                ],
                              ),

                              Row(
                                children: [
                                  CustomTextWithLineHeight(text: "4",
                                    textColor: ColorManager.textColor,
                                    fontSize: FontSize.s48,),
                                  SizedBox(
                                      width: AppSize.s89.w,
                                      child: CustomTextWithLineHeight(
                                        text: AppStrings.chatMessage,
                                        textColor: ColorManager.textColor,)),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),),

                  SizedBox(height: AppSize.s9.h,),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: AppSize.s4.w),
                        child: CustomTextWithLineHeight(text: AppStrings.channelCreated, textColor: ColorManager.textColor,),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSize.s9.h,),
                  SizedBox(
                    height: AppSize.s200.h,
                    child:
                    authProvider.userChannelsCreated.isNotEmpty ? ListView.builder(
                        itemCount: authProvider.userChannelsCreated.length,
                        itemBuilder: (context, index){
                          final channel = authProvider.userChannelsCreated[index];
                          return InkWell(
                            onTap: (){

                              channelProvider.getChannelMembers(channel.channelId);
                            },
                            child: Padding(
                              padding: EdgeInsets.only(bottom: AppSize.s3.h),
                              child: Container(
                                height: AppSize.s52.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: ColorManager.textColor,
                                    image: const DecorationImage(image: AssetImage(AppImages.dashboardStats), fit: BoxFit.cover)
                                ),
                                child: CustomTextWithLineHeight(text: channel.channelName, textColor: ColorManager.whiteColor),
                                alignment: Alignment.center,
                              ),
                            ),
                          );
                        })  : CustomTextWithLineHeight(text: "No Creared Channels",
                      textColor: ColorManager.textColor,
                      fontSize: FontSize.s24,),
                  ),


                  SizedBox(height: AppSize.s9.h,),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: AppSize.s4.w),
                        child: CustomTextWithLineHeight(text: AppStrings.channelsConnectedTo, textColor: ColorManager.textColor,),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSize.s9.h,),
                  SizedBox(
                    height: AppSize.s200.h,
                    child:
                    authProvider.userChannelsConnected.isNotEmpty ? ListView.builder(
                        itemCount: authProvider.userChannelsConnected.length,
                        itemBuilder: (context, index){
                          final channel = authProvider.userChannelsConnected[index];
                          return InkWell(
                            onTap: (){
                            },
                            child: Padding(
                              padding: EdgeInsets.only(bottom: AppSize.s3.h),
                              child: Container(
                                height: AppSize.s52.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: ColorManager.textColor,
                                    image: const DecorationImage(image: AssetImage(AppImages.dashboardStats), fit: BoxFit.cover)
                                ),
                                child: CustomTextWithLineHeight(text: channel.channelName, textColor: ColorManager.whiteColor,),
                                alignment: Alignment.center,
                              ),
                            ),
                          );
                        }) : CustomTextWithLineHeight(text: "No Connected Channels",
                      textColor: ColorManager.textColor,
                      fontSize: FontSize.s24,),
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
