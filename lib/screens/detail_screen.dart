import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:map_launcher/map_launcher.dart';
import 'package:share/share.dart';
import 'package:tabline/data/data.dart';
import 'package:tabline/models/locations.dart';
import 'package:tabline/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supercharged/supercharged.dart';

class DetailScreen extends StatefulWidget {
  final String uid;

  DetailScreen({this.uid});

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
  String _name = '-';
  String _address = '-';
  String _phone = '-';
  double _latitude = -6.649179;
  double _longitude = 110.707172;
  String _image = '-';
  String _uid = '-';
  String _open = '-';
  String _close = '-';

  @override
  void initState() {
    super.initState();
    _getDetailLocationData();
  }

  Future<void> _getDetailLocationData() async {
    await 300.microseconds.delay;
    await getLocationById(widget.uid).then(
      (Locations location) {
        setState(() {
          _name = location.name;
          _phone = location.phone;
          _address = location.address;
          _latitude = location.location.latitude;
          _longitude = location.location.longitude;
          _image = location.image;
          _uid = location.uid;
          _open = location.open;
          _close = location.close;
        });

        _getCurrentLocationAndDistance();
        _animateCameraToLocation();
        _addMarker();
      },
    ).catchError(
      (e) => print(e),
    );
  }

  void _animateCameraToLocation() async {
    final GoogleMapController controller = await _controller.future;

    setState(() {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(_latitude, _longitude),
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
      markerId: MarkerId(_name),
      position: LatLng(_latitude, _longitude),
      icon: BitmapDescriptor.fromBytes(_markerIcon),
      infoWindow: InfoWindow(
        title: _name,
        snippet: _address,
      ),
    );

    setState(() {
      _markers.add(_marker);
    });
  }

  Future<void> _getCurrentLocationAndDistance() async {
    await 300.milliseconds.delay;
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
      _latitude,
      _longitude,
    );

    _resultDistance = (_distance / 1000).toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          _name,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 100 * 2,
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.height / 100 * 1,
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 100 * 35,
                  child: Hero(
                    tag: _uid,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: (_image != '-')
                          ? CachedNetworkImage(
                              imageUrl: _image,
                              placeholder: (context, url) => Center(
                                child: lottie.Lottie.asset(
                                  "assets/lottie/loading.json",
                                ),
                              ),
                              errorWidget: (context, url, error) => Center(
                                child: lottie.Lottie.asset(
                                  "assets/lottie/error.json",
                                ),
                              ),
                              fit: BoxFit.cover,
                            )
                          : lottie.Lottie.asset(
                              "assets/lottie/error.json",
                            ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 100 * 2,
            ),
            Text(
              _name,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width / 100 * 6,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 100 * 1,
            ),
            Text(
              _address,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width / 100 * 3.8,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 100 * 1,
            ),
            Text(
              'Buka : $_open - $_close',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width / 100 * 3.8,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 100 * 1,
            ),
            Text(
              _phone,
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
                'Lokasi Tambal Ban berada di ${(_resultDistance != null) ? _resultDistance : '-'} KM dari tempat anda sekarang',
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
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 100 * 3,
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
                        coords: Coords(_latitude, _longitude),
                        title: _name,
                        description: "Location of $_name",
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
                      if (_phone != '-') {
                        launch('tel:$_phone');
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
                      if (_phone != '-') {
                        launch('sms:$_phone');
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
                          'hei, tambal ban dekat sini ada di $_name, $_address.\nAnda bisa menghubunginya di $_phone.');
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
