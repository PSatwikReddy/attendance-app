import 'package:flutter/material.dart';
import 'package:loc2/main.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 20)),
        backgroundColor: Color(0xFFF286ffd),
        // Colors.green[700]
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   begin: Alignment.topCenter,
          //   colors: [
          //     Color(0xFFF286ffd),
          //     Color(0xFFF3820fb),
          //     Color(0xFFF28c3eb)
            
          // ])
          image: DecorationImage(
              image: AssetImage('assets/images/prof2.jpeg'),
              fit: BoxFit.cover),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 40),
            // Container(
            //   height: 125,
            //   width: 125,
            //   decoration: BoxDecoration(
            //       image: DecorationImage(

            //           image: AssetImage('assets/images/tennis.jpg'),
            //           fit: BoxFit.contain),
            //       shape: BoxShape.circle),
            //       //child: Image.asset('assets/images/tennis.jpg',),
            // ),
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle
                  ),
              child: CircleAvatar(
                radius: 60.0,
                backgroundImage: AssetImage("assets/images/pr1.jpg"),
                
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '$arr',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            // SizedBox(height:10),
            // Text('User Information',textAlign: TextAlign.left,style: TextStyle(
            //     color: Colors.white,
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //   ),),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.all(5),
              //height: MediaQuery.of(context).size.height - 400,
              decoration: BoxDecoration(
                  //color: Colors.blue.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(5)),
              child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Card(
                  margin: EdgeInsets.all(5),
                    child: ListTile(                  
                    leading: Icon(Icons.person,color: Colors.blue[900],size:30),
                    title: Text('Name'),
                    subtitle: Text(arr),
                  ),
                ),
                Card(
                  margin: EdgeInsets.all(5),
                    child: ListTile(                  
                    leading: Icon(Icons.work,color: Colors.brown[500],size:30),
                    title: Text('Designation'),
                    subtitle: Text('Employee'),
                  ),
                ),
                Card(
                  //color: Colors.white.withOpacity(0.8),
                  margin: EdgeInsets.all(5),
                    child: ListTile(                  
                    leading: Icon(Icons.mail_outline,color: Colors.red,size:30),
                    title: Text('Email'),
                    subtitle: Text(email),
                  ),
                ),
                Card(
                  margin: EdgeInsets.all(5),
                    child: ListTile(                  
                    leading: Icon(Icons.call,color: Colors.green,size: 30,),
                    title: Text('Phone'),
                    subtitle: Text(phone),
                  ),
                ),
              ],
            )
            ),
            
          ],
        ),
      ),
    );
  }
}
