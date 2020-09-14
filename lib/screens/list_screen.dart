import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:tabline/data/data.dart';
import 'package:tabline/models/locations.dart';
import 'package:tabline/router.gr.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
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
      body: StreamBuilder<QuerySnapshot>(
        stream: loadAllLocationData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Lottie.asset(
                'assets/lottie/nodata.json',
                height: MediaQuery.of(context).size.height / 100 * 2,
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Lottie.asset(
                "assets/lottie/error.json",
                height: MediaQuery.of(context).size.height / 100 * 25,
              ),
            );
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: Lottie.asset(
                  "assets/lottie/loading.json",
                  height: MediaQuery.of(context).size.height / 100 * 25,
                ),
              );
            default:
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  final _location = Locations.fromMap(
                    snapshot.data.docs[index].data(),
                  );
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
                                width:
                                    MediaQuery.of(context).size.width / 100 * 2,
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  ExtendedNavigator.of(context).push(
                                    Routes.detailScreen,
                                    arguments: DetailScreenArguments(
                                      uid: _location.uid,
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
                                        tag: _location.uid,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: CachedNetworkImage(
                                            imageUrl: _location.image,
                                            placeholder: (context, url) =>
                                                Center(
                                              child: Lottie.asset(
                                                "assets/lottie/loading.json",
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) => Center(
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
                                      width: MediaQuery.of(context).size.width /
                                          100 *
                                          4,
                                    ),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${_location.name.toUpperCase()}',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  100 *
                                                  4.8,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                100 *
                                                1,
                                          ),
                                          Text(
                                            '${_location.address}',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  100 *
                                                  3.5,
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                100 *
                                                1,
                                          ),
                                          Text(
                                            'Buka : ${_location.open} - ${_location.close}',
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
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          100 *
                                          2,
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
              );
          }
        },
      ),
    );
  }
}
