import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tabline/data/data.dart';
import 'package:tabline/models/locations.dart';
import 'package:tabline/router.gr.dart' as routerApp;

import '../utils.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  StreamSubscription<QuerySnapshot> _currentSubscription;

  static final CameraPosition _kInitialPositiion = const CameraPosition(
    target: LatLng(-6.649179, 110.707172),
    zoom: 18.0,
  );

  Position _currentPosition;
  Set<Marker> _markers = Set();
  Marker _marker;
  List<Locations> _locations = <Locations>[];

  @override
  void initState() {
    super.initState();
    _currentSubscription = loadAllLocationData().listen(_getLocation);
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _currentSubscription.cancel();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    await getCurrentPosition(
            desiredAccuracy: LocationAccuracy.bestForNavigation)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });

    _goToMyLocation();
  }

  Future<void> _goToMyLocation() async {
    final GoogleMapController controller = await _controller.future;

    setState(() {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: (_currentPosition != null)
                ? LatLng(_currentPosition.latitude, _currentPosition.longitude)
                : LatLng(-6.649179, 110.707172),
            zoom: 15.0,
          ),
        ),
      );
    });
  }

  void _getLocation(QuerySnapshot snapshot) async {
    final _markerIcon = await getBytesFromAsset('assets/png/tire.png', 80);

    setState(() {
      _locations = listLocations(snapshot);
      _locations.forEach((location) {
        _marker = Marker(
          flat: true,
          markerId: MarkerId(location.uid),
          position:
              LatLng(location.location.latitude, location.location.longitude),
          icon: BitmapDescriptor.fromBytes(_markerIcon),
          infoWindow: InfoWindow(
              title: location.name,
              snippet: 'Buka : ${location.open} - ${location.close}',
              onTap: () {
                ExtendedNavigator.of(context).push(
                  routerApp.Routes.detailScreen,
                  arguments: routerApp.DetailScreenArguments(
                    uid: location.uid,
                  ),
                );
              }),
        );

        _markers.add(_marker);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _kInitialPositiion,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        zoomGesturesEnabled: true,
        zoomControlsEnabled: true,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        compassEnabled: true,
        markers: _markers,
        padding: EdgeInsets.all(MediaQuery.of(context).size.width / 100 * 6),
      ),
    );
  }
}
