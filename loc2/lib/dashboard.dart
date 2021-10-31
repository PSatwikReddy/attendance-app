import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loc2/main.dart';
import 'package:loc2/profilepage.dart';
import 'package:loc2/secondpage.dart';

class Dashpage extends StatefulWidget {
  @override
  _DashpageState createState() => _DashpageState();
}

class _DashpageState extends State<Dashpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Color(0xFFF286ffd),
        //Colors.green[700]
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Colors.blue[900],
          Color(0xFFF286ffd),

          Color(0xFFF3820fb),
          Color(0xFFF28c3eb),
          // Colors.brown,
          // // Colors.green[600],
          // // Colors.green[400],
          // Colors.brown[300],
        ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 30),
            Container(
              child: Text(
                'Welcome to attendance app ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 30),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  // image: DecorationImage(image: AssetImage('assets/images/tennis.jpg')),
                  color: Colors.white.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  children: <Widget>[
                    Icon(
                      Icons.person,
                      size: 60,
                    ),
                    Text(
                      'User : $arr',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0)),
                      padding: const EdgeInsets.all(0.0),
                      splashColor: Colors.blue,
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Profile()));
                      },
                      child: Ink(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color(0xFF0D47A1),
                              Color(0xFF1976D2),
                              Color(0xFF42A5F5),
                            ],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(80.0)),
                        ),
                        child: Container(
                          constraints: const BoxConstraints(
                              minWidth: 88.0,
                              minHeight:
                                  36.0), // min sizes for Material buttons
                          alignment: Alignment.center,
                          child: Text(
                            'Profile',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                color: Colors.transparent,
                elevation: 5,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    // image: DecorationImage(image: AssetImage('assets/images/tennis.jpg')),
                    color: Colors.white.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 225,
                  width: MediaQuery.of(context).size.width,
                  child: ListView(
                    children: <Widget>[
                      Icon(
                        Icons.event_note,
                        size: 60,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'To view schedules and give attendance',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      RaisedButton(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0)),
                        padding: const EdgeInsets.all(0.0),
                        splashColor: Colors.blue,
                        onPressed: () {
                          checkpermission();
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => Secondpage(arr: arr)));
                        },
                        child: Ink(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[
                                Color(0xFF0D47A1),
                                Color(0xFF1976D2),
                                Color(0xFF42A5F5),
                              ],
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(80.0)),
                          ),
                          child: Container(
                            constraints: const BoxConstraints(
                                minWidth: 88.0,
                                minHeight:
                                    36.0), // min sizes for Material buttons
                            alignment: Alignment.center,
                            child: Text(
                              'Go',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  checkpermission() async {
    bool isLocationEnabled = await Geolocator().isLocationServiceEnabled();
    print(isLocationEnabled);
    
    if (isLocationEnabled) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Secondpage(arr: arr)));
    }
    else{
      return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Alert'),
        content: const Text('Location is turned off.Please turn on.'),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
    }
  }
}
