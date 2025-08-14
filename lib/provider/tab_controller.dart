import 'package:flutter/widgets.dart';

class TabProvider extends ChangeNotifier {
  int _currentindex = 0;

  int get currentIndex => _currentindex;

  void updateIndex(int index) {
    _currentindex = index;
    notifyListeners();
  }
}
