import 'package:flutter/material.dart';

class CounterProvider extends ChangeNotifier {

  int _counter = 0;
  int get counter => _counter;

  counterUp() {
    _counter++;
    notifyListeners();
  }

  counterDown() {
    _counter--;
    notifyListeners();
  }

}