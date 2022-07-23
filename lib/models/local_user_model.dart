import 'package:cloud_firestore/cloud_firestore.dart';

class LocalUserModel {
  final String userID;
  final String fullName;
  final String phoneNumber;
  final String email;
  final String userName;
  final String userProfileUrl;

  LocalUserModel({
    required this.userID,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.userName,
    required this.userProfileUrl,

  });


  factory LocalUserModel.fromDocument(DocumentSnapshot doc) {
    return LocalUserModel(
      userID: doc['userId'],
      fullName : doc['fullName'] ?? '',
      phoneNumber : doc['phoneNumber'] ?? '',
      email: doc['email'] ?? '',
      userName: doc['userName'] ?? '',
      userProfileUrl: doc.data().toString().contains("userProfileUrl") ? doc.get("userProfileUrl") : "",
    );
  }
}
