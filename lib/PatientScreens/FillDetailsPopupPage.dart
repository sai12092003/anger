import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:http/http.dart' as http;
import 'DetailsFillingPage.dart';
import 'HomePage.dart';
import 'HomePageNav.dart';

class popupdetails extends StatefulWidget {
  const popupdetails({Key? key, required this.email}) : super(key: key);
  final String email;
  @override
  State<popupdetails> createState() => _popupdetailsState();
}

class _popupdetailsState extends State<popupdetails> {

  Future<void> onUploadImage() async {
    try {


      var response = await http.post(
        Uri.parse("http://192.168.86.89:5000/check_data_completion"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"Email_ID":widget.email}),
      );
      if (response.statusCode == 200) {

        print('data filled');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PhomePage(email: widget.email,)),
        );

      } else if (response.statusCode==300) {
        _showCustomPopup();
      }


    } catch (e) {
      print("Error: $e");
    }
  }




  @override
  void initState() {
    super.initState();
    // Use Future.delayed to avoid modifying the widget tree during the build phase

      onUploadImage();

  }

  void _showCustomPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(

          content: Column(

            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/popimage.png',
                height: 100,
                width: 200,
              ),

              Text(
                'Important!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Please fill your details.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Container(
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(

                    backgroundColor: Colors.deepPurple
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Close the popup
                    _navigateToHomePage();
                  },
                  child: Text('Continue',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DetailsUpdatePage(email: widget.email,)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Add your notification logic here
            },
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: CircleAvatar(
              backgroundImage: AssetImage(
                  'assets/drpat.png'), // Replace with your image asset
            ),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.0),
            Text(
              "Welcome Sai,",
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 23.0),
            Expanded(
              child: ListView(
                children: [
                  _buildAnimatedCard(
                    title: "Today's activity",
                    color: Colors.blue,
                    imagePath: 'assets/firstcardimg.png',
                  ),
                  _buildAnimatedCard(
                    title: "Track activity",
                    color: Colors.green,
                    imagePath: 'assets/secondcardimg.png',
                  ),
                  _buildAnimatedCard(
                    title: "Insights",
                    color: Colors.purple.shade700,
                    imagePath: 'assets/thirdcardimg.png',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedCard({
    required String title,
    required Color color,
    required String imagePath,
    bool reverse = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ElasticIn(
        child: Card(
          color: color,
          elevation: 9.0,
          child: Row(
            children: [
              if (!reverse)
                Expanded(
                  flex: 1,
                  child: Image.asset(
                    imagePath,
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(

                    padding: EdgeInsets.all(3),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              if (reverse)
                Expanded(
                  flex: 3,
                  child: Image.asset(
                    imagePath,
                    height: 170,
                    fit: BoxFit.cover,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}