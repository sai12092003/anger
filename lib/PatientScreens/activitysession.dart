import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ira/PatientScreens/playerpage.dart';
import 'package:video_player/video_player.dart';

class ActivitySessionPage extends StatefulWidget {
  final int day;
  final String activity;
  final String email;

  const ActivitySessionPage({
    Key? key,
    required this.day,
    required this.activity,
    required this.email,
  }) : super(key: key);

  @override
  State<ActivitySessionPage> createState() => _ActivitySessionPageState();
}

class _ActivitySessionPageState extends State<ActivitySessionPage> {
  String folderName = '';

  @override
  void initState() {
    super.initState();
    // Call the function to send POST request on initialization
    sendEmailToServer();
  }



  Future<void> sendEmailToServer() async {
    try {
      // Create a JSON payload
      Map<String, String> payload = {'email': '${widget.email}'};

      // Convert the payload to JSON format
      String jsonPayload = jsonEncode(payload);

      // Set the URL for the POST request
      String url = 'http://192.168.86.89:5000/get_anger_scale';

      // Send the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonPayload,
      );

      // Check the response status
      if (response.statusCode == 200) {
        // Handle the successful response if needed
        print('Email sent successfully');
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        setState(() {
          folderName = jsonResponse['anger_scale_1'];
        });

        // Navigate to PlayerPage and pass the video URL
        Navigator.pushReplacement(

          context,
          MaterialPageRoute(
            builder: (context) => PlayerPage(
              videoUrl:
              'http://192.168.86.89:5000/video_send?foldername=$folderName&filename=Day-${widget.day} ${widget.activity}',
              email: widget.email, Foldername: folderName, day: '${widget.day}', activity: '${widget.activity}',

            ),
          ),
        );
      } else {
        // Handle errors if needed
        print('Failed to send email. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions if needed
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Session'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'Day ${widget.day} - ${widget.activity}',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

