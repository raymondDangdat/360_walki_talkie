import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRecordsModel {
  dynamic id;
  dynamic isPushed;
  dynamic record;
  dynamic sendBy;
  dynamic time;
  DateTime timeStamp;

  ChatRecordsModel({
    required this.id,
    required this.isPushed,
    required this.record,
    required this.sendBy,
    required this.time,
    required this.timeStamp,
  });

  factory ChatRecordsModel.fromSnapshot(DocumentSnapshot doc) {
    return ChatRecordsModel(
        id: doc.id,
        isPushed: doc['isPushed'],
        record: doc['record'],
        sendBy: doc['sendBy'],
        time: doc['time'],
        timeStamp: doc['timeStamp'].toDate());
  }
}
