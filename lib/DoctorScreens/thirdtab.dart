import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'dart:convert';
import 'package:http/http.dart'as http;


class ThirdTab extends StatefulWidget {
  final String email;
  const ThirdTab({Key? key, required this.email}) : super(key: key);

  @override
  State<ThirdTab> createState() => _ThirdTabState();
}

class _ThirdTabState extends State<ThirdTab> {
  String? base64Image;

  @override
  void initState() {
    super.initState();
    fetchImageWithRetry();
  }

  Future<void> fetchImageWithRetry() async {
    int maxRetries = 3;

    while (maxRetries > 0) {
      try {
        final response = await http.post(
          Uri.parse('http://192.168.86.89:5000/fetch_image'),
          headers: {
            'content-type': 'application/json',
            'Accept': 'application/json',
            'Connection': 'keep-alive',
          },
          body: jsonEncode({"Email_ID": widget.email}),
        ).timeout(Duration(seconds: 30));

        print('Response status code: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          Map<String, dynamic> imageData = json.decode(response.body);

          setState(() {
            base64Image = imageData["base64_image"].toString();
          });

          // Print base64_image value in the terminal
          print('Base64 Image: $base64Image');

          break; // Break out of the loop if successful
        } else {
          print('Failed to fetch image: ${response.statusCode}');
        }
      } catch (e) {
        print('Error: $e');
        maxRetries--;
        if (maxRetries > 0) {
          // Delay before making the next attempt
          await Future.delayed(Duration(seconds: 5));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          ClipPath(
            clipper: WaveClipperOne(),
            child: Container(
              height: 250,
              color: Colors.deepPurple,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: base64Image != null
                          ? MemoryImage(base64Decode(base64Image!)) as ImageProvider<Object>?
                          : AssetImage('assets/drpat.png') as ImageProvider<Object>?,
                      radius: 60,
                    ),

                    SizedBox(height: 10),
                    Text(
                      "Sai",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
            padding: EdgeInsets.all(16.0),
            children: [
              _buildCard('NO of Patients', Icons.accessibility),
              _buildCard('Card 2', Icons.access_alarm),
              _buildCard('Card 3', Icons.access_time),
              _buildCard('Card 4', Icons.accessibility),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String title, IconData icon) {
    return Card(
      elevation: 5.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48.0,
            color: Colors.deepPurple,
          ),
          SizedBox(height: 8.0),
          Text(
            title,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
