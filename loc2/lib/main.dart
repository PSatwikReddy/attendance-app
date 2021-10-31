import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loc2/dashboard.dart';
import 'package:loc2/delayed_animation.dart';
import 'package:loc2/facetest.dart';
import 'package:loc2/fst.dart';
import 'package:loc2/secondpage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'schedules.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());
var arr;
final db = Firestore.instance;

var username;
var email;
var phone;
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
      ),
      home: Getloc(),
    );
  }
}




//Main page
class Getloc extends StatefulWidget {
  @override
  _GetlocState createState() => _GetlocState();
}

class _GetlocState extends State<Getloc> with SingleTickerProviderStateMixin{
  


  final usern = TextEditingController();
   final passw = TextEditingController();
   final int delayedAmount = 500;
  double _scale;
  AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _controller.dispose();
    passw.dispose();
    usern.dispose();
    super.dispose();
  }
  
  final LocalAuthentication _localAuthentication=LocalAuthentication();
  //bool _cancheck=false;
  String _authorizedornot="Not authorized";
  //List<BiometricType> _available=List<BiometricType>();

/*to check whether biometrics are present or not*/


  // Future<void> _checkBio() async{
  //   bool canbio=false;
  //   try{
  //     canbio=(await _localAuthentication.canCheckBiometrics) ;
  //   } on PlatformException catch(e)
  //   {
  //     print(e);
  //   }
  //   if(!mounted) return;
  //   setState(() {
  //     _cancheck=canbio;
  //   });
  // }



  /*to check what biometrics are there*/



  // Future<void> _getlist() async{
  //   List<BiometricType> list;
  //   try{
  //    list=(await _localAuthentication.getAvailableBiometrics()) ;
  //   } on PlatformException catch(e)
  //   {
  //     print(e);
  //   }
  //   if(!mounted) return;
  //   setState(() {
  //     _available=list;
  //   });
  // }

  /*authentication*/
  void callauthorize(){
    _authorize().then((onValue){});
  }
  Future<void> _authorize() async
  {
    bool isAuth = false;
    try{
     
      isAuth=(await _localAuthentication.authenticateWithBiometrics(localizedReason: 'please authorize to check',
      useErrorDialogs: false,
      stickyAuth: true
      )) ;
    }on PlatformException catch(e)
    {
      print(e);
    }
    if(!mounted) return;
    setState(() {
     if (isAuth)
     {
       _authorizedornot="authorized";

     }
     else
     _authorizedornot="not auth";
    });
  }
  bool _indb=false;
  String loginmessage;
   Future<bool> indatabase( name) async{
    var doc= await db.collection('userdata').document(name).get();
    print('gsfff $doc  $name');
    if (doc.exists)
    {
      if(doc['pwd']==passw.text){
      setState(() {
        _indb=true;
        loginmessage=null;
      });
      return true;
      }
      else{
        setState(() {
        _indb=false;
        loginmessage='Invalid credentials';
      });
      print('no');
      return false;
      }
    }   
    else
    {
      setState(() {
        _indb=false;
        loginmessage='Invalid credentials';
      });
      print('no');
      return false;
    }

   

  }

  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(

      appBar: AppBar(
        title: Text('Attendance Tracker'),
        backgroundColor: Color(0xFFF286ffd),
        

      ),
      body:Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Color(0xFFF286ffd),
              Color(0xFFF3820fb),
              Color(0xFFF28c3eb)
            
          ])
        ),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height:70,),

            //Welcome message
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                  DelayedAnimation(
                    delay: delayedAmount,
                    child: Text('Welcome',style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                  )
              ],
            ),
            SizedBox(
              height: 40,

            ),
            //login part

            Expanded(

              child: DelayedAnimation(
                delay: delayedAmount+500,
                              child: Container(
                  

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),

                    )

                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: <Widget>[
                          
                          SizedBox(height: 20,),
                          AnimatedContainer(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              backgroundBlendMode: BlendMode.darken
                            ),
                            child: TextField(

                  decoration: new InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      border: new OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(width: 16.0, color: Colors.black),

                      ),
                      
                      labelText: 'username',
                  ),
                  cursorColor: Colors.red,

                  controller: usern,
                ), duration: Duration(seconds: 5),
                          ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  
                  decoration: new InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                      border: new OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(width: 16.0, color: Colors.black),
                      ),
                      labelText: 'password',
                      
                  ),
                  obscureText: true,
                  cursorColor: Colors.red,

                  controller: passw,
                ),

              SizedBox(height:20),
              loginmessage==null?Container():Text('$loginmessage'),
             //Text('authorized : $_authorizedornot'),
            // RaisedButton(onPressed: _authorize,child:Text('authorize'),
            // ),        
            
           SizedBox(height: 20,),
            Container(
              height: 45,
              width: 150,
              child: Center(
                
                child: RaisedButton(
                  elevation: 5,
                  
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                    padding: const EdgeInsets.all(0.0),
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
                        constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                        alignment: Alignment.center,
                        child: const Text(
                          'login',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  onPressed: loginbutton,
                
                ),
              ),
            ),
                        ],
                      ),
                    ),
                    ),
                ),
              ),
              ),
          ],
        ),
      )
      
    );

  }
  Future<void> loginbutton()
  async {
    if (usern.text!=''){
                  var x=await indatabase(usern.text);
                  
                if ( usern.text!='' && x)
                {
                print('in fifdfd');
                await userdetails(usern.text);
                setState(() {
                  arr=usern.text;
                  print('in');
                   //Navigator.push(context, MaterialPageRoute(builder: (context) =>Secondpage(arr:arr)));
                   Navigator.push(context, MaterialPageRoute(builder: (context) =>Dashpage()));
                });
                // Navigator.push(context, MaterialPageRoute(builder: (context) =>Firstpage()));
               
                }

                }
                else{
                  print('not auth');
                }
  }

  Future<void> userdetails(name) async {
    var x= await db.collection('userdata').document(name).get();
    
      print('yes');
      setState(() {
        username=x['username'];
        email=x['email'];
        phone=x['phone number'];
      });
    
    
  }

}


