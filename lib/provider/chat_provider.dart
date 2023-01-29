import 'package:flutter/material.dart';

import '../models/chat_model.dart';

class ChatProvider extends ChangeNotifier {


  MessageModel? _selectedMessage;
  MessageModel? get selectedMessage => _selectedMessage!;


  void changeSelectedMessage(MessageModel newMessage){
    _selectedMessage = messages[3];
    print("message changed!");
    notifyListeners();
  }

}