import 'package:flutter/material.dart';
import '../models/model.dart';

class WalkProvider with ChangeNotifier {
  final List<Walk> _walks = [];
  bool _isDarkMode = false;

  List<Walk> get walks => [..._walks];
  bool get isDarkMode => _isDarkMode;

  void addWalk(Walk walk) {
    _walks.add(walk);
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void updateWalkPhoto(String id, String photoPath) {
    final index = _walks.indexWhere((w) => w.id == id);
    if (index >= 0) {
      _walks[index].photoPath = photoPath;
      notifyListeners(); 
    }
  }
}