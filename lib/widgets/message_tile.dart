import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:walkie_talkie_360/resources/color_manager.dart';
import '../provider/channel_provider.dart';
import '../resources/time_formater.dart';

class MessageTile extends StatelessWidget {
  final int id;
  final String chatRoomId;
  final int duration;
  final String sendBy;
  final int time;
  final bool sendByCurrentUser;
  final double messageTileWidth;

  MessageTile(
      {Key? key,
        required this.id,
        required this.chatRoomId,
        required this.duration,
        required this.sendBy,
        required this.time,
        required this.sendByCurrentUser,
        required this.messageTileWidth})
      : super(key: key) {
    // _playerController.updateCurrentPosition(id, duration);
  }

  @override
  Widget build(BuildContext context) {
    final channelProvider = context.watch<ChannelProvider>();
    return Container(
      padding: EdgeInsets.only(
        top: 1.h,
        bottom: 1.h,
      ),
      child: Stack(
        alignment:
        sendByCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        children: [
          Container(
            height: 4.h,
            width: messageTileWidth,
            margin: sendByCurrentUser
                ? const EdgeInsets.only(left: 30)
                : const EdgeInsets.only(right: 30),
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                gradient: sendByCurrentUser
                    ? LinearGradient(colors: [
                  ColorManager.primaryColor,
                  ColorManager.bgColor
                ])
                    : LinearGradient(colors: [
                  ColorManager.primaryColor,
                  ColorManager.bgColor
                ])),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            //Changes the order of the children.
            textDirection:
            sendByCurrentUser ? TextDirection.rtl : TextDirection.ltr,
            children: [
              InkWell(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                highlightColor: Colors.transparent,
                onTap: () => channelProvider.onPressedPlayButton(
                    id, chatRoomId, duration, sendBy, time),
                child: Consumer<ChannelProvider>(
                    builder: (ctx, channelProvider, child) {
                      return Container(
                        height: 4.h,
                        width: 10.w,
                        decoration: BoxDecoration(
                          borderRadius: sendByCurrentUser
                              ? const BorderRadius.only(
                              topRight: Radius.circular(30),
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30))
                              : const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30)),
                          color: ColorManager.primaryColor,
                        ),
                        child: channelProvider.isRecordPlaying &&
                            channelProvider.currentId == id
                            ? Icon(
                          Icons.pause_rounded,
                          size: 6.w,
                          color: ColorManager.primaryColor,
                        )
                            : Icon(
                          Icons.play_arrow_rounded,
                          size: 6.w,
                          color: ColorManager.primaryColor,
                        ),
                      );
                    }
                ),
              ),
              Container(
                color: ColorManager.primaryColor,
                height: 0.2.h,
                //10.w for play button.
                //12.w for duration label.
                //02.w for space on end.
                //24.w => Total.
                width: messageTileWidth - 24.w,
              ),
              _buildDurationLabel(),
            ],
          ),
        ],
      ),
    );
  }

  // InkWell _buildPlayButton() {
  //   return InkWell(
  //     overlayColor: MaterialStateProperty.all(Colors.transparent),
  //     highlightColor: Colors.transparent,
  //     onTap: () => _playerController.onPressedPlayButton(
  //         id, chatRoomId, duration, sendBy, time),
  //     child: Consumer<ChannelProvider>(
  //         builder: (ctx, channelProvider, child) {
  //         return Container(
  //           height: 4.h,
  //           width: 10.w,
  //           decoration: BoxDecoration(
  //             borderRadius: sendByCurrentUser
  //                 ? const BorderRadius.only(
  //                 topRight: Radius.circular(30),
  //                 bottomLeft: Radius.circular(30),
  //                 bottomRight: Radius.circular(30))
  //                 : const BorderRadius.only(
  //                 topLeft: Radius.circular(30),
  //                 bottomLeft: Radius.circular(30),
  //                 bottomRight: Radius.circular(30)),
  //             color: ColorManager.primaryColor,
  //           ),
  //           child: channelProvider.isRecordPlaying &&
  //                     channelProvider.currentId == id
  //                 ? Icon(
  //               Icons.pause_rounded,
  //               size: 6.w,
  //               color: ColorManager.primaryColor,
  //             )
  //                 : Icon(
  //               Icons.play_arrow_rounded,
  //               size: 6.w,
  //               color: ColorManager.primaryColor,
  //             ),
  //         );
  //       }
  //     ),
  //   );
  // }

  Container _buildDurationLabel() {
    return Container(
      height: 2.5.h,
      width: 12.w,
      decoration: BoxDecoration(
        borderRadius: sendByCurrentUser
            ? const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(8),
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(8))
            : const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(30),
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(30)),
        color: ColorManager.primaryColor,
      ),
      child: Center(
        child: Consumer<ChannelProvider>(
            builder: (ctx, channelProvider, child) {
            return Text(
                TimeFormat.format(
                    duration: Duration(
                        seconds: channelProvider.currentPosition[id] ?? 0)),
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: ColorManager.primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              );
          }
        ),
      ),
    );
  }
}
