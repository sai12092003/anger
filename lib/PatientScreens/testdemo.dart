import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'demotest2.dart';

class MyHomePag extends StatefulWidget {
  MyHomePag({required this.title});

  final String title;

  @override
  _MyHomePagState createState() => _MyHomePagState();
}

class _MyHomePagState extends State<MyHomePag> {
  var resJson;
  String base64Image = "";

  Future<void> onUploadImage() async {
    try {
      if (base64Image.isEmpty) {

        return;
      }

      var response = await http.post(
        Uri.parse("http://192.168.86.89:5000/upload"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"image": base64Image,"Email_ID":'t'}),
      );

      setState(() {
        resJson = jsonDecode(response.body);
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> getImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      List<int> imageBytes = await image.readAsBytes();
      base64Image = base64Encode(imageBytes);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CheckImages()));

            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            base64Image.isEmpty
                ? Text('Please Pick an image to Upload')
                : Image.memory(base64Decode(base64Image)),
            ElevatedButton(
              onPressed: onUploadImage,
              child: Text(
                "Upload",
                style: TextStyle(color: Colors.black),
              ),
            ),
            Text(resJson?['message'] ?? ''),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Increment',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
