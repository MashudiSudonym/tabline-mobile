import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
            SizedBox(
              height: MediaQuery.of(context).size.height / 100 * 3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 100 * 15,
                  height: MediaQuery.of(context).size.height / 100 * 15,
                  child: MaterialButton(
                    shape: CircleBorder(
                      side: BorderSide(
                        width: 0,
                        style: BorderStyle.solid,
                        color: Colors.green,
                      ),
                    ),
                    elevation: 4.0,
                    color: Colors.green,
                    child: FaIcon(
                      FontAwesomeIcons.phoneAlt,
                      size: MediaQuery.of(context).size.height / 100 * 3,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (widget.phone != '-') {
                        launch('tel:${widget.phone}');
                      } else {
                        _scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: Text('Tidak ada nomor teleponnya'),
                          ),
                        );
                      }
                    },
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 100 * 15,
                  height: MediaQuery.of(context).size.height / 100 * 15,
                  child: MaterialButton(
                    shape: CircleBorder(
                      side: BorderSide(
                        width: 0,
                        style: BorderStyle.solid,
                        color: Colors.blueAccent,
                      ),
                    ),
                    elevation: 4.0,
                    color: Colors.blueAccent,
                    child: FaIcon(
                      FontAwesomeIcons.sms,
                      size: MediaQuery.of(context).size.height / 100 * 3,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (widget.phone != '-') {
                        launch('sms:${widget.phone}');
                      } else {
                        _scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: Text('Tidak ada nomor teleponnya'),
                          ),
                        );
                      }
                    },
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 100 * 15,
                  height: MediaQuery.of(context).size.height / 100 * 15,
                  child: MaterialButton(
                    shape: CircleBorder(
                      side: BorderSide(
                        width: 0,
                        style: BorderStyle.solid,
                        color: Colors.white,
                      ),
                    ),
                    elevation: 4.0,
                    color: Colors.white,
                    child: FaIcon(
                      FontAwesomeIcons.shareAlt,
                      size: MediaQuery.of(context).size.height / 100 * 3,
                      color: Colors.black87,
                    ),
                    onPressed: () {
                      Share.share(
                          'hei, tambal ban dekat sini ada di ${widget.name}, ${widget.address}.\nAnda bisa menghubunginya di ${widget.phone}.');
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
