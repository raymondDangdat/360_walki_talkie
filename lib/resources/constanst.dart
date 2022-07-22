import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

var moneyFormat = NumberFormat('#,###,000');
final CollectionReference registeredUserNamesCollection = FirebaseFirestore.instance.collection('userNames');
final CollectionReference channelsCollection = FirebaseFirestore.instance.collection('channels');
final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');