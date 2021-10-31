import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:async/async.dart';
import 'package:path/path.dart' as path;
class Senddata extends StatefulWidget {
  @override
  _SenddataState createState() => _SenddataState();
}

class _SenddataState extends State<Senddata> {
  File _image;
   selectimg() async
  {
    var image= await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image==null) return;
    setState(() {
     _image=image ;
    });
    
  }
  uploadImageToServer(File imageFile)async
  {
      print('attempting to connect to server……');
      // var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var stream=new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();
      print(length);
      //var uri = Uri.parse('http://192.168.1.3:5000/upload');
      var uri=Uri.parse('http://192.168.1.5:5000/upload');
      print('connection established');
      var request = new http.MultipartRequest('POST', uri);
      var multipartFile = new http.MultipartFile('file', stream, length,
          filename:path.basename(imageFile.path));
      print('continue');
      //contentType: new MediaType(‘image’, ‘png’));
      request.files.add(multipartFile); 
      var response = await request.send();
      print('done');
      var x=await http.Response.fromStream(response);
      print(x.body);
      print(response.statusCode);
      return Container(
        child: Text(' dbgbgb  ${x.body}'),
      );
  }

  display(image){
    uploadImageToServer(image);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('send data to flask'),
        ),
    floatingActionButton: FloatingActionButton(
        onPressed: selectimg,
        //onPressed: _getImageAnddetectFaces,
        child: Icon(Icons.image),
        tooltip: 'Pick image from gallery',
      ),
      // body: _image==null?Text('no image selected'):Image.file(_image),
      body:_image==null?Text('no image selected'):display(_image)
    );
  }
}