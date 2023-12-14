import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
import 'TrackActivity.dart';

class EmojiFeedback extends StatefulWidget {
  final String email;
  final String fn;
  final String day;
  final String activity;
  const EmojiFeedback({Key? key, required this.email, required this.fn, required this.day, required this.activity}) : super(key: key);

  @override
  State<EmojiFeedback> createState() => _EmojiFeedbackState();
}

class _EmojiFeedbackState extends State<EmojiFeedback> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "How Do you feel Now?",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: 10,
          itemBuilder: (context, index) {
            return _buildCard(index);
          },
        ),
      ),
    );
  }

  Widget _buildCard(int index) {
    // Define your pleasant colors here
    List<Color> pleasantColors = [
      Colors.blue.shade200,
      Colors.green.shade200,
      Colors.yellow.shade200,
      Colors.orange.shade200,
      Colors.red.shade200,
      Colors.purple.shade200,
      Colors.pink.shade200,
      Colors.teal.shade200,
      Colors.indigo.shade200,
      Colors.cyan.shade200,
    ];

    List<String> emotionNames = [
      'Joyful',
      'Happy',
      'Amazed',
      'Depression',
      'Chill',
      'Miserable',
      'Furious',
      'Irritated',
      'Manic',
      'Calm',
    ];

    return GestureDetector(
      onTap: () {

        sendData(widget.email,'${widget.day} ${widget.activity}',index+1,'${widget.fn}');
        print(index + 1); // Print the card number
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TrackActivity(email: widget.email)),
        );
      },
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        color: pleasantColors[index % pleasantColors.length],
        child: Container(
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/secondcardimg.png', // Replace with your actual asset path
                height: 90.0,
                width: 130.0,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 8.0),
              Text(
                emotionNames[index],
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void sendData(String email, String dayActivity,int feedback,String fn) async {
  print(dayActivity);
  String datact='Day-'+dayActivity;
  final response = await http.post(
    Uri.parse('http://192.168.86.89:5000/update_activity' ),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': email,
      'day_activity': datact,
      'feedbackscore':feedback,
      'scale':fn
    }),
  );

  if (response.statusCode == 200) {
    print('Data sent successfully');
  } else {
    print('Failed to send data. Status code: ${response.statusCode}');
  }
}