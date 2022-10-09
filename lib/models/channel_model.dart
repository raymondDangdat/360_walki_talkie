
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchChannelModel {
  String channelId;
  String channelName;

  SearchChannelModel({
    required this.channelId,
    required this.channelName,
  });


  factory SearchChannelModel.fromSnapshot(DocumentSnapshot doc) {
    return  SearchChannelModel(
      channelId: doc['channelId'],
      channelName: doc['channelName'],
    );

  }
}
