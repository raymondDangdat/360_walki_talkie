import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../resources/value_manager.dart';

class MessageModel {
  final String userName;
  final String userProfile;
  final bool isOnline;
  final List<Message> messages;
  final int noOfUnreadMessages;
  final bool isPinned;

  MessageModel({
    required this.messages,
    required this.userName,
    required this.isOnline,
    required this.userProfile,
    required this.noOfUnreadMessages,
    this.isPinned = false,
  });
}

class Message {
  final String message, senderName;
  final String time;
  final bool isSender;
  final String type;

  Message( {
    required this.message,
   required this.senderName,
    required this.isSender,
    required this.time,
    required this.type,
  });
}

List<MessageModel> messages = [
  MessageModel(
      messages: [
        Message(
            type: "text",
          senderName: 'Wiki Michael',
            message: "Hello, I want to send you this message",
            isSender: false,
            time: '11:10am', ),
        Message(
            type: "text",
            senderName: 'Kingsley Michael',
            message:
            "Arcu diam tincidunt amet faucibus interdum. Libero at id nam sed risus. Ornare quisque magna mollis montes, laoreet ultrices pretium proin. Hac pretium lacus nulla consectetur ac elementum facilisi morbi arcu. Id ornare magna fringilla morbi integer felis, tortor. ",
            isSender: true,
            time: '11:10am'),
        Message(
            type: "file",
            senderName: 'Clement Bako',
            message:
            "Arcu diam tincidunt amet faucibus interdum. Libero at id nam sed risus. Ornare quisque magna mollis montes, laoreet ultrices pretium proin. Hac pretium lacus nulla consectetur ac elementum facilisi morbi arcu. Id ornare magna fringilla morbi integer felis, tortor. ",
            isSender: true,
            time: '11:10am'),
        Message(
            type: "url",
            senderName: 'Wiki Michael',
            message:
            "Arcu diam tincidunt amet faucibus interdum. Libero at id nam sed risus. Ornare quisque magna mollis montes, laoreet ultrices pretium proin. Hac pretium lacus nulla consectetur ac elementum facilisi morbi arcu. Id ornare magna fringilla morbi integer felis, tortor. ",
            isSender: true,
            time: '11:10am'),
      ],
      noOfUnreadMessages: 0,
      userName: "Plex64",
      isOnline: true,
      userProfile: "assets/images/plex64.png"),
  MessageModel(
      messages: [
        Message(
            senderName: 'Clement Michael',
            type: 'text',
            message: "Alright thanks",
            isSender: true,
            time: '11:10am'),
        Message(
            senderName: 'Wiki Michael',
            type: "text",
            message: "Alright thanks. ",
            isSender: false,
            time: '11:10am'),
      ],
      userName: "Jidikoso",
      noOfUnreadMessages: 3,
      isOnline: true,
      userProfile: "assets/images/jidikoso.png"),
  MessageModel(
      messages: [
        Message(
            senderName: 'Wiki John',
            type: "text",
            message: "Hello, I want to send you this message",
            isSender: false,
            time: '11:10am'),
        Message(
            senderName: 'Wiki Michael',
            type: "text",
            message:
            "Arcu diam tincidunt amet faucibus interdum. Libero at id nam sed risus. Ornare quisque magna mollis montes, laoreet ultrices pretium proin. Hac pretium lacus nulla consectetur ac elementum facilisi morbi arcu. Id ornare magna fringilla morbi integer felis, tortor. ",
            isSender: true,
            time: '11:10am'),
        Message(
            type: "file",
            senderName: 'Wiki Michael',
            message:
            "Arcu diam tincidunt amet faucibus interdum. Libero at id nam sed risus. Ornare quisque magna mollis montes, laoreet ultrices pretium proin. Hac pretium lacus nulla consectetur ac elementum facilisi morbi arcu. Id ornare magna fringilla morbi integer felis, tortor. ",
            isSender: true,
            time: '11:10am'),
        Message(
            senderName: 'Wiki Michael',
            type: "url",
            message:
            "Arcu diam tincidunt amet faucibus interdum. Libero at id nam sed risus. Ornare quisque magna mollis montes, laoreet ultrices pretium proin. Hac pretium lacus nulla consectetur ac elementum facilisi morbi arcu. Id ornare magna fringilla morbi integer felis, tortor. ",
            isSender: true,
            time: '11:10am'),
      ],
      noOfUnreadMessages: 0,
      userName: "druids",
      isOnline: false,
      userProfile: "assets/images/druids.png"),
  MessageModel(
      messages: [
        Message(
            senderName: 'John Michael',
            type: 'text',
            message: "Alright thanks",
            isSender: true,
            time: '11:10am'),
        Message(
            type: "text",
            senderName: 'Hone Michael',
            message:
            "Arcu diam tincidunt amet faucibus interdum. Libero at id nam sed risus. Ornare quisque magna mollis montes, laoreet ultrices pretium proin. Hac pretium lacus nulla consectetur ac elementum facilisi morbi arcu. Id ornare magna fringilla morbi integer felis, tortor. ",
            isSender: false,
            time: '11:10am'),
      ],
      userName: "yutu_1",
      noOfUnreadMessages: 3,
      isOnline: true,
      userProfile: "assets/images/yutu.png"),
  MessageModel(
      messages: [
        Message(
            senderName: 'John Doe Michael',
            type: "text",
            message: "Hello, I want to send you this message",
            isSender: false,
            time: '11:10am'),
        Message(
            type: "text",
            senderName: 'Wiki Michael',
            message:
            "Arcu diam tincidunt amet faucibus interdum. Libero at id nam sed risus. Ornare quisque magna mollis montes, laoreet ultrices pretium proin. Hac pretium lacus nulla consectetur ac elementum facilisi morbi arcu. Id ornare magna fringilla morbi integer felis, tortor. ",
            isSender: true,
            time: '11:10am'),
        Message(
            senderName: 'Wiki Michael',
            type: "file",
            message:
            "Arcu diam tincidunt amet faucibus interdum. Libero at id nam sed risus. Ornare quisque magna mollis montes, laoreet ultrices pretium proin. Hac pretium lacus nulla consectetur ac elementum facilisi morbi arcu. Id ornare magna fringilla morbi integer felis, tortor. ",
            isSender: true,
            time: '11:10am'),
        Message(
            senderName: 'Michael',
            type: "url",
            message:
            "Arcu diam tincidunt amet faucibus interdum. Libero at id nam sed risus. Ornare quisque magna mollis montes, laoreet ultrices pretium proin. Hac pretium lacus nulla consectetur ac elementum facilisi morbi arcu. Id ornare magna fringilla morbi integer felis, tortor. ",
            isSender: true,
            time: '11:10am'),
      ],
      noOfUnreadMessages: 0,
      userName: "Plex64",
      isOnline: true,
      userProfile: "assets/images/plex64.png"),
  MessageModel(
      messages: [
        Message(
            senderName: 'Wiki Michael',
            type: 'text',
            message: "Alright thanks",
            isSender: true,
            time: '11:10am'),
        Message(
            senderName: 'Wiki Michael',
            type: "text",
            message:
            "Arcu diam tincidunt amet faucibus interdum. Libero at id nam sed risus. Ornare quisque magna mollis montes, laoreet ultrices pretium proin. Hac pretium lacus nulla consectetur ac elementum facilisi morbi arcu. Id ornare magna fringilla morbi integer felis, tortor. ",
            isSender: false,
            time: '11:10am'),
      ],
      userName: "Plex64",
      noOfUnreadMessages: 3,
      isOnline: true,
      userProfile: "assets/images/plex64.png"),
];
