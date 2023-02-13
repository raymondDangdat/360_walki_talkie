import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

const String showOnBoarding = "showOnBoarding";
const String encryptionKey = "TALK1234567890123456789012345678";
var moneyFormat = NumberFormat('#,###,000');
final CollectionReference registeredUserNamesCollection = FirebaseFirestore.instance.collection('userNames');
final CollectionReference channelsCollection = FirebaseFirestore.instance.collection('channels');
final CollectionReference appointmentsCollection = FirebaseFirestore.instance.collection('appointments');
final CollectionReference subChannelsCollection = FirebaseFirestore.instance.collection('sub-channels');
final CollectionReference subChannelCollection = FirebaseFirestore.instance.collection('subChannel');
final CollectionReference channelNamesCollection = FirebaseFirestore.instance.collection('channelNames');
final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

const String channels = "channels";
const String subChannel = "subChannel";
const String members = "members";
const String isOnline = "isOnline";
