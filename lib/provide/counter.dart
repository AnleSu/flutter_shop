import 'package:flutter/material.dart';

class Counter with ChangeNotifier {
  int value = 0;
  increment() {
    value++;
    notifyListeners();// 有变化 通知听众 局部刷新widget
  }
}