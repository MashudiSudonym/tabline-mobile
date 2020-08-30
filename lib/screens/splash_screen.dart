import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tabline/router.gr.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer _timer;

  _removeScreen() {
    return _timer = Timer(
      Duration(seconds: 2),
      () async {
        ExtendedNavigator.of(context).replace(Routes.mainScreen);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _removeScreen();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SvgPicture.asset(
                'assets/svg/icons.svg',
                height: MediaQuery.of(context).size.height / 100 * 35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
