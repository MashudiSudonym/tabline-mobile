import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final String name;
  final String address;
  final String phone;
  final double latitude;
  final double longitude;

  DetailScreen({
    this.name,
    this.address,
    this.phone,
    this.latitude,
    this.longitude,
  });

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.name,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 100 * 5,
            ),
            Center(
              child: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image(
                    image: AssetImage('assets/jpg/gambar-tb.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 100 * 2,
            ),
            Text(
              widget.name,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width / 100 * 6,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 100 * 1,
            ),
            Text(
              widget.address,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width / 100 * 3.8,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
