import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:walkie_talkie_360/models/local_user_model.dart';
import '../resources/constanst.dart';
import '../views/create_brand_new_channel/models/user_channel_model.dart';
import '../widgets/loading.dart';


class AuthenticationProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  List<UserChannelModel> _userChannels = [];
  List<UserChannelModel> _userChannelCreated = [];
  List<UserChannelModel> _userChannelsConnected = [];




  ///Setter
  bool _isLoading = false;
  String _resMessage = '';
  LocalUserModel? _userInfo;

  ///Getter
  bool get isLoading => _isLoading;
  String get resMessage => _resMessage;
  LocalUserModel get userInfo => _userInfo!;

  List<UserChannelModel> get userChannels => _userChannels;
  List<UserChannelModel> get userChannelsCreated => _userChannelCreated;
  List<UserChannelModel> get userChannelsConnected => _userChannelsConnected;


  //Login
  void loginAgent({
    required String email,
    required String password,
    required BuildContext context,
    required bool isAgent,
  }) async {
    _isLoading = true;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => const LoadingIndicator());
    notifyListeners();
    try {

    } on SocketException catch (_) {
      _isLoading = false;
      _resMessage = "Internet connection is not available`";
      notifyListeners();
      Navigator.pop(context);
    } catch (e) {
      _isLoading = false;
      _resMessage = "Please try again`";
      notifyListeners();
      Navigator.pop(context);
      print("exception: $e");
    }
  }


  Future<User?> createUserWithEmailAndPassword({required BuildContext context,
    required String email,
    required String password,
    required String fullName,
    required String userName,
    required String phoneNumber,
  }) async {
    _isLoading = true;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => const LoadingIndicator());
    notifyListeners();


    User? user;

      try {
        final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        user =  userCredential.user;

        print("User value: $user");

        if(user != null){
          await saveUserName(userName);
          await updateUserData(fullName, userName, email, phoneNumber);

        }else{
          _isLoading = false;
          _resMessage = "Something went wrong";
          notifyListeners();
          Navigator.pop(context);
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          _isLoading = false;
          _resMessage = "Weak Password";
          notifyListeners();
          Navigator.pop(context);
        } else if (e.code == 'email-already-in-use') {
          _isLoading = false;
          _resMessage = "Email Already Exist";
          notifyListeners();
          Navigator.pop(context);
        } else {
        }
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
        print("Error on sign up: ${e.toString()}");
      }

      return user;
  }


  Future updateUserData(String fullName, String userName, String email, phoneNumber) async{
    return await userCollection.doc(_firebaseAuth.currentUser!.uid).set({
      'fullName' : fullName,
      'userName' : userName,
      'email' : email,
      'phoneNumber': phoneNumber,
      'userId' : _firebaseAuth.currentUser!.uid,
    });
  }

  Future saveUserName(String userName) async{
    return await registeredUserNamesCollection.doc(userName).set({
      'userName' : userName,
      'userId' : _firebaseAuth.currentUser!.uid,
    });
  }


  Future<User?> signInUserWithEmailAndPassword({required BuildContext context,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => const LoadingIndicator());
    notifyListeners();
    // print("Email and password in the method: $email $password");
    User? user;

    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user =  userCredential.user;

      // print("User value: $user");

      if(user != null){
      //  User logged in successfully
        await getUserDetail(user.uid);
        await getUserChannels(user.uid);

      }else{
        _isLoading = false;
        _resMessage = "Something went wrong";
        notifyListeners();
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _isLoading = false;
        _resMessage = "Try sign up";
        notifyListeners();
        Navigator.pop(context);
      } else if (e.code == 'wrong-password') {
        _isLoading = false;
        _resMessage = "Wrong credentials";
        notifyListeners();
        Navigator.pop(context);
      } else {
      }
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
      print("Error on sign up: ${e.toString()}");
    }

    return user;
  }


  Future<void> getUserDetail(String userId) async{
    DocumentSnapshot doc = await userCollection.doc(userId).get();
    if(doc.exists){
      _userInfo = LocalUserModel.fromDocument(doc);
      print("User info fetched");
      notifyListeners();
    }else{
      _resMessage = "no user info";
      notifyListeners();
    }
  }



  Future<void> getUserChannels(String userId) async{
    print("User ID $userId");
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
