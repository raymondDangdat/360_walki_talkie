import 'dart:io';
import 'package:audio_session/audio_session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:jiffy/jiffy.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:walkie_talkie_360/provider/authentication_provider.dart';
import 'package:walkie_talkie_360/resources/color_manager.dart';
import 'package:walkie_talkie_360/resources/navigation_utils.dart';
import 'package:walkie_talkie_360/views/create_brand_new_channel/models/channel_members_model.dart';
import 'package:walkie_talkie_360/views/create_brand_new_channel/models/user_channel_model.dart';
import '../models/message.dart';
import '../models/sub_channel_model.dart';
import '../resources/constanst.dart';
import '../service/abstracts/audio_player_service.dart';
import '../service/abstracts/storage_service.dart';
import '../views/channel_users_list_and_chats/channel_members_chats.dart';
import '../widgets/custom_text.dart';
import '../widgets/loading.dart';

import 'package:random_string/random_string.dart';

class ChannelProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  ///Setter
  bool _isLoading = false;
  bool _isLoadingSubChannels = false;
  bool get isLoadingSubChannels => _isLoadingSubChannels;

  int _channelCreatedIndexToShowSubChannels = -1;
  int get channelCreatedIndexToShowSubChannels =>
      _channelCreatedIndexToShowSubChannels;

  int _channelConnectedIndexToShowSubChannels = -1;
  int get channelConnectedIndexToShowSubChannels =>
      _channelConnectedIndexToShowSubChannels;

  String _resMessage = '';
  List<UserChannelModel> _userChannels = [];
  UserChannelModel? _selectedChannel;
  List<UserChannelModel> _userChannelCreated = [];
  List<UserChannelModel> _userChannelsConnected = [];
  final Map<String, dynamic> _chosenChannel = {};

  Map<String, dynamic> get chosenChannel => _chosenChannel;

  List<ChannelMembersModel> _channelMembers = [];

  List<SubChannelModel> _subChannels = [];
  List<SubChannelModel> get subChannels => _subChannels;

  bool _isRecording = false;
  bool get isRecording => _isRecording;

  bool _isSuccessful = false;
  bool get isSuccessful => _isSuccessful;

  bool _isUploading = false;
  bool get isUploading => _isUploading;

  String _recordTime = "";
  String get recordTime => _recordTime;

  String _filePath = "";
  String get filePath => _filePath;

  String _encryptedFilePath = "";
  String get encryptedFilePath => _encryptedFilePath;

  String _decryptedFilePath = "";
  String get decryptedFilePath => _decryptedFilePath;

  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool _mRecorderInitialised = false;

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

  SubChannelModel? _selectedSubChannel;
  SubChannelModel? get selectedSubChannel => _selectedSubChannel;

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
  late Task uploadTask;
  late File myDecryptedPath;
  String cloudNakedURL = '';

  final storageRef = FirebaseStorage.instance.ref();

  int get currentId => _currentId;

  bool _isCameraPaused = true;
  bool get isCameraPaused => _isCameraPaused;

  bool _showPrompt = false;
  bool get showPrompt => _showPrompt;

  Map<int, int> get currentPosition => _currentPosition;

  void updateCurrentPosition(int id, int duration) {
    _currentPosition[id] = duration;
  }

  void pausePlayQRCamera() async {
    _isCameraPaused = !_isCameraPaused;
    notifyListeners();
  }

  void promptIsTrue() async {
    _showPrompt = true;
    notifyListeners();
  }

  void promptIsFalse() async {
    _showPrompt = false;
    notifyListeners();
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
      if (element.name == (_time.toString() + '.mp4')) return true;
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

  setSelectedChannel(UserChannelModel userChannelModel) {
    _selectedChannel = userChannelModel;
    notifyListeners();
  }

  updateSelectedSubChannel(SubChannelModel subChannel) {
    _selectedSubChannel = subChannel;
    notifyListeners();
  }

  showCreatedSubChannelsAtIndex(int channelIndex) {
    _channelCreatedIndexToShowSubChannels = channelIndex;
    print("New index $channelIndex");
    notifyListeners();
  }

  showConnectedSubChannelsAtIndex(int channelIndex) {
    _channelConnectedIndexToShowSubChannels = channelIndex;
    print("New index $channelIndex");
    notifyListeners();
  }

  Future<bool> createBrandNewChannel(
    BuildContext context,
    String channelName,
    String channelType,
    String channelPassword,
    String channelDescription,
    String channelCategory,
    String imageStatus,
    bool allowLocationSharing,
    bool allowUserTalkToAdmin,
    bool moderatorCanInterrupt,
    AuthenticationProvider auth,
  ) async {
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
        'channelName': channelName,
        'channelType': channelType,
        'channelPassword': channelPassword,
        'channelDescription': channelDescription,
        'channelCategory': channelCategory,
        'imageStatus': imageStatus,
        'allowLocationSharing': allowLocationSharing,
        'allowUserTalkToAdmin': allowUserTalkToAdmin,
        'moderatorCanInterrupt': moderatorCanInterrupt,
        "creatorId": FirebaseAuth.instance.currentUser!.uid,
        "createdAt": DateTime.now(),
      });

      await saveChannelInfoToUser(channelId, channelName, true);
      await saveMemberInChannel(context, channelId, channelName, true, auth);
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
      if (kDebugMode) {
        print("Error creating channel: ${e.toString()}");
      }
    }

    return channelCreated;
  }

  Future<bool> createBrandNewSubChannel(
    BuildContext context,
    String channelName,
    String channelType,
    String channelPassword,
    String channelDescription,
    String channelCategory,
    String imageStatus,
    bool allowLocationSharing,
    bool allowUserTalkToAdmin,
    bool moderatorCanInterrupt,
    AuthenticationProvider auth,
  ) async {
    print('Create Brand New Sub Channel Method called');
    bool channelCreated = false;
    _isLoading = true;
    final subChannelId = randomAlphaNumeric(10);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => const LoadingIndicator());
    notifyListeners();
    try {
      final collectionRef = await channelsCollection
          .doc(selectedChannel.channelId)
          .collection(subChannel)
          .doc(subChannelId)
          .set({
        'channelName': channelName,
        "subChannelId": subChannelId,
        'channelType': channelType,
        'channelPassword': channelPassword,
        'channelDescription': channelDescription,
        'channelCategory': channelCategory,
        'imageStatus': imageStatus,
        'allowLocationSharing': allowLocationSharing,
        'allowUserTalkToAdmin': allowUserTalkToAdmin,
        'moderatorCanInterrupt': moderatorCanInterrupt,
        "creatorId": FirebaseAuth.instance.currentUser!.uid,
        "createdAt": DateTime.now(),
      });

      // DocumentReference docRef = await
      // FirebaseFirestore.instance
      //     .collection(channels)
      //     .doc(selectedChannel.channelId)
      //     .collection(subChannel)
      //     .add({
      //   'channelName': channelName,
      //   'channelType': channelType,
      //   'channelPassword': channelPassword,
      //   'channelDescription': channelDescription,
      //   'channelCategory': channelCategory,
      //   'imageStatus': imageStatus,
      //   'allowLocationSharing': allowLocationSharing,
      //   'allowUserTalkToAdmin': allowUserTalkToAdmin,
      //   'moderatorCanInterrupt': moderatorCanInterrupt,
      //   "creatorId": FirebaseAuth.instance.currentUser!.uid,
      // });
      //
      // print("RefName ${docRef.id}");

      await saveSubChannelInfoToUser(subChannelId, channelName, true);
      await saveMemberInSubChannel(subChannelId, true, auth);
      await saveSubChannelName(channelName, subChannelId);
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
      if (kDebugMode) {
        print("Error creating channel: ${e.toString()}");
      }
    }
    return channelCreated;
  }
  //
  // Future<bool> createChannelFromChannelName(
  //   BuildContext context,
  //   String channelName,
  //   String channelId,
  //   AuthenticationProvider auth,
  // ) async {
  //   bool channelCreated = false;
  //   _isLoading = true;
  //   showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (BuildContext context) => const LoadingIndicator());
  //   notifyListeners();
  //   try {
  //
  //     await saveMemberInChannel(channelId, channelName, false, auth);
  //     channelCreated = true;
  //   } on SocketException catch (_) {
  //     _isLoading = false;
  //     _resMessage = "Internet connection is not available";
  //     notifyListeners();
  //     Navigator.pop(context);
  //   } catch (e) {
  //     _isLoading = false;
  //     _resMessage = e.toString();
  //     notifyListeners();
  //     Navigator.pop(context);
  //     if (kDebugMode) {
  //       print("Error adding channel: ${e.toString()}");
  //     }
  //   }
  //
  //   return channelCreated;
  // }

  Future<dynamic> getPreviousChatDetails(String? chatRoomId) async {
    return FirebaseFirestore.instance
        .collection('channelRoom')
        .doc(chatRoomId)
        .collection('chats')
        .orderBy('time')
        .snapshots();
  }

  Future saveChannelInfoToUser(
    String channelID,
    String channelName,
    bool isCreator,
  ) async {
    return await userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("channels")
        .doc(channelID)
        .set({
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'channelId': channelID,
      'channelName': channelName,
      "isApproved": isCreator == true ? true : false,
      "isCreated": isCreator,
      "isBlocked": false,
      "createdAt": DateTime.now(),
    });
  }

  Future saveSubChannelInfoToUser(
      String subChannelID, String channelName, bool isCreator) async {
    return await userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(channels)
        .doc(selectedChannel.channelId)
        .collection(subChannel)
        .doc(subChannelID)
        .set({
      'userId': _firebaseAuth.currentUser!.uid,
      'subChannelId': subChannelID,
      'channelName': channelName,
      "isCreated": isCreator,
      "isApproved": isCreator == true ? true : false,
      "isBlocked": false,
      "createdAt": DateTime.now(),
    });
  }

  Future saveChannelName(String channelName, String channelId) async {
    return await channelNamesCollection
        .doc(channelName.toLowerCase())
        .set({'channelName': channelName, 'channelId': channelId});
  }

  Future saveSubChannelName(String childChannelName, String channelId) async {
    return await channelNamesCollection
        .doc(selectedChannel.channelName.toLowerCase())
        .collection('subChannel')
        .doc(channelId)
        .set({'channelName': childChannelName, 'channelId': channelId});
  }

  Future saveMemberInChannel(BuildContext context, String channelID,
      String channelName, bool isCreator, AuthenticationProvider auth) async {
    notifyListeners();
    return await channelsCollection
        .doc(channelID)
        .collection(isCreator == true ? "members" : "waitingRoom")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'isPushed': false,
      'isOnline': false,
      'isApproved': false,
      'userId': _firebaseAuth.currentUser!.uid,
      'username': auth.userInfo.userName,
      'userFullName': auth.userInfo.fullName,
      "isAdmin": isCreator,
      "isBlocked": false,
      'createdAt': DateTime.now()
    });
  }

  Future saveMemberInSubChannel(
      String subChannelID, bool isCreator, AuthenticationProvider auth) async {
    print(isCreator);
    return await channelsCollection
        .doc(selectedChannel.channelId)
        .collection('subChannel')
        .doc(subChannelID)
        .collection(isCreator == true ? "members" : "waitingRoom")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'isPushed': false,
      'isOnline': false,
      'isApproved': false,
      'userId': _firebaseAuth.currentUser!.uid,
      'username': auth.userInfo.userName,
      'userFullName': auth.userInfo.fullName,
      "isAdmin": isCreator,
      "isBlocked": false,
      'createdAt': DateTime.now()
    });
  }

  Future approveMemberToChannel({
    required String channelID,
    required String channelName,
    required String userId,
    required String userName,
    required String userFullName,
  }) async {
    try {
      await channelsCollection
          .doc(channelID)
          .collection("members")
          .doc(userId)
          .set({
        'isPushed': false,
        'isOnline': false,
        'userId': userId,
        'username': userName,
        'userFullName': userFullName,
        "isAdmin": false,
        "isBlocked": false,
        'createdAt': DateTime.now()
      }).then((value) async {
        await userCollection
            .doc(userId)
            .collection("channels")
            .doc(channelID)
            .update({"isApproved": true});
      });
    } catch (e) {
    } finally {
      FirebaseFirestore.instance
          .collection('channels')
          .doc(channelID)
          .collection("waitingRoom")
          .doc(userId)
          .delete();
    }
  }

  Future approveMemberToSubChannel({
    required String channelID,
    required String subChannelID,
    required String channelName,
    required String subChannelName,
    required String userId,
    required String userName,
    required String userFullName,
  }) async {
    try {
      await channelsCollection
          .doc(channelID)
          .collection("subChannel")
          .doc(subChannelID)
          .collection('members')
          .doc(userId)
          .set({
        'isPushed': false,
        'isOnline': false,
        'userId': userId,
        'username': userName,
        'userFullName': userFullName,
        "isAdmin": false,
        "isBlocked": false,
        'createdAt': DateTime.now()
      }).then((value) async {
        await userCollection
            .doc(userId)
            .collection("channels")
            .doc(channelID)
            .update({"isApproved": true});
      });
    } catch (e) {
    } finally {
      FirebaseFirestore.instance
          .collection('channels')
          .doc(channelID)
          .collection("waitingRoom")
          .doc(userId)
          .delete();
    }
  }

  Future pushAppointment({
    required String channelId,
    required int day,
    required int hour,
    required int minute,
    required int when,
    required int frequency,
    required String channelName,
    required String userId,
    required String userName,
  }) async {
    try {
      await appointmentsCollection
          .doc(channelId)
          .collection('active')
          .doc(userId)
          .set({
        'day': day,
        'hour': hour + 12,
        'minute': minute,
        'when': when,
        "frequency": frequency,
        'channelName': channelName,
        'channelId': channelId,
        "organiserName": userName,
        "userId": userId,
        "isDone": false,
        "isPending": true,
        'year': Jiffy().year,
        'month': Jiffy().month,
        'createdAt': DateTime.now()
      }).then((val) async {
        await appointmentsCollection.doc(userId).set({
          "userId": userId,
          'channelId': channelId,
          'channelName': channelName,
          "isCreated": true,
          "isBlocked": false,
          "isApproved": true,
          'createdAt': DateTime.now()
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getUserChannels(String userId) async {
    QuerySnapshot querySnapshot =
        await userCollection.doc(userId).collection("channels").get();
    _userChannels = querySnapshot.docs
        .map((doc) => UserChannelModel.fromSnapshot(doc))
        .toList();

    _userChannelCreated =
        _userChannels.where((channel) => channel.isCreated == true).toList();
    _userChannelsConnected =
        _userChannels.where((channel) => channel.isCreated == false).toList();

    if (kDebugMode) {
      print("Length of channels: ${_userChannels.length}");
    }
    if (kDebugMode) {
      print("Length of created channels: ${_userChannelCreated.length}");
    }
    if (kDebugMode) {
      print("Length of connected channels: ${_userChannelsConnected.length}");
    }

    notifyListeners();
  }

  Future<void> getChannelMembers(BuildContext context, String channelId) async {
    _isLoading = true;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => const LoadingIndicator());
    notifyListeners();
    try {
      QuerySnapshot querySnapshot =
          await channelsCollection.doc(channelId).collection("members").get();
      _channelMembers = querySnapshot.docs
          .map((doc) => ChannelMembersModel.fromSnapshot(doc))
          .toList();

      if (kDebugMode) {
        print("Length of channels: ${_channelMembers.length}");
      }

      Navigator.pop(context);
      _isLoading = false;
      openChannelMembersChats(context);

      notifyListeners();
    } catch (e) {
      _isLoading = false;
      Navigator.pop(context);
      notifyListeners();
      if (kDebugMode) {
        print("Error getting members: ${e.toString()}");
      }
    }
  }

  // Future<void> searchUserInSubChannelName(String username, fullName) async {
  //   try {
  //     DocumentSnapshot doc = await channelsCollection
  //         .doc(_selectedChannel?.channelId)
  //         .collection(subChannel)
  //         .doc(_selectedSubChannel?.subChannelId)
  //         .collection(members)
  //         .doc(FirebaseAuth.instance.currentUser?.uid)
  //         .get();
  //
  //     if (doc.exists) {
  //       print("Good to go");
  //     } else {
  //       await channelsCollection
  //           .doc(selectedChannel.channelId)
  //           .collection('subChannel')
  //           .doc(_selectedSubChannel?.subChannelId)
  //           .collection('members')
  //           .doc(FirebaseAuth.instance.currentUser!.uid)
  //           .set({
  //         'isPushed': false,
  //         'isOnline': false,
  //         'userId': _firebaseAuth.currentUser!.uid,
  //         'username': username,
  //         'userFullName': fullName,
  //         "isAdmin": false,
  //         'createdAt': DateTime.now()
  //       });
  //     }
  //   } catch (e) {
  //     // print("Error: ${e.toString()}");
  //
  //   }
  // }

  Future<void> getSubChannelMembers(BuildContext context, String mainChannelId,
      String subChannelId, AuthenticationProvider auth) async {
    _isLoading = true;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => const LoadingIndicator());
    notifyListeners();
    try {
      QuerySnapshot querySnapshot = await channelsCollection
          .doc(mainChannelId)
          .collection("subChannel")
          .doc(subChannelId)
          .collection("members")
          .get();
      _channelMembers = querySnapshot.docs
          .map((doc) => ChannelMembersModel.fromSnapshot(doc))
          .toList();

      if (kDebugMode) {
        print("Length of channel Members: ${_channelMembers.length}");
      }
      Navigator.pop(context);
      _isLoading = false;

      if (_channelMembers
          .map((e) => e.userId)
          .contains(_firebaseAuth.currentUser?.uid)) {
        openSubChannelMembersChats(context);
      } else {
        saveMemberInSubChannel(subChannelId, false, auth).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: ColorManager.redColor,
              content: CustomTextNoOverFlow(
                textColor: ColorManager.whiteColor,
                text:
                    'your request to join this sub-channel is yet to be approved by the admin',
              )));
        });

        print('not qualified');
      }

      notifyListeners();
    } catch (e) {
      _isLoading = false;
      Navigator.pop(context);
      notifyListeners();
      if (kDebugMode) {
        print("Error getting members: ${e.toString()}");
      }
    }
  }

  Future<List<SubChannelModel>> getChannelSubChannels(BuildContext context,
      String channelId, UserChannelModel mainChannel) async {
    _isLoadingSubChannels = true;
    print("The channel ID is: $channelId");
    // showDialog(
    //     barrierDismissible: false,
    //     context: context,
    //     builder: (BuildContext context) => const LoadingIndicator());
    _subChannels = [];
    notifyListeners();
    try {
      QuerySnapshot querySnapshot =
          await channelsCollection.doc(channelId).collection(subChannel).get();
      _subChannels = querySnapshot.docs
          .map((doc) => SubChannelModel.fromSnapshot(doc))
          .toList();
      if (_subChannels.isNotEmpty) {
        // If the list is not empty, insert the main channel at the index zero so to display in the view
        final mainChannelToAdd = SubChannelModel(
            subChannelId: mainChannel.channelId,
            subChannelName: mainChannel.channelName);
        _subChannels.insert(0, mainChannelToAdd);
      }
      print("Sub channels: ${_subChannels.length}");
      _isLoadingSubChannels = false;
      notifyListeners();
    } catch (e) {
      _isLoadingSubChannels = false;
      Navigator.pop(context);
      notifyListeners();
      if (kDebugMode) {
        print("Error getting members: ${e.toString()}");
      }
    }
    return _subChannels;
  }

  Future<void> recordSound() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await _mRecorder!.openRecorder();
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth |
              AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));

    _mRecorderInitialised = true;
    _isRecording = true;
    notifyListeners();

    Directory directory = await getApplicationDocumentsDirectory();
    _recordTime = DateTime.now().millisecondsSinceEpoch.toString();
    String filepath = directory.path + '/' + _recordTime + '.mp4';
    String encryptedFilePath = directory.path + '/' + "encryptedSound" + '.aes';

    _encryptedFilePath = encryptedFilePath;

    _mRecorder!.startRecorder(
      toFile: filepath,
      codec: Codec.aacMP4,
      audioSource: theSource,
    );
    notifyListeners();

    _filePath = filepath;
    notifyListeners();
  }

  Future stopRecord() async {
    await _mRecorder?.stopRecorder();
    notifyListeners();
    _isUploading = false;
    _isRecording = false;
    notifyListeners();
    return _filePath;
  }

  sendSound({required String user}) async {
    if (_mRecorder == null) return;
    //stop recording
    await _mRecorder!.stopRecorder();
    _isRecording = false;
    notifyListeners();

    try {
      FirebaseStorage firebaseStorage = FirebaseStorage.instance;
      _isSuccessful = true;
      await firebaseStorage
          .ref('records')
          .child(_selectedChannel!.channelId)
          .child(FirebaseAuth.instance.currentUser!.uid)
          .child(
              _filePath.substring(_filePath.lastIndexOf('/'), _filePath.length))
          .putFile(File(_filePath))
          .then((result) async {
        var url = await (result).ref.getDownloadURL();
        var uploadedUrl = url.toString();
        notifyListeners();
        cloudNakedURL = uploadedUrl;
        notifyListeners();
      });
    } on FirebaseException catch (e) {
      FirebaseStorage firebaseStorage = FirebaseStorage.instance;
      _isSuccessful = true;
      await firebaseStorage
          .ref('records')
          .child(_selectedChannel!.channelId)
          .child(FirebaseAuth.instance.currentUser!.uid)
          .child(
              _filePath.substring(_filePath.lastIndexOf('/'), _filePath.length))
          .putFile(File(_filePath))
          .then((result) async {
        var url = await (result).ref.getDownloadURL();
        var uploadedUrl = url.toString();
        notifyListeners();
        cloudNakedURL = uploadedUrl;
        notifyListeners();
      });
    } finally {
      if (_isSuccessful) {
        Map<String, dynamic> _lastMessageInfo = {
          'lastMessageTime': int.parse(_recordTime),
        };
        await updateLastMessageInfo(
            _lastMessageInfo, _selectedChannel!.channelId);

        await addMessage(
          _selectedChannel!.channelId,
          Message(
              record: cloudNakedURL,
              sendBy: user,
              time: int.parse(_recordTime),
              timeStamp: DateTime.now()),
        );
        if (kDebugMode) {
          print("Uploaded Successfully");
        }
      }
      _isUploading = false;
      notifyListeners();
    }

    // encryptFile().then((result) async {
    //   try {
    //     FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    //     _isSuccessful = true;
    //     await firebaseStorage
    //         .ref('records')
    //         .child(_selectedChannel!.channelId)
    //         .child(FirebaseAuth.instance.currentUser!.uid)
    //         .child(_encryptedFilePath.substring(
    //             _filePath.lastIndexOf('/'), _encryptedFilePath.length))
    //         .putFile(File(result.path))
    //         .then((result) async {
    //       var url = await (result).ref.getDownloadURL();
    //       var uploadedUrl = url.toString();
    //       notifyListeners();
    //       cloudNakedURL = uploadedUrl;
    //       notifyListeners();
    //     });
    //   } on FirebaseException catch (e) {
    //     _isSuccessful = false;
    //     _resMessage =
    //         "Could not send!', 'Error occurred while sending message, please check your connection.";
    //     if (kDebugMode) {
    //       print(e.toString());
    //     }
    //   } finally {
    //     if (_isSuccessful) {
    //       Map<String, dynamic> _lastMessageInfo = {
    //         'lastMessageTime': int.parse(_recordTime),
    //       };
    //       await updateLastMessageInfo(
    //           _lastMessageInfo, _selectedChannel!.channelId);
    //
    //       await addMessage(
    //         _selectedChannel!.channelId,
    //         Message(
    //             record: cloudNakedURL,
    //             sendBy: user,
    //             time: int.parse(_recordTime),
    //             timeStamp: DateTime.now()),
    //       );
    //       if (kDebugMode) {
    //         print("Uploaded Successfully");
    //       }
    //     }
    //     _isUploading = false;
    //     notifyListeners();
    //   }
    // });
  }

  sendSubChannelSound({required String user}) async {
    if (_mRecorder == null) return;
    //stop recording
    await _mRecorder!.stopRecorder();
    _isRecording = false;
    notifyListeners();

    try {
      FirebaseStorage firebaseStorage = FirebaseStorage.instance;
      _isSuccessful = true;
      await firebaseStorage
          .ref('records')
          .child(_selectedSubChannel!.subChannelId)
          .child(FirebaseAuth.instance.currentUser!.uid)
          .child(
              _filePath.substring(_filePath.lastIndexOf('/'), _filePath.length))
          .putFile(File(_filePath))
          .then((result) async {
        var url = await (result).ref.getDownloadURL();
        var uploadedUrl = url.toString();
        notifyListeners();
        cloudNakedURL = uploadedUrl;
        notifyListeners();
      });
    } on FirebaseException catch (e) {
      _isSuccessful = false;
      _resMessage =
          "Could not send!', 'Error occurred while sending message, please check your connection.";
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      if (_isSuccessful) {
        Map<String, dynamic> _lastMessageInfo = {
          'lastMessageTime': int.parse(_recordTime),
        };
        await updateLastSubChannelMessageInfo(
            _lastMessageInfo, _selectedSubChannel!.subChannelId);

        await addSubChannelMessage(
          _selectedSubChannel!.subChannelId,
          Message(
              record: cloudNakedURL,
              sendBy: user,
              time: int.parse(_recordTime),
              timeStamp: DateTime.now()),
        );
        if (kDebugMode) {
          print("Uploaded Successfully");
        }
      }
      _isUploading = false;
      notifyListeners();
    }

    // encryptFile().then((result) async {
    //   try {
    //     FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    //     _isSuccessful = true;
    //     await firebaseStorage
    //         .ref('records')
    //         .child(_selectedSubChannel!.subChannelId)
    //         .child(FirebaseAuth.instance.currentUser!.uid)
    //         .child(_encryptedFilePath.substring(
    //             _filePath.lastIndexOf('/'), _encryptedFilePath.length))
    //         .putFile(File(result.path))
    //         .then((result) async {
    //       var url = await (result).ref.getDownloadURL();
    //       var uploadedUrl = url.toString();
    //       notifyListeners();
    //       cloudNakedURL = uploadedUrl;
    //       notifyListeners();
    //     });
    //   } on FirebaseException catch (e) {
    //     _isSuccessful = false;
    //     _resMessage =
    //         "Could not send!', 'Error occurred while sending message, please check your connection.";
    //     if (kDebugMode) {
    //       print(e.toString());
    //     }
    //   } finally {
    //     if (_isSuccessful) {
    //       Map<String, dynamic> _lastMessageInfo = {
    //         'lastMessageTime': int.parse(_recordTime),
    //       };
    //       await updateLastSubChannelMessageInfo(
    //           _lastMessageInfo, _selectedSubChannel!.subChannelId);
    //
    //       await addSubChannelMessage(
    //         _selectedSubChannel!.subChannelId,
    //         Message(
    //             record: cloudNakedURL,
    //             sendBy: user,
    //             time: int.parse(_recordTime),
    //             timeStamp: DateTime.now()),
    //       );
    //       if (kDebugMode) {
    //         print("Uploaded Successfully");
    //       }
    //     }
    //     _isUploading = false;
    //     notifyListeners();
    //   }
    // });
  }

  // Future downloadEncryptedFile({required String url}) async {
  //   return await DefaultCacheManager().downloadFile(url);
  // }

  // encryptFile() async {
  //   Directory directory = await getApplicationDocumentsDirectory();
  //   String encryptedFilePath = directory.path + '/' + "encryptedSound" + '.aes';
  //
  //   _encryptedFilePath = encryptedFilePath;
  //
  //   FileCryptor fileCryptor = FileCryptor(
  //     key: encryptionKey,
  //     iv: 16,
  //     dir: _encryptedFilePath,
  //   );
  //   File encryptedFile = await fileCryptor.encrypt(
  //       inputFile: _filePath, outputFile: _encryptedFilePath);
  //   return encryptedFile.absolute;
  // }
  //
  // decryptFile({required encryptedFile}) async {
  //   _recordTime = DateTime.now().millisecondsSinceEpoch.toString();
  //   Directory directory = await getApplicationDocumentsDirectory();
  //   String decryptedFilePath = directory.path + '/' + _recordTime + '.mp4';
  //
  //   _decryptedFilePath = decryptedFilePath;
  //
  //   FileCryptor fileCryptor = FileCryptor(
  //     key: encryptionKey,
  //     iv: 16,
  //     dir: _decryptedFilePath,
  //   );
  //   File decryptedFile = await fileCryptor.decrypt(
  //       inputFile: encryptedFile, outputFile: _decryptedFilePath);
  //   return decryptedFile.absolute.path;
  // }

  deleteChannelPlayedSound({required String currentDocId}) {
    try {
      FirebaseFirestore.instance
          .collection('channelRoom')
          .doc(selectedChannel.channelId)
          .collection('chats')
          .doc(currentDocId)
          .delete();
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      if (kDebugMode) {
        print("Deleted Successfully");
      }
    }
  }

  deleteSubChannelPlayedSound({required String currentDocId}) {
    try {
      FirebaseFirestore.instance
          .collection('channelRoom')
          .doc(selectedSubChannel?.subChannelId)
          .collection('chats')
          .doc(currentDocId)
          .delete();
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e.message);
      }
    } finally {
      if (kDebugMode) {
        print("Deleted Successfully");
      }
    }
  }

  Future<void> updateLastMessageInfo(
      Map<String, dynamic> lastMessageInfo, String chatRoomId) async {
    firestore
        .collection('channelRoom')
        .doc(chatRoomId)
        .set(lastMessageInfo)
        .catchError((e) {
      debugPrint(e.toString());
    });
  }

  Future<void> updateLastSubChannelMessageInfo(
      Map<String, dynamic> lastMessageInfo, String chatRoomId) async {
    firestore
        .collection('channelRoom')
        .doc(chatRoomId)
        .set(lastMessageInfo)
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

  Future<void> addSubChannelMessage(String chatRoomId, chatMessageData) async {
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
      getUserChats(userName).then((snapshots) {
        _chatRooms = snapshots;
        debugPrint('Name: $userName');
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<dynamic> getUserChats(String currentUser) async {
    return FirebaseFirestore.instance
        .collection('chatRoom')
        .where('users', arrayContains: currentUser)
        .snapshots();
  }

  Future<void> sendChannelChat(String userName, chatMessage) async {
    FirebaseFirestore.instance
        .collection('channels')
        .doc(selectedChannel.channelId)
        .collection('chats')
        .doc()
        .set({
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'userName': userName,
      'message': chatMessage,
      "createdAt": DateTime.now(),
    }).catchError((e) {
      debugPrint(e.toString());
    });
  }

  void clear() {
    _resMessage = "";
    // _isLoading = false;
    notifyListeners();
  }
}
