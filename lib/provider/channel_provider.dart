import 'dart:io';
import 'dart:typed_data';
import 'package:audio_session/audio_session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_cryptor/file_cryptor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:walkie_talkie_360/provider/authentication_provider.dart';
import 'package:walkie_talkie_360/resources/navigation_utils.dart';
import 'package:walkie_talkie_360/views/create_brand_new_channel/models/channel_members_model.dart';
import 'package:walkie_talkie_360/views/create_brand_new_channel/models/user_channel_model.dart';
import '../models/message.dart';
import '../resources/constanst.dart';
import '../service/abstracts/audio_player_service.dart';
import '../service/abstracts/storage_service.dart';
import '../views/channel_users_list_and_chats/channel_members_chats.dart';
import '../widgets/loading.dart';

import 'package:random_string/random_string.dart';

class ChannelProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  ///Setter
  bool _isLoading = false;
  String _resMessage = '';
  List<UserChannelModel> _userChannels = [];
  UserChannelModel? _selectedChannel;
  List<UserChannelModel> _userChannelCreated = [];
  List<UserChannelModel> _userChannelsConnected = [];

  List<ChannelMembersModel> _channelMembers = [];

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
      if (kDebugMode) {
        print("Error creating channel: ${e.toString()}");
      }
    }

    return channelCreated;
  }

  Future<bool> createChannelFromChannelName(
    BuildContext context,
    String channelName,
    String channelId,
    AuthenticationProvider auth,
  ) async {
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
      if (kDebugMode) {
        print("Error adding channel: ${e.toString()}");
      }
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

  Future saveChannelInfoToUser(
      String channelID, String channelName, bool isCreator) async {
    return await userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("channels")
        .doc(channelID)
        .set({
      'userId': _firebaseAuth.currentUser!.uid,
      'channelId': channelID,
      'channelName': channelName,
      "isCreated": isCreator,
    });
  }

  Future saveChannelName(String channelName, String channelId) async {
    return await channelNamesCollection
        .doc(channelName.toLowerCase())
        .set({'channelName': channelName, 'channelId': channelId});
  }

  Future saveMemberInChannel(String channelID, String channelName,
      bool isCreator, AuthenticationProvider auth) async {
    return await channelsCollection
        .doc(channelID)
        .collection("members")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'isPushed': false,
      'isOnline': false,
      'userId': _firebaseAuth.currentUser!.uid,
      'username': auth.userInfo.userName,
      'userFullName': auth.userInfo.fullName,
      "isAdmin": isCreator,
    });
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

    encryptFile().then((result) async {
      try {
        FirebaseStorage firebaseStorage = FirebaseStorage.instance;
        _isSuccessful = true;
        await firebaseStorage
            .ref('records')
            .child(_selectedChannel!.channelId)
            .child(FirebaseAuth.instance.currentUser!.uid)
            .child(_encryptedFilePath.substring(
                _filePath.lastIndexOf('/'), _encryptedFilePath.length))
            .putFile(File(result.path))
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
    });
  }

  Future downloadEncryptedFile({required String url}) async {
    return await DefaultCacheManager().downloadFile(url);
  }

  encryptFile() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String encryptedFilePath = directory.path + '/' + "encryptedSound" + '.aes';

    _encryptedFilePath = encryptedFilePath;

    FileCryptor fileCryptor = FileCryptor(
      key: encryptionKey,
      iv: 16,
      dir: _encryptedFilePath,
    );
    File encryptedFile = await fileCryptor.encrypt(
        inputFile: _filePath, outputFile: _encryptedFilePath);
    return encryptedFile.absolute;
  }

  decryptFile({required encryptedFile}) async {
    _recordTime = DateTime.now().millisecondsSinceEpoch.toString();
    Directory directory = await getApplicationDocumentsDirectory();
    String decryptedFilePath = directory.path + '/' + _recordTime + '.mp4';

    _decryptedFilePath = decryptedFilePath;

    FileCryptor fileCryptor = FileCryptor(
      key: encryptionKey,
      iv: 16,
      dir: _decryptedFilePath,
    );
    File decryptedFile = await fileCryptor.decrypt(
        inputFile: encryptedFile, outputFile: _decryptedFilePath);
    return decryptedFile.absolute.path;
  }

  deletePlayedSound({required String currentDocId}) {
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

  void clear() {
    _resMessage = "";
    // _isLoading = false;
    notifyListeners();
  }
}
