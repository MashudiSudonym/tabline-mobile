import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:tabline/data/data.dart';
import 'package:supercharged/supercharged.dart';
import 'package:tabline/models/locations_with_distance.dart';
import 'package:tabline/router.gr.dart' as routerApp;

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  StreamSubscription<QuerySnapshot> _currentSubscription;
  Position _currentPosition;
  double _distance;
  double _resultDistance;
  double _latitude = -6.649179;
  double _longitude = 110.707172;
  List<LocationsWithDistance> _locationsWithDistance = [];

  @override
  void initState() {
    super.initState();
    _currentSubscription =
        loadAllLocationData().listen(_getCurrentLocationAndDistance);
  }

  @override
  void dispose() {
    _currentSubscription.cancel();
    super.dispose();
  }

  Future<void> _getCurrentLocationAndDistance(QuerySnapshot snapshot) async {
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

    listLocations(snapshot).forEach((element) {
      setState(() {
        _distance = GeolocatorPlatform.distanceBetween(
          (_currentPosition.latitude == null)
              ? _latitude
              : _currentPosition.latitude,
          (_currentPosition.longitude == null)
              ? _longitude
              : _currentPosition.longitude,
          element.location.latitude,
          element.location.longitude,
        );

        _resultDistance = (_distance / 1000);

        _locationsWithDistance.add(LocationsWithDistance(
          locations: element,
          distance: _resultDistance,
        ));
      });

      _locationsWithDistance
          .sort((p1, p2) => p1.distance.compareTo(p2.distance));

      _locationsWithDistance.forEach((element) {
        print('LOG: ${element.locations.name} ${element.distance}');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tabline',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        elevation: 0.0,
      ),
      body: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: _locationsWithDistance.length,
        itemBuilder: (context, index) {
          final _location = _locationsWithDistance[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: Duration(milliseconds: 375),
            child: SlideAnimation(
              horizontalOffset: 50.0,
              child: FadeInAnimation(
                child: Padding(
                  padding: EdgeInsets.all(
                      MediaQuery.of(context).size.width / 100 * 1),
                  child: Card(
                    elevation: 4.0,
                    shape: Border(
                      right: BorderSide(
                        color: Colors.black87,
                        width: MediaQuery.of(context).size.width / 100 * 2,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          ExtendedNavigator.of(context).push(
                            routerApp.Routes.detailScreen,
                            arguments: routerApp.DetailScreenArguments(
                              uid: _location.locations.uid,
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: 44,
                                minHeight: 44,
                                maxWidth: 100,
                                maxHeight: 100,
                              ),
                              child: Hero(
                                tag: _location.locations.uid,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: CachedNetworkImage(
                                    imageUrl: _location.locations.image,
                                    placeholder: (context, url) => Center(
                                      child: Lottie.asset(
                                        "assets/lottie/loading.json",
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Center(
                                      child: Lottie.asset(
                                        "assets/lottie/error.json",
                                      ),
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width:
                                  MediaQuery.of(context).size.width / 100 * 4,
                            ),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${_location.locations.name.toUpperCase()}',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              100 *
                                              4.8,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        100 *
                                        1,
                                  ),
                                  Text(
                                    '${_location.locations.address}',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              100 *
                                              3.5,
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        100 *
                                        1,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Buka : ${_location.locations.open} - ${_location.locations.close}',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              100 *
                                              3.5,
                                        ),
                                      ),
                                      Text(
                                        _location.distance.toStringAsFixed(1) +
                                            ' KM',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              100 *
                                              3.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width:
                                  MediaQuery.of(context).size.width / 100 * 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
