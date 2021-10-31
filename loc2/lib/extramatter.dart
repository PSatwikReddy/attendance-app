
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:loc2/schedules.dart';

class Firstpage extends StatefulWidget {
  @override
  _FirstpageState createState() => _FirstpageState();
}
var arr;
var db=Firestore.instance;
class _FirstpageState extends State<Firstpage> {


  
  var now;
  
  String validity='valid user';
  double latit=0.00000;
  double longi=0.00000;
  double latit1=0.00000;
  double longi1=0.00000;


  Future retloc() async
  { 
    
    Position position=await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    
    // GeoPoint _geoPoint=new GeoPoint(latit, longi);
    print(position.latitude);
    print(position.longitude);
     var doc= db.collection('users').document(arr);
     print('check in db $doc');
     if (doc==null)
     {
       print('not valid user111');
       return;
     }
    setState(() {
      
      latit=position.latitude;
      longi=position.longitude;
      now=new DateTime.now();
      GeoPoint _geoPoint=new GeoPoint(latit, longi);
      doc.setData({'date':now,
    'locat':_geoPoint
    });
    });
    
    var getdata= db.collection('users').document(arr);
    var x=await getdata.get();
    if (!x.exists)
     {
       print('not valid user');
       setState(() {
         latit=0.00000;
         longi=0.00000;
         validity='not a valid user';
       });
       return;
     }
    GeoPoint _g=x.data['locat'];
    setState(() {
      latit1=_g.latitude;
      longi1=_g.longitude;
    });
    var time=x.data['date'];
    DateTime t=time.toDate();

    print('date ${t.month} latit_${_g.latitude}');
    
    

  }

  Future<void> valid()async
  {
    double dist=await Geolocator().distanceBetween(latit,longi,latit1 , longi1);
    print(dist);
    if(dist<50)
    print('in viscinity');
    else
    print('not in viscinity');
  }


  //user details
  

  

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(
        title: Text('give attendance'),
      ),

      drawer: Drawer(
              // Add a ListView to the drawer. This ensures the user can scroll
              // through the options in the drawer if there isn't enough vertical
              // space to fit everything.
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    child: Text('welcome $arr'),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                  ),
                  ListTile(
                    title: Text('username username'),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                    },
                  ),
                  ListTile(
                    title: Text('email email'),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                    },
                  ),
                  ListTile(
                    title: Text('phone phone'),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                    },
                  ),
                ],
              ),
            ),
      //bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex:1,
        
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('home'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.schedule),
            title: new Text('schedule'),
            ),

        ]),


      body: ListView(

         children: <Widget>[
           //heading
           RichText(text: TextSpan(
             text: 'welcome $arr',
             style: TextStyle(
               fontSize: 40,
               fontStyle: FontStyle.italic,
               color: Colors.blue[200],
             ),
           )),
            SizedBox(
            height: 10.0,

          ),
          Text('click below button to get the current location'),
          //button to get location
           IconButton(icon: Icon(Icons.my_location), onPressed: retloc),
          
          SizedBox(height: 10.0,),

          

           SizedBox(height: 20.0,),

          Text('latit is $latit and longi is $longi'),

           SizedBox(height: 20.0,),
          
          Text('time is $now'),
           SizedBox(height: 30.0,),
          Text('to check the location press the below button'),
          RaisedButton(
            onPressed: valid,
            color: Colors.greenAccent,
            shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.black),
                  ),
            child: Text('click to validate'),
          ),
          Text('validity $validity'),
          RaisedButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) =>Schedule(arr: arr)));
            },
            color: Colors.greenAccent,
            shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.black),
                  ),
            child: Text('click to get schedule'),
          ),

          startingAttendance(),
         ],

      ),
    );
  }




  var scheduletoday;
    // first attendance
    void statt() async
    {
      
      
      var df=new DateFormat('dd-MM-yyyy');
      String d=df.format(DateTime.now());
      print(d);
     var x= await db.collection('schedules').document(arr).collection('list').document(d).get();
     if (x.exists){
      setState(() {
        scheduletoday=x['date'];
              });
     }
     else{
       setState(() {
        scheduletoday='no schedule today';
              });
     }
    }

    Widget startingAttendance()
    {     
      return Material(
        child: Column(
          children: <Widget>[
            FlatButton(onPressed: statt, child: Text('printing')),
            Text('is there a schedule $scheduletoday')
          ],
        ),


      );
    }
}


/*  
To Display schedules
 */
// class Schedulepage extends StatefulWidget {
//   @override
//   _SchedulepageState createState() => _SchedulepageState();
// }

// class _SchedulepageState extends State<Schedulepage> {
//   DocumentSnapshot sch;
//   var date;
//   var loc;
 
// //each list view
//   Widget _buildList(BuildContext context, DocumentSnapshot document) {
//     DateTime x=document['date'].toDate();
    
//     return ListTile(
//       title: Text('${x.toString()}'),
//       subtitle: Text(document['locat']),
//     );
//   }




//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("StreamBuilder with FireStore")),
//       body: 
//       StreamBuilder(
//         stream: Firestore.instance.collection('fl').document(arr).collection('days').snapshots(),
        
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Text("Loading..");
//           }
//           return ListView.builder(
//             itemCount: snapshot.data.documents.length,
//             itemBuilder: (context, index) {
//               return _buildList(context, snapshot.data.documents[index]);
//             },
//           );
//         },
//       ),
//     );
//   }
// }

