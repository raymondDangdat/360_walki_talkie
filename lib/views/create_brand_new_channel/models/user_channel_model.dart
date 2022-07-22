
import 'package:cloud_firestore/cloud_firestore.dart';

class UserChannelModel {
  String userId;
  String channelId;
  String channelName;
  bool isCreated;


  UserChannelModel({
    required this.userId,
    required this.channelId,
    required this.channelName,
    required this.isCreated,
  });

  factory UserChannelModel.fromSnapshot(DocumentSnapshot doc) {
    return  UserChannelModel(
      userId: doc['userId'],
      channelId: doc['channelId'],
      channelName: doc['channelName'],
      isCreated: doc['isCreated'],
    );

  }

}
