import 'package:flutter/material.dart';

class CodeTypeProvider extends ChangeNotifier {
  bool isQr = false;

  void toggleCodeType() {
    isQr = !isQr;
    notifyListeners();
  }
}
