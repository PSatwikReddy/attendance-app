import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loc2/delayed_animation.dart';
import 'package:url_launcher/url_launcher.dart';

class Schedule extends StatelessWidget {
  final String arr;
  Schedule({Key key, @required this.arr}) : super(key: key);
  void callmapsfunction(double lat, double longi) {
    MapUtils.openMap(lat, longi).then((value) {
      // Run extra code here
    }, onError: (error) {
      print(error);
    });
  }

  Widget _buildList(BuildContext context, DocumentSnapshot document) {
    String x = document['date'];
    GeoPoint g = document['locat'];
    var newFormat = DateFormat("dd-MM-yyyy");
    DateTime n = new DateTime(int.parse(x.substring(6)),
        int.parse(x.substring(3, 5)), int.parse(x.substring(0, 2)));
    var y = DateFormat('EEEE').format(n);

    return ListTile(

      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          IconData(0xe878, fontFamily: 'MaterialIcons'),
          color: Colors.blue[700],
          size: 30,
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('$x',
            style: TextStyle(
                color: Colors.blue[700],
                fontWeight: FontWeight.bold,
                fontSize: 18)),
      ),
      subtitle: Text("  $y",
          style: TextStyle(
              color: Colors.orangeAccent,
              fontWeight: FontWeight.bold,
              fontSize: 16)),
      enabled: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      onTap: () {
        callmapsfunction(g.latitude, g.longitude);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 60,
          ),
          DelayedAnimation(
            delay: 200,
            child: Text(
              'All Schedules',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 30),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  )),
              child: DelayedAnimation(
                delay: 400,
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  child: StreamBuilder(
                    stream: Firestore.instance
                        .collection('schedules')
                        .document(arr)
                        .collection('list')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text("Loading..");
                      }
                      if (snapshot.data.documents.length == 0) {
                        return Container(
                          alignment: Alignment.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 40,
                              ),
                              Icon(
                                Icons.notifications_off,
                                size: 50,
                              ),
                              SizedBox(height: 20),
                              Text(
                                'No current schedules',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Card(

                                color: Colors.white.withOpacity(0.8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                elevation: 4,
                                child: Container(
                                    //               decoration: new BoxDecoration(
                                    //   image: new DecorationImage(image: NetworkImage('https://picsum.photos/250?image=9',),
                                    //   fit: BoxFit.cover),
                                    // ),

                                    child: _buildList(context,
                                        snapshot.data.documents[index]))),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MapUtils {
  MapUtils._();

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
