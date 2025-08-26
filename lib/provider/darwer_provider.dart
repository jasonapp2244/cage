import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter/material.dart';

class DrawerControllerProvider extends ChangeNotifier {
  final AdvancedDrawerController _controller = AdvancedDrawerController();

  AdvancedDrawerController get controller => _controller;

  void showDrawer() {
    _controller.showDrawer();
    notifyListeners();
  }

  void hideDrawer() {
    _controller.hideDrawer();
    notifyListeners();
  }

  void toggleDrawer() {
    _controller.toggleDrawer();
    notifyListeners();
  }
}