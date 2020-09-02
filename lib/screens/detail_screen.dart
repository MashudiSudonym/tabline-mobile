import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:share/share.dart';
import 'package:tabline/utils.dart';
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
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kInitialPositiion = const CameraPosition(
    target: LatLng(-6.649179, 110.707172),
    zoom: 18.0,
  );

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Position _currentPosition;
  double _distance;
  String _resultDistance;
  Set<Marker> _markers = Set();
  Marker _marker;

  @override
  void initState() {
    super.initState();
    _getCurrentLocationAndDistance();
    _animateCameraToLocation();
    _addMarker();
  }

  void _animateCameraToLocation() async {
    final GoogleMapController controller = await _controller.future;

    setState(() {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(widget.latitude, widget.longitude),
            zoom: 15.0,
          ),
        ),
      );
    });
  }

  void _addMarker() async {
    final _markerIcon = await getBytesFromAsset('assets/png/tire.png', 80);

    _marker = Marker(
      flat: true,
      markerId: MarkerId(widget.name),
      position: LatLng(widget.latitude, widget.longitude),
      icon: BitmapDescriptor.fromBytes(_markerIcon),
      infoWindow: InfoWindow(
        title: widget.name,
        snippet: widget.address,
      ),
    );

    setState(() {
      _markers.add(_marker);
    });
  }

  Future<void> _getCurrentLocationAndDistance() async {
    Timer(Duration(seconds: 1), () async {
      await getCurrentPosition(
              desiredAccuracy: LocationAccuracy.bestForNavigation)
          .then((Position position) {
        setState(() {
          _currentPosition = position;
        });
      }).catchError((e) {
        print(e);
      });

      _distance = GeolocatorPlatform.distanceBetween(
        _currentPosition.latitude,
        _currentPosition.longitude,
        widget.latitude,
        widget.longitude,
      );

      _resultDistance = (_distance / 1000).toStringAsFixed(1);
    });
  }

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
              height: MediaQuery.of(context).size.height / 100 * 1,
            ),
            Text(
              widget.phone,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width / 100 * 3.8,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 100 * 1,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width / 100 * 5,
                right: MediaQuery.of(context).size.width / 100 * 5,
              ),
              child: Text(
                'Lokasi Tambal Ban berada di $_resultDistance KM dari tempat anda sekarang',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 100 * 3.8,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 100 * 5,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width / 100 * 7,
                right: MediaQuery.of(context).size.width / 100 * 7,
              ),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.width / 100 * 50,
                color: Colors.teal,
                child: GoogleMap(
                  initialCameraPosition: _kInitialPositiion,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: false,
                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                  compassEnabled: true,
                  markers: _markers,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 100 * 1,
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
                        color: Colors.white,
                      ),
                    ),
                    elevation: 4.0,
                    color: Colors.white,
                    child: FaIcon(
                      FontAwesomeIcons.mapMarkedAlt,
                      size: MediaQuery.of(context).size.height / 100 * 3,
                      color: Colors.redAccent,
                    ),
                    onPressed: () async {
                      final availableMap = await MapLauncher.installedMaps;
                      await availableMap.first.showMarker(
                        coords: Coords(widget.latitude, widget.longitude),
                        title: widget.name,
                        description: "Location of ${widget.name}",
                      );
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
