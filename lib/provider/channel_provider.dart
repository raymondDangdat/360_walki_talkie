import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:walkie_talkie_360/provider/authentication_provider.dart';
import 'package:walkie_talkie_360/resources/navigation_utils.dart';
import 'package:walkie_talkie_360/views/create_brand_new_channel/models/channel_members_model.dart';
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
  UserChannelModel? _selectedChannel;
  List<UserChannelModel> _userChannelCreated = [];
  List<UserChannelModel> _userChannelsConnected = [];

  List<ChannelMembersModel> _channelMembers = [];

  ///Getter
  bool get isLoading => _isLoading;
  String get resMessage => _resMessage;
  List<UserChannelModel> get userChannels => _userChannels;
  List<UserChannelModel> get userChannelsCreated => _userChannelCreated;
  List<UserChannelModel> get userChannelsConnected => _userChannelsConnected;

  List<ChannelMembersModel> get channelMembers => _channelMembers;
  UserChannelModel get selectedChannel => _selectedChannel!;

  setSelectedChannel(UserChannelModel userChannelModel){
    _selectedChannel = userChannelModel;
    notifyListeners();
  }





  Future<bool> createChannel(BuildContext context,
      String channelName, String channelType,
      String channelPassword, String channelDescription,
      String channelCategory, String imageStatus,
      bool allowLocationSharing,bool allowUserTalkToAdmin,
      bool moderatorCanInterrupt,
      AuthenticationProvider auth,
      ) async{
    bool channelCreated = false;
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
      await saveMemberInChannel(channelId, channelName, true, auth);
      channelCreated = true;

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

    return channelCreated;

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

  Future saveMemberInChannel(String channelID,
      String channelName, bool isCreator, AuthenticationProvider auth) async{
    return await channelsCollection.doc(channelID).collection("members")
        .doc(FirebaseAuth.instance.currentUser!.uid).set({
      'userId' : _firebaseAuth.currentUser!.uid,
      'username': auth.userInfo.userName,
      'userFullName': auth.userInfo.fullName,
      "isAdmin": isCreator,
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


  Future<void> getChannelMembers(BuildContext context, String channelId) async{
    _isLoading = true;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => const LoadingIndicator());
    notifyListeners();

    try{
      QuerySnapshot querySnapshot = await channelsCollection
          .doc(channelId)
          .collection("members")
          .get();
      _channelMembers =  querySnapshot.docs.map((doc) => ChannelMembersModel.fromSnapshot(doc)).toList();
      print("Length of channels: ${_channelMembers.length}");

      Navigator.pop(context);
      _isLoading = false;
      openChannelMembersChats(context);

      notifyListeners();
    }catch (e){
      _isLoading = false;
      Navigator.pop(context);
      notifyListeners();
      print("Error getting members: ${e.toString()}");
    }
  }




  void clear() {
    _resMessage = "";
    // _isLoading = false;
    notifyListeners();
  }
}
