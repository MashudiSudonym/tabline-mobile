import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tabline/models/location.dart';
import 'package:tabline/router.gr.dart';
import 'package:url_launcher/url_launcher.dart';

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
      body: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: locations.length,
        itemBuilder: (context, index) {
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
                            Routes.detailScreen,
                            arguments: DetailScreenArguments(
                              name: locations[index].name,
                              address: locations[index].address,
                              phone: locations[index].phone,
                              latitude: locations[index].latitude,
                              longitude: locations[index].longitude,
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
                              child: Image(
                                image: AssetImage('assets/jpg/gambar-tb.jpg'),
                                fit: BoxFit.cover,
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
                                    '${locations[index].name.toUpperCase()}',
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
                                    '${locations[index].address}',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              100 *
                                              3.5,
                                    ),
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
