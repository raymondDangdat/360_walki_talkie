import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:walkie_talkie_360/resources/navigation_utils.dart';
import 'package:walkie_talkie_360/views/create_brand_new_channel/models/user_channel_model.dart';
import '../resources/constanst.dart';
import '../widgets/loading.dart';

import 'package:random_string/random_string.dart';

class ChannelProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  ///Setter
  bool _isLoading = false;
  String _resMessage = '';
  List<UserChannelModel> _userChannels = [];
  List<UserChannelModel> _userChannelCreated = [];
  List<UserChannelModel> _userChannelsConnected = [];

  ///Getter
  bool get isLoading => _isLoading;
  String get resMessage => _resMessage;
  List<UserChannelModel> get userChannels => _userChannels;
  List<UserChannelModel> get userChannelsCreated => _userChannelCreated;
  List<UserChannelModel> get userChannelsConnected => _userChannelsConnected;



  Future createChannel(BuildContext context,
      String channelName, String channelType,
      String channelPassword, String channelDescription,
      String channelCategory, String imageStatus,
      bool allowLocationSharing,bool allowUserTalkToAdmin,
      bool moderatorCanInterrupt,
      ) async{
    _isLoading = true;
    final channelId = randomAlphaNumeric(10);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => const LoadingIndicator());
    notifyListeners();


    try {
      await channelsCollection.doc(channelId).set({
        'channelName' : channelName,
        'channelType' : channelType,
        'channelPassword' : channelPassword,
        'channelDescription': channelDescription,
        'channelCategory' : channelCategory,
        'imageStatus': imageStatus,
        'allowLocationSharing': allowLocationSharing,
        'allowUserTalkToAdmin': allowUserTalkToAdmin,
        'moderatorCanInterrupt': moderatorCanInterrupt,
        "creatorId": FirebaseAuth.instance.currentUser!.uid,
      });

      await saveChannelInfoToUser(channelId, channelName, true);

      openNavScreen(context);

    } on SocketException catch (_) {
      _isLoading = false;
      _resMessage = "Internet connection is not available";
      notifyListeners();
      Navigator.pop(context);
    } catch (e) {
      _isLoading = false;
      _resMessage = e.toString();
      notifyListeners();
      Navigator.pop(context);
      print("Error creating channel: ${e.toString()}");
    }

    // return await channelsCollection.doc().set({
    //   'channelName' : channelName,
    //   'channelType' : channelType,
    //   'channelPassword' : channelPassword,
    //   'channelDescription': channelDescription,
    //   'channelCategory' : channelCategory,
    //   'imageStatus': imageStatus,
    //   'allowLocationSharing': allowLocationSharing,
    //   'allowUserTalkToAdmin': allowUserTalkToAdmin,
    //   'moderatorCanInterrupt': moderatorCanInterrupt,
    //   "creatorId": FirebaseAuth.instance.currentUser!.uid,
    // });

  }


  Future saveChannelInfoToUser(String channelID,
      String channelName, bool isCreator) async{
    return await userCollection.doc(
        FirebaseAuth.instance.currentUser!.uid).collection("channels")
        .doc().set({
      'userId' : _firebaseAuth.currentUser!.uid,
      'channelId': channelID,
      'channelName': channelName,
      "isCreated": isCreator,
    });
  }


  Future<void> getUserChannels(String userId) async{
    QuerySnapshot querySnapshot = await userCollection
        .doc(userId)
        .collection("channels")
        .get();
   _userChannels =  querySnapshot.docs.map((doc) => UserChannelModel.fromSnapshot(doc)).toList();

   _userChannelCreated = _userChannels.where((channel) => channel.isCreated == true).toList();
    _userChannelsConnected = _userChannels.where((channel) => channel.isCreated == false).toList();

   print("Length of channels: ${_userChannels.length}");
    print("Length of created channels: ${_userChannelCreated.length}");
    print("Length of connected channels: ${_userChannelsConnected.length}");

   notifyListeners();
  }




  void clear() {
    _resMessage = "";
    // _isLoading = false;
    notifyListeners();
  }
}
