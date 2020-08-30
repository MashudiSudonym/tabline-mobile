// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';

import 'screens/main_screen.dart';
import 'screens/splash_screen.dart';

class Routes {
  static const String splashScreen = '/';
  static const String mainScreen = '/main-screen';
  static const all = <String>{
    splashScreen,
    mainScreen,
  };
}

class Router extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.splashScreen, page: SplashScreen),
    RouteDef(Routes.mainScreen, page: MainScreen),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    SplashScreen: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => SplashScreen(),
        settings: data,
      );
    },
    MainScreen: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => MainScreen(),
        settings: data,
      );
    },
  };
}
