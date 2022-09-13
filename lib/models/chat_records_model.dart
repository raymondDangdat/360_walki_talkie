import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRecordsModel {
  dynamic id;
  dynamic duration;
  dynamic record;
  dynamic sendBy;
  dynamic time;
  DateTime timeStamp;

  ChatRecordsModel({
    required this.id,
    required this.duration,
    required this.record,
    required this.sendBy,
    required this.time,
    required this.timeStamp,
  });

  factory ChatRecordsModel.fromSnapshot(DocumentSnapshot doc) {
    return ChatRecordsModel(
        id: doc.id,
        duration: doc['duration'],
        record: doc['record'],
        sendBy: doc['sendBy'],
        time: doc['time'],
        timeStamp: doc['timeStamp'].toDate());
  }
}
