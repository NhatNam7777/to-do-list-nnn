import 'package:flutter/material.dart';

class WantTakeDataFrDetail extends ChangeNotifier {
  bool _actionDone = true;

  bool get actionDone => _actionDone;

  void setActionDone(bool value) {
    _actionDone = value;
    notifyListeners();
  }
}

class DelCurrentTaskAndReplaceByNextTask extends ChangeNotifier {
  bool _actionDone = false;

  bool get actionDone => _actionDone;

  void setActionDone(bool value) {
    _actionDone = value;
    notifyListeners();
  }
}
