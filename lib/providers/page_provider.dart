import 'package:flutter/material.dart';

class PageProvider with ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  int _currentCategoryIndex = -1;

  int get currentCategoryIndex => _currentCategoryIndex;

  int _prevCategoryIndex = -1;

  int get prevCategoryIndex => _prevCategoryIndex;

  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  set currentCategoryIndex(int index) {
    _prevCategoryIndex = _currentCategoryIndex;
    _currentCategoryIndex = index;
    notifyListeners();
  }
}
