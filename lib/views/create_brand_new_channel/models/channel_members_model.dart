
import 'package:cloud_firestore/cloud_firestore.dart';

class ChannelMembersModel {
  String userId;
  String userFullName;
  String username;
  bool isAdmin;


  ChannelMembersModel({
    required this.userId,
    required this.userFullName,
    required this.username,
    required this.isAdmin,
  });

  factory ChannelMembersModel.fromSnapshot(DocumentSnapshot doc) {
    return  ChannelMembersModel(
      userId: doc['userId'],
      userFullName: doc['userFullName'],
      username: doc['username'],
      isAdmin: doc['isAdmin'],
    );

  }

}
