class Message {
  String record;
  int duration;
  String sendBy;
  int time;
  DateTime timeStamp;


  Message({required this.record,  required this.duration, required this.sendBy, required this.time, required this.timeStamp});

  Map<String, dynamic> toMap() {
    return {'record': record, 'duration': duration, 'sendBy': sendBy, 'time': time, 'timeStamp': timeStamp};
  }
}
