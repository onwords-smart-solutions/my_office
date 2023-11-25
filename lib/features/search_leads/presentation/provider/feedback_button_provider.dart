import 'package:flutter/cupertino.dart';

class FeedbackButtonProvider extends ChangeNotifier{

  final Map<String, bool> _buttonVisible = {};

  Map<String, bool> get  buttonVisible => _buttonVisible;

  set buttonVisible(Map<String, bool> hideButton){
    _buttonVisible.addAll(hideButton);
    notifyListeners();
  }
}