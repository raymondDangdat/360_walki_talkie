
import 'package:cloud_firestore/cloud_firestore.dart';

class UserChannelModel {
  String userId;
  String channelId;
  String channelName;
  Timestamp createdAt;
  bool isCreated;
  bool isBlocked;
  bool isApproved;

  UserChannelModel({
    required this.userId,
    required this.channelId,
    required this.channelName,
    required this.createdAt,
    required this.isCreated,
    required this.isBlocked,
    required this.isApproved,
  });

  factory UserChannelModel.fromSnapshot(DocumentSnapshot doc) {
    return  UserChannelModel(
      userId: doc['userId'],
      channelId: doc['channelId'],
      channelName: doc['channelName'],
      createdAt: doc['createdAt'],
      isCreated: doc['isCreated'],
      isBlocked: doc['isBlocked'],
      isApproved: doc['isApproved'],
    );

  }
}
