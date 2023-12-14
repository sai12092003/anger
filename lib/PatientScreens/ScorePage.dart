import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:http/http.dart'as http;
import 'LoadingActivityPage.dart';
import 'DoctorConsultationPage.dart'; // Import the DoctorConsultationPage

class ScorePage extends StatefulWidget {

  final int Score;
  final String email;

  const ScorePage({Key? key, required this.Score, required this.email}) : super(key: key);

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  bool slideComplete = false;

  @override
  void initState() {
    super.initState();
    postScoreData(); // Call the function to post data on initialization
  }
  Future<void> postScoreData() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.86.89:5000/update_score'), // Replace with your actual endpoint
        headers: {'Content-Type': 'application/json'},
        body: '{"email": "${widget.email}", "score_1": ${widget.Score}, "anger_scale_1": "${getClinicalAngerLevel(widget.Score)}"}',
      );

      if (response.statusCode == 200) {
        print('Score data posted successfully');
      } else {
        print('Failed to post score data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error posting score data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.teal, Colors.blue], // Set your desired gradient colors
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 150),
              ElasticIn(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    ' Quiz Score!',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.teal),
                  ),
                ),
              ),
              SizedBox(height: 30),
              FadeInUp(
                child: Container(
                  padding: EdgeInsets.all(60),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Column(
                    children: [
                      Text(
                        widget.Score.toString(),
                        style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.teal),
                      ),
                      SizedBox(height: 10),
                      Text(
                        getClinicalAngerLevel(widget.Score),
                        style: TextStyle(fontSize: 18, color: Colors.teal),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 250),
              // Slide to activate button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SlideAction(
                  innerColor: Colors.pink,
                  outerColor: Colors.indigo,
                  onSubmit: () {
                    setState(() {
                      slideComplete = true;
                    });

                    // Navigate to the loading activities page when sliding is complete
                    if (widget.Score > 63) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => DoctorConsultationPage()),
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoadingActivityPage(email: widget.email,)),
                      );
                    }
                  },
                  sliderButtonIcon: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                  child: Text(
                    'Slide to Continue',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getClinicalAngerLevel(int score) {
    if (score >= 1 && score <= 13) {
      return 'Minimal Anger';
    } else if (score >= 14 && score <= 19) {
      return 'Mild Anger';
    } else if (score >= 20 && score <= 28) {
      return 'Moderate Anger';
    } else if (score >= 29 && score <= 63) {
      return 'Sever Anger';
    } else {
      return 'Contact Doctor';
    }
  }
}
