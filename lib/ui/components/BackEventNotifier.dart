import 'package:flutter/cupertino.dart';

class BackEventNotifire extends ChangeNotifier {
  bool isBack = true;
  bool get getIsBack => isBack;
  void add(bool value) {
    notifyListeners();
  }
}