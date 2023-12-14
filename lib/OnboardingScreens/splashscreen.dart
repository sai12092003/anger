import 'package:flutter/material.dart';
import '../userdata.dart';
import 'authoptions.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? userEmail;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Initialize HiveBox

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bgira.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 120.0, // adjust the top position based on your design
            left: 180.0, // adjust the left position based on your design
            child: Text(
              'IRA',
              style: TextStyle(
                color: Colors.white,
                fontSize: 35.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            bottom: 20.0, // adjust the bottom position based on your design
            left: 20.0, // adjust the left position based on your design
            right: 20.0, // adjust the right position based on your design
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>AuthPage() ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.black,
                padding: EdgeInsets.all(20.0),
              ),
              child: Text(
                'Start',
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
