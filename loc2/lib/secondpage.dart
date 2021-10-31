import 'package:flutter/material.dart';
import 'package:loc2/attendance2.dart';
import 'package:loc2/dashboard.dart';
import 'package:loc2/giveattend.dart';
import 'package:loc2/profilepage.dart';
import 'package:loc2/schedules.dart';
import 'package:loc2/main.dart';
import 'package:loc2/viewattendance.dart';

class Secondpage extends StatefulWidget {
  final String arr;
  Secondpage({Key key, @required this.arr}) : super(key: key);

  @override
  _SecondpageState createState() => _SecondpageState(arr: arr);
}

var selectedindex = 0;

class _SecondpageState extends State<Secondpage> {
  var arr;
  _SecondpageState({Key key, @required this.arr});
  var em=email;
  @override
  Widget build(BuildContext context) {
    // print(selectedindex);
    List<Widget> bottom = [
      Schedule(arr: arr),
      StartAttendance(user: arr),
      EndAttendance(user: arr),
      ViewAttendance()
    ];
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
        bottomNavigationBar: BottomNavigationBar(
          //backgroundColor: Colors.red,
          items: [
            BottomNavigationBarItem(
              //backgroundColor: Colors.grey,
              icon: new Icon(Icons.schedule),
              title: new Text('schedule'),
            ),
            BottomNavigationBarItem(
              //backgroundColor: Colors.grey,
              icon: new Icon(Icons.account_box),
              title: new Text('Start '),
            ),
            BottomNavigationBarItem(
              //backgroundColor: Colors.grey,
              icon: new Icon(Icons.alarm_off,
              //color: Colors.red,
              ),
              title: new Text('end'),
            ),
            // BottomNavigationBarItem(
              
            //   icon: new Icon(Icons.alarm_off),
            //   //backgroundColor: Colors.grey,
            //   title: new Text('end'),
            // ),
            
          ],
          currentIndex: selectedindex,
          selectedItemColor: Colors.blueAccent,
          onTap: (int index) {
            setState(() {
              selectedindex = index;
            });
          },
        ),
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topCenter, colors: [
              Colors.blue[900],
              Color(0xFFF286ffd),
              Color(0xFFF3820fb),
              Color(0xFFF28c3eb)
          //     Colors.green[900],
          // Colors.greenAccent,
          // Colors.green[200],
          
            ])),
            child: bottom[selectedindex]),
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                
                accountName: Text("$arr"),
                accountEmail: Text("$em"),
                currentAccountPicture: CircleAvatar(
                  backgroundColor:
                      Theme.of(context).platform == TargetPlatform.iOS
                          ? Colors.blue
                          : Colors.white,
                  child: Text(
                    arr[0],
                    style: TextStyle(fontSize: 40.0),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.event_note,color: Colors.blue[900],),
                title: Text('Schedules'),
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    selectedindex = 0;
                  });
                },
              ),
              ListTile(
                leading: Icon(Icons.person_pin_circle,
                
                color: Colors.green[900],
                ),
                title: Text('Start attendance'),
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    selectedindex = 1;
                  });
                },
              ),
              ListTile(
                leading: Icon(Icons.person_pin_circle,
                
                color: Colors.red[900],
                ),
                title: Text('Ending attendance'),
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    selectedindex = 2;
                  });
                },
              ),
              ListTile(
                leading: Icon(Icons.dashboard,
                
                color: Colors.yellow[900],
                ),
                title: Text('Dashboard'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.person,
                
                color: Colors.purple[800],
                ),
                title: Text('Profile'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>Profile()));
                },

              ),
              ListTile(
                leading: Icon(IconData(0xe85d, fontFamily: 'MaterialIcons', matchTextDirection: true),
                
                color: Colors.brown[400],
                ),
                title: Text('Attendance'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>ViewAttendance()));
                },

              ),
            SizedBox(height: 100,),
            ListTile(
                leading: Icon(Icons.power_settings_new,
                
                color: Colors.grey[800],
                ),
                title: Text('Logout'),
                
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    //selectedindex = 2;
                  });
                },

              ),
              
            ],

          ),
        ));
  }
}
