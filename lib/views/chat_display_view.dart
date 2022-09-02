import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:walkie_talkie_360/provider/authentication_provider.dart';
import 'package:walkie_talkie_360/provider/channel_provider.dart';
import 'package:walkie_talkie_360/resources/image_manager.dart';

import '../resources/message_tile_width.dart';
import '../widgets/message_tile.dart';


class ChatDisplayView extends StatelessWidget {

  const ChatDisplayView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final channelProvider = context.watch<ChannelProvider>();
    final authProvider = context.watch<AuthenticationProvider>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      // appBar: _buildAppBar(),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.tapToTalk),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                child: StreamBuilder(
                  stream: channelProvider.chats,
                  builder:
                      (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    var reversedData = snapshot.data?.docs.reversed;
                    return snapshot.hasData
                        ? ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      reverse: true,
                      itemBuilder: (context, index) {
                        return MessageTile(
                          id: index,
                          chatRoomId: channelProvider.selectedChannel.channelId,
                          duration:
                          reversedData!.elementAt(index).get('duration'),
                          sendBy: reversedData.elementAt(index).get('sendBy'),
                          time: reversedData.elementAt(index).get('time'),
                          sendByCurrentUser: authProvider.userInfo.userName ==
                              reversedData.elementAt(index).get('sendBy'),
                          messageTileWidth: MessageTileWidth.calculate(
                            Duration(
                              seconds:
                              reversedData.elementAt(index).get('duration'),
                            ),
                          ),
                        );
                      },
                    )
                        : Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.red,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
