class Message {
  bool isPushed;
  String record;
  String sendBy;
  int time;
  DateTime timeStamp;

  Message(
      {required this.isPushed,
      required this.record,
      required this.sendBy,
      required this.time,
      required this.timeStamp});

  Map<String, dynamic> toMap() {
    return {
      'isPushed': isPushed,
      'record': record,
      'sendBy': sendBy,
      'time': time,
      'timeStamp': timeStamp
    };
  }
}
