import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loc2/secondpage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:async/async.dart';
import 'package:path/path.dart' as path;

class StartAttendance extends StatefulWidget {
  String user;
  StartAttendance({Key key, @required this.user}) : super(key: key);
  @override
  _StartAttendanceState createState() => _StartAttendanceState(user: user);
}

class _StartAttendanceState extends State<StartAttendance> {
  var user;
  bool imagecorr=false;
  String imagemsg='Face not found. Please try again';
  String viscinity;
  var currentloc;
  double distance;
  var db = Firestore.instance;
  _StartAttendanceState({Key key, @required this.user});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.height,
      child: Column(
        children: <Widget>[
          SizedBox(height: 60),
          Text(
            'Start Attendance',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Expanded(
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 30, left: 10, right: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    )),
                child: isThere(user)),
          ),
        ],
      ),
    );

    // return Container(

    //   child: isThere(user),
    // );
  } //end of build

  Widget isThere(user) {
    var now = new DateTime.now();
    //print(new DateFormat("dd-MM-yyyy hh:mm:ss").format(now));
    var newFormat = DateFormat("dd-MM-yyyy");
    String updatedDt = newFormat.format(now);
    //print(updatedDt);
     //updatedDt = '25-06-2020';
    return FutureBuilder(
        future: Firestore.instance
            .collection('schedules')
            .document(user)
            .collection('list')
            .document(updatedDt)
            .get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            var x = snapshot.data.exists;
            if (x == true) {
              if (snapshot.data['start'] == false)
                return notGiven(context, snapshot, user,updatedDt);
              else {
                return Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 40,
                      ),
                      Icon(
                        IconData(0xe5ca, fontFamily: 'MaterialIcons'),
                        color: Colors.green,
                        size: 50,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Starting attendance already given.Thank you ',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                );
              }
            } else {
              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                    ),
                    Icon(
                      Icons.do_not_disturb,
                      color: Colors.redAccent,
                      size: 50,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'No  schedule today',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              );
            }
          } else {
            return Container(
                alignment: Alignment.center,
                height: 200,
                width: 200,
                child: new CircularProgressIndicator());
          }
        });
  }

  Widget notGiven(BuildContext context, AsyncSnapshot snapshot, user,updateddt) {
    var x = snapshot.data;
    GeoPoint coords = x['locat'];

    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Text(
          'Date : ${x['date']}',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 20,
          width: 20,
        ),
        Row(
          children: <Widget>[
            Text(
              'Location :',
              style: TextStyle(
                color: Colors.black,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                width: 200,
                child: Text(
                  // '${coords.latitude} and ${coords.longitude}',
                  '${x['locdesc']}',
                  softWrap: true,

                  overflow: TextOverflow.clip,
                  maxLines: 3,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
          width: 20,
        ),
        Card(
            color: Colors.amberAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            elevation: 5,
            child: Column(
              children: <Widget>[
                SizedBox(height: 5),
                
                IconButton(
                    color: Colors.blue[900],
                    splashColor: Colors.blueAccent,
                    icon: Icon(Icons.near_me,size: 30,),
                    onPressed: () {
                      callmapsfunction(coords.latitude, coords.longitude);
                    }),
                Text('click to get directions to location'),
                SizedBox(height: 10),
              ],
            )),
        SizedBox(
          height: 20,
        ),
        // RaisedButton(onPressed:(){ callmapsfunction(coords.latitude, coords.longitude);},
        // child: Text('click to get directions to location'),
        // ),

        // Text('$viscinity'),
        // currentloc == null
        //     ? Text('no location yet')
        //     : Text(
        //         'current location is ${currentloc.latitude}, lon is ${currentloc.longitude}'),
        // distance == null ? Text('no') : Text('distance is $distance'),
        imagemsg=='Face not found. Please try again'?RaisedButton(
          onPressed: display,
          elevation: 10,
            color: Colors.greenAccent[400],
          child: Text('Upload photo for biometric',style: TextStyle(fontSize: 18),),
        ):Icon(IconData(0xe5ca, fontFamily: 'MaterialIcons'),color: Colors.green,size: 30 ,),
        SizedBox(height: 20,child: Text(imagemsg,textAlign: TextAlign.center,),),
        RaisedButton(
          onPressed: (){valid(coords, user,updateddt);},
          elevation: 10,
            color: Colors.greenAccent[400],
          child: Text('Give Attendance',style: TextStyle(fontSize: 18),),
        ),
        SizedBox(height: 25,child: viscinity=='Not in Vicinity'?Text('* $viscinity *',textAlign: TextAlign.center,style: TextStyle(fontSize: 18,)):Container(),),
        Padding(
          
          padding: const EdgeInsets.all(4.0),
          child: RaisedButton(
            elevation: 10,
            color: Colors.red[300],
            onPressed: () {
              // valid(coords,user);
              dialog(context, coords);
            },
            child: Text(
              'To check in vicinity',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }

  dialog(context, coords) async {
    var x;
    var y = await findingdistance(coords) / 1000;
    print(y);
    x = y.toStringAsPrecision(4);

    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => AlertDialog(
              title: Icon(
                IconData(0xe002, fontFamily: 'MaterialIcons'),
                color: Colors.red,
              ),
              content: Text('You are $x km away from your work location'),
            ));
  }

  void callmapsfunction(double lat, double longi) {
    MapUtils.openMap(lat, longi).then((value) {
      // Run extra code here
    }, onError: (error) {
      print(error);
    });
  }

  

  //distance

  Future<double> findingdistance(coords) async {
    double x = 0;
    var position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // .then((position)  {
    //   print('position');
    //    Geolocator().distanceBetween(position.latitude,position.longitude,coords.latitude , coords.longitude).then((onValue){
    //      x=onValue;
    //     return onValue;
    //   });

    // });
    double dis = await Geolocator().distanceBetween(position.latitude,
        position.longitude, coords.latitude, coords.longitude);
    return dis;
  }

  //check viscinity
  Future<void> valid(GeoPoint coords, user,updateddt) async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    double dis = await Geolocator().distanceBetween(position.latitude,
        position.longitude, coords.latitude, coords.longitude);
    GeoPoint p=new GeoPoint(position.latitude, position.longitude);
    setState(() {
      currentloc = position;
      distance = dis;
    });

    print(dis);
    if (dis < 1500 && imagecorr) {
       db.collection('schedules').document(user).collection('list').document(updateddt).updateData({'start': true,'startloc' :p});
       db.collection('users').document(user).setData({'date':DateTime.now(),'locat' :p});
      print('in viscinity');
      setState(() {
        viscinity = null;
      });
    } else {
      print('Not in vicinity');
      setState(() {
        viscinity = 'Not in Vicinity or face not recognized';
      });
    }
  }

  uploadImageToServer() async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    print('attempting to connect to server……');
    // var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    print(length);
    var uri = Uri.parse('http://192.168.0.159:5000/upload');
    print('connection established');
    var request = new http.MultipartRequest('POST', uri);
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: path.basename(imageFile.path));
    print('continue');
    //contentType: new MediaType(‘image’, ‘png’));
    request.files.add(multipartFile);
    var response = await request.send();
    
    print('done');
    var x = await http.Response.fromStream(response);
    print(x.body);
    print(response.statusCode);
    
    var y=json.decode(x.body);
    
    var n=y['name'] ;
    print(y.runtimeType);
    if (n==user){
      setState(() {
        imagecorr=true;
        imagemsg='Face found. Continue';
      });
      print('match $n');
    }
    else{
      setState(() {
        imagecorr=false;
        imagemsg='Face not found. Please try again';
      });
      print('no match $user $n');  
    }
    
  }

  display() {
    uploadImageToServer();
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
