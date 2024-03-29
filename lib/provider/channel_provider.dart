import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
import 'package:path_provider/path_provider.dart';
import 'package:walkie_talkie_360/provider/authentication_provider.dart';
import 'package:walkie_talkie_360/resources/navigation_utils.dart';
import 'package:walkie_talkie_360/views/create_brand_new_channel/models/channel_members_model.dart';
import 'package:walkie_talkie_360/views/create_brand_new_channel/models/user_channel_model.dart';
import '../models/message.dart';
import '../resources/constanst.dart';
import '../service/abstracts/audio_player_service.dart';
import '../service/abstracts/storage_service.dart';
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

  bool  _isRecording = false;
  bool get isRecording => _isRecording;

  bool _isSuccessful = false;
  bool get isSuccessful => _isSuccessful;

  bool _isUploading = false;
  bool get isUploading => _isUploading;

  String _recordTime = "";
  String get recordTime => _recordTime;

  String _filePath = "";
  String get filePath => _filePath;
  FlutterAudioRecorder2? _audioRecorder;

  Stream<QuerySnapshot<Object?>>? _chatRooms;
  Stream<QuerySnapshot<Object?>>? get chatRooms => _chatRooms;

  Stream<QuerySnapshot>? get chats => _chats;
  Stream<QuerySnapshot>? _chats;

  ///Getter
  bool get isLoading => _isLoading;
  String get resMessage => _resMessage;
  List<UserChannelModel> get userChannels => _userChannels;
  List<UserChannelModel> get userChannelsCreated => _userChannelCreated;
  List<UserChannelModel> get userChannelsConnected => _userChannelsConnected;

  List<ChannelMembersModel> get channelMembers => _channelMembers;
  UserChannelModel get selectedChannel => _selectedChannel!;

   bool _isRecordPlaying = false;
  bool get isRecordPlaying => _isRecordPlaying;

  final _currentPosition = <int, int>{};
  Iterable<Reference>? _reference;
  String _loadedChatRoomId = '';
  String _loadedSendBy = '';
  int _loadedTime = -1;
  int _currentId = -1;
  int _currentDuration = -1;
  int _currentSecond = -1;

  late final AudioPlayerService _audioPlayerService;
  late final StorageService _storageService;

  int get currentId => _currentId;

  Map<int, int> get currentPosition => _currentPosition;





  void updateCurrentPosition(int id, int duration) {
    _currentPosition[id] = duration;
  }

  void onPressedPlayButton(
      int id, String chatRoomId, int duration, String sendBy, int time) async {
    if (_loadedChatRoomId != chatRoomId ||
        _loadedSendBy != sendBy ||
        _loadedTime != time) {
      _reference = null;
      await _pauseRecord();
      await _audioPlayerService.release();
      if (_currentId != -1) _currentPosition[_currentId] = _currentDuration;
    }

    _currentId = id;
    _currentDuration = duration;
    _currentSecond = -1;

    if (isRecordPlaying) {
      await _pauseRecord();
    } else {
      if (_reference == null) {
        await _loadRecord(chatRoomId, sendBy, time);
      } else {
        await _resumeRecord();
      }
    }
  }

  Future<void> _loadRecord(
      String _chatRoomId, String _sendBy, int _time) async {
    final List<Reference> _references =
    await _storageService.getUserRecords(_chatRoomId, _sendBy);
    _reference = _references.where((element) {
      if (element.name == (_time.toString() + '.wav')) return true;
      return false;
    });
    _loadedChatRoomId = _chatRoomId;
    _loadedSendBy = _sendBy;
    _loadedTime = _time;
    await _playRecord();
  }

  Future<List<Reference>> getUserRecords(
      String chatRoomId, String sendBy) async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    ListResult listResult = await firebaseStorage
        .ref()
        .child('records')
        .child(chatRoomId)
        .child(sendBy)
        .list();

    return listResult.items;
  }

  Future<void> _playRecord() async {
    _isRecordPlaying = true;
    await _audioPlayerService
        .play(await _reference!.elementAt(0).getDownloadURL());
  }

  Future<void> _resumeRecord() async {
    _isRecordPlaying = true;
    await _audioPlayerService.resume();
  }

  Future<void> _pauseRecord() async {
    _isRecordPlaying = false;
    await _audioPlayerService.pause();
  }



  setSelectedChannel(UserChannelModel userChannelModel){
    _selectedChannel = userChannelModel;
    notifyListeners();
  }


  Future<bool> createBrandNewChannel(BuildContext context,
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
      await saveChannelName(channelName, channelId);
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

  Future<bool> createChannelFromChannelName(BuildContext context,
      String channelName, String channelId,
      AuthenticationProvider auth,
      ) async{
    bool channelCreated = false;
    _isLoading = true;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => const LoadingIndicator());
    notifyListeners();
    try {


      await saveChannelInfoToUser(channelId, channelName, false);
      await saveMemberInChannel(channelId, channelName, false, auth);
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
      print("Error adding channel: ${e.toString()}");
    }

    return channelCreated;

  }

  Future<dynamic> getPreviousChatDetails(String? chatRoomId) async {
    return FirebaseFirestore.instance
        .collection('channelRoom')
        .doc(chatRoomId)
        .collection('chats')
        .orderBy('time')
        .snapshots();
  }


  Future saveChannelInfoToUser(String channelID,
      String channelName, bool isCreator) async{
    return await userCollection.doc(
        FirebaseAuth.instance.currentUser!.uid).collection("channels")
        .doc(channelID).set({
      'userId' : _firebaseAuth.currentUser!.uid,
      'channelId': channelID,
      'channelName': channelName,
      "isCreated": isCreator,
    });
  }

  Future saveChannelName(String channelName, String channelId) async{
    return await channelNamesCollection.doc(channelName.toLowerCase()).set({
      'channelName' : channelName,
      'channelId' : channelId
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

  Future<void> recordSound() async {
    final bool? hasRecordingPermission =
    await FlutterAudioRecorder2.hasPermissions;

    if (hasRecordingPermission ?? false) {
      _isRecording = true;
      notifyListeners();
      Directory directory = await getApplicationDocumentsDirectory();

      _recordTime = DateTime.now().millisecondsSinceEpoch.toString();
      String filepath = directory.path + '/' + _recordTime + '.wav';
      _audioRecorder =
          FlutterAudioRecorder2(filepath, audioFormat: AudioFormat.WAV);
      notifyListeners();
      if (_audioRecorder != null) {
        await _audioRecorder!.initialized;
        _audioRecorder!.start();
      }
      _filePath = filepath;
      notifyListeners();
      print("File Path $_filePath");
    } else {
      // Get.snackbar('Could not record!', 'Please enable recording permission.');
    }
  }

  void uploadSound(String user) async {
    if (_audioRecorder == null) return;

    //stop recording
    await _audioRecorder!.stop();

    // _setEffect();

    // if (_effectCommand != null) {
    //   _currentState.value = 'Adding effect...';
    //   _filePath = await _addEffectToRecord(_effectCommand!);
    // }

    // _currentState.value = 'Sending record...';

    //get details
    final audioDetails = await _audioRecorder!.current();

    //update screen
    _isRecording = false;
    _isUploading = true;

    //upload record to firebase
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;

    try {
      _isSuccessful = true;
      await firebaseStorage
          .ref('records')
          .child(_selectedChannel!.channelId)
          .child(FirebaseAuth.instance.currentUser!.uid)
          .child(
          _filePath.substring(_filePath.lastIndexOf('/'), _filePath.length))
          .putFile(File(_filePath));
    } catch (e) {
      _isSuccessful = false;
      _resMessage = "Could not send!', 'Error occured while sending message, please check your connection.";
    } finally {
      if (_isSuccessful) {
        Map<String, dynamic> _lastMessageInfo = {
          'lastMessageTime': int.parse(_recordTime),
          'lastMessageDuration': audioDetails!.duration!.inSeconds,
        };

        await updateLastMessageInfo(
            _lastMessageInfo, _selectedChannel!.channelId);

        await addMessage(
          _selectedChannel!.channelId,
          Message(
            duration: audioDetails.duration!.inSeconds,
            sendBy: user,
            time: int.parse(_recordTime),
          ),
        );
      }
      _isUploading = false;
    }
  }


  Future<void> updateLastMessageInfo(
      Map<String, dynamic> lastMessageInfo, String chatRoomId) async {
    FirebaseFirestore.instance
        .collection('channelRoom')
        .doc(chatRoomId)
        .update(lastMessageInfo)
        .catchError((e) {
      debugPrint(e.toString());
    });
  }

  Future<void> addMessage(String chatRoomId, chatMessageData) async {
    FirebaseFirestore.instance
        .collection('channelRoom')
        .doc(chatRoomId)
        .collection('chats')
        .add(chatMessageData.toMap())
        .catchError((e) {
      debugPrint(e.toString());
    });
  }


  Future<void> _getChatRooms(String userName) async {

    try {
      getUserChats(userName)
          .then((snapshots) {
        _chatRooms = snapshots;
        debugPrint('Name: $userName');
      });
    } catch (e) {
      // Get.snackbar('Could get data!', 'Please check your internet connection.');
    }
  }

  Future<dynamic> getUserChats(String currentUser) async {
    return FirebaseFirestore.instance
        .collection('chatRoom')
        .where('users', arrayContains: currentUser)
        .snapshots();
  }




  void clear() {
    _resMessage = "";
    // _isLoading = false;
    notifyListeners();
  }
}
