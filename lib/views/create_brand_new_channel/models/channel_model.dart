
import 'package:cloud_firestore/cloud_firestore.dart';

class ChannelModel {
  String channelName;
  String channelType;
  String channelPassword;
  String channelDescription;
  String channelCategory;
  String imageStatus;
  bool allowLocationSharing;
  bool allowUserTalkToAdmin;
  bool moderatorCanInterrupt;
  String creatorId;


  ChannelModel({
    required this.channelName,
    required this.channelType,
    required this.channelPassword,
    required this.channelDescription,
    required this.channelCategory,
    required this.imageStatus,
    required this.allowLocationSharing,
    required this.allowUserTalkToAdmin,
    required this.moderatorCanInterrupt,
    required this.creatorId,
  });

  factory ChannelModel.fromSnapshot(DocumentSnapshot doc) {
    return  ChannelModel(
      channelName: doc['channelName'],
      channelType: doc['channelType'],
      channelPassword: doc['channelPassword'],
      channelDescription: doc['channelDescription'],
      channelCategory: doc['channelCategory'],
      imageStatus: doc['imageStatus'],
      allowUserTalkToAdmin: doc['allowUserTalkToAdmin'],
      allowLocationSharing: doc['allowLocationSharing'],
      moderatorCanInterrupt: doc['moderatorCanInterrupt'],
      creatorId: doc['creatorId'],
    );

  }





// Map toMap() {
//   var map = Map<String, dynamic>();
//   map['subject'] = subject;
//   map['id'] = id;
//   return map;
// }
}
