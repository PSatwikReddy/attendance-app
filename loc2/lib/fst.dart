import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Secondstate extends StatefulWidget {
  @override
  _SecondstateState createState() => _SecondstateState();
}

class _SecondstateState extends State<Secondstate> {

  File _image;
  Future getImage()async{
  
    
      File image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image=image;
    });
    
  }
  @override
  
    Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body:Column(
        children: <Widget>[
          Text('in second act with '),
          RaisedButton(
          color: Colors.blue,
          onPressed: () {
            Navigator.pop(context);
          },
          
          child: Text('Go back!'),
        ),
        RaisedButton(
          color: Colors.blue,
          onPressed: getImage,
          
          child: Text('pick image!'),
        ),
        _image == null ? Text('not picked'):Image.file(_image,height: 300.0,width: 300.0,),
        ],
      )
    );
  }
}