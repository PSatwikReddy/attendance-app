import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loc2/main.dart';
import 'delayed_animation.dart';

class ViewAttendance extends StatefulWidget {
  @override
  _ViewAttendanceState createState() => _ViewAttendanceState();
}

class _ViewAttendanceState extends State<ViewAttendance> {
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
          color: Colors.cyan,
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('$x',
            style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
      ),
      subtitle: Text("$y ",
          style: TextStyle(
              color: Colors.orangeAccent,
              fontWeight: FontWeight.bold,
              fontSize: 14)),
      enabled: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      onTap: () {
        //callmapsfunction(g.latitude, g.longitude);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Welcome",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 20)),
          backgroundColor: 
          Color(0xFFF286ffd),
          // Colors.green[700]
        ),
          body: Container(
            color: Colors.blue,
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
                'Attendance',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 30,),
            // child: Row(children: <Widget>[
            //   Text('total 20'),
            //   Text('attendance given')
            // ],),),
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
                                  color: snapshot.data.documents[index]['start']
                                      ? Colors.greenAccent[400]
                                      : Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  elevation: 2,
                                  child: Container(
                                      decoration: new BoxDecoration(),
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
      ),
    );
  }
}
