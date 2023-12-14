import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'AngerScaleQuestions.dart';
import 'DairyPage.dart';
import 'package:http/http.dart'as http;
import 'HomePage.dart';
import 'demotest3.dart';

class PhomePage extends StatefulWidget {
  final String email;

  const PhomePage({Key? key, required this.email}) : super(key: key);

  @override
  State<PhomePage> createState() => _PhomePageState();
}

class _PhomePageState extends State<PhomePage> {
  int _selectedIndex = 0;
  late final String _email = "";
  String? userEmail;

  @override
  void initState() {
    super.initState();

    _checkScore1(); // Call the method to check 'score_1' value
  }

  Future<void> _checkScore1() async {
    final url = 'http://192.168.86.89:5000/get_score_1';
    // Update with your Flask endpoint
    final loginact='http://192.168.86.89:5000/log_activity';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': widget.email}),
      );
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData.containsKey('error') && responseData['error'] == 'No entry found for the email') {
          // Handle case where no entry is found for the email
          _showCustomPopup();
        } else
        if (responseData.containsKey('score_1')) {
          int score1 = responseData['score_1'] as int;

          // Check if 'score_1' is 0 to decide whether to show the popup
          if (score1 == 0) {
            _showCustomPopup();
          }
        }
      } else {
        // Handle errors
        _showCustomPopup();
        print('HTTP POST request failed with status ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error in HTTP POST request: $e');
    }
    final response = await http.post(
      Uri.parse(loginact),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'email': widget.email,"type":"l"}),
    );
  }

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
                'Please Attend Anger Scale Questions',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Container(
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Close the popup
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AngerQuestions(email: widget.email)),
                    );
                  },
                  child: Text(
                    'Continue',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      PHomePage(email: widget.email),
      DairyPage(email: widget.email),
      CheckGivenImage(email: widget.email),
      //ProfileDetailsDisplay(email: _email),
      // Add other pages here
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        color: Colors.grey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 20),
          child: GNav(
            backgroundColor: Colors.grey,
            color: Colors.black,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey.shade800,
            gap: 10,
            onTabChange: _onTabChange,
            selectedIndex: _selectedIndex,
            padding: EdgeInsets.all(13),
            tabs: const [
              GButton(icon: Icons.home, text: 'Home'),
              GButton(icon: Icons.book_outlined, text: 'Dairy'),
              GButton(icon: Icons.account_circle, text: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }
}
