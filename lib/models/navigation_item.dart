import 'package:flutter/material.dart';

class NavigationItem {
  final int id;
  final String icon;
  final Widget destination;

  NavigationItem({this.id, this.icon, this.destination});

  // if there is no destination
  bool destinationChecker() {
    if (destination != null) {
      return true;
    }
    return false;
  }
}
