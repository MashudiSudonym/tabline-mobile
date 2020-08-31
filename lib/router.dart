import 'package:auto_route/auto_route_annotations.dart';
import 'package:tabline/screens/detail_screen.dart';
import 'package:tabline/screens/main_screen.dart';
import 'package:tabline/screens/splash_screen.dart';

@CupertinoAutoRouter(
  routes: <AutoRoute>[
    CupertinoRoute(page: SplashScreen, initial: true),
    CupertinoRoute(page: MainScreen),
    CupertinoRoute(page: DetailScreen),
  ],
)
class $Router {}
