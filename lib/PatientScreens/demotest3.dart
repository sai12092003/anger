import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class CheckGivenImage extends StatefulWidget {
  final String email;

  const CheckGivenImage({Key? key, required this.email}) : super(key: key);

  @override
  State<CheckGivenImage> createState() => _CheckGivenImageState();
}

class _CheckGivenImageState extends State<CheckGivenImage> {
  String? base64Image;
  String accountantName="";
  late double height;
  late double weight;
  late double bmi=0.0;

  @override
  void initState() {
    super.initState();
      fetchImageWithRetry();
    initializeData();
  }
  Future<void> initializeData() async {
    await fetchAllDetailsWithRetry();
    await fetchImageWithRetry();
  }

  Future<void> fetchAllDetailsWithRetry() async {
    int maxRetries = 3;

    while (maxRetries > 0) {
      try {
        final response = await http.post(
          Uri.parse('http://192.168.86.89:5000/get_user_details'),
          headers: {
            'content-type': 'application/json',
            'Accept': 'application/json',
            'Connection': 'keep-alive',
          },
          body: jsonEncode({"Email_ID": widget.email}),
        ).timeout(Duration(seconds: 30));

        if (response.statusCode == 200) {
          Map<String, dynamic> detailsData = json.decode(response.body);


          setState(() {
            accountantName = detailsData["Name"].toString();
            weight = (detailsData["Weight"] );
            height = (detailsData["Height"] );
            print(height);
            print(weight);
            double heightInMeters = height / 100.0;
            print(heightInMeters);
            bmi=weight/(heightInMeters*heightInMeters);
            print(bmi);
            print(accountantName);

          });

          break; // Break out of the loop if successful
        } else {
          print('Failed to fetch details: ${response.statusCode}');
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

  Future<void> fetchImageWithRetry() async {
    fetchAllDetailsWithRetry();
    int maxRetries = 3;
    print(height);
    print(weight);
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
          //print('Base64 Image: $base64Image');

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
    return RefreshIndicator(
      onRefresh: () => fetchImageWithRetry(),
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            ClipPath(
              clipper: WaveClipperOne(),
              child: Container(
                height: 300,
                color: Colors.deepPurple[300],
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
                        '${accountantName}',
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
                _buildCard((bmi.roundToDouble()).toString(), Icons.accessibility,"BMI"),
                _buildCard('Card 2', Icons.access_alarm,"BMI"),
                _buildCard('Card 3', Icons.access_time,"Score 1"),
                _buildCard('Card 4', Icons.ac_unit,"Score 2"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, IconData icon,String Heading) {
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
            Heading,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            title,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
