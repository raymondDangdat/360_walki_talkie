
import 'package:cloud_firestore/cloud_firestore.dart';

class SubChannelModel {
  String subChannelId;
  String subChannelName;

  SubChannelModel({
    required this.subChannelId,
    required this.subChannelName,
  });

  factory SubChannelModel.fromSnapshot(DocumentSnapshot doc) {
    return  SubChannelModel(
      subChannelName: doc['channelName'],
      subChannelId: doc['subChannelId'],
    );

  }
}
