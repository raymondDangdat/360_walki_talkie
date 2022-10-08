class Message {
  String record;
  String sendBy;
  int time;
  DateTime timeStamp;

  Message(
      {required this.record,
      required this.sendBy,
      required this.time,
      required this.timeStamp});

  Map<String, dynamic> toMap() {
    return {
      'record': record,
      'sendBy': sendBy,
      'time': time,
      'timeStamp': timeStamp
    };
  }
}
