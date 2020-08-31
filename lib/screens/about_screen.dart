import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tentang Tabline',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 100 * 20,
            ),
            Center(
              child: SvgPicture.asset(
                'assets/svg/icons.svg',
                height: MediaQuery.of(context).size.height / 100 * 25,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.height / 100 * 5,
                right: MediaQuery.of(context).size.height / 100 * 5,
              ),
              child: Center(
                child: Text(
                  'Tabline (Tambal Ban Online) merupakan aplikasi yang memberikan informasi tentang lokasi-lokasi tambal ban terdekat dari lokasi anda.',
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
