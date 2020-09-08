import 'package:auto_route/auto_route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tabline/router.gr.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
                "Something went wrong during initalization: ${snapshot.error}"),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return buildMaterialApp();
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }

  MaterialApp buildMaterialApp() {
    return MaterialApp(
      title: 'Tabline',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.black,
          elevation: 0,
        ),
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: "Poppins",
      ),
      builder: ExtendedNavigator.builder<Router>(
        router: Router(),
      ),
    );
  }
}
