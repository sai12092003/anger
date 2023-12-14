import 'package:flutter/material.dart';

import 'HomePageNav.dart';

class LoadingActivityPage extends StatefulWidget {
  final String email;
  const LoadingActivityPage({Key? key, required this.email, }) : super(key: key);

  @override
  State<LoadingActivityPage> createState() => _LoadingActivityPageState();
}

class _LoadingActivityPageState extends State<LoadingActivityPage> {
  bool loadingRandom = true;

  @override
  void initState() {
    super.initState();
    // Start the loop when the widget is created
    _startLoadingLoop();
  }

  void _startLoadingLoop() {
    Future.delayed(Duration(seconds: 2), () {
      // Change the loading text and restart the loop
      setState(() {
        loadingRandom = !loadingRandom;
      });

      // Show the SnackBar after 3 seconds
      _showSnackBar();

      // Navigate to the HomePage after showing the SnackBar
      _navigateToHomePage();
    });
  }

  void _showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Loaded Successfully',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _navigateToHomePage() {
    Future.delayed(Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PhomePage(email: widget.email,)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(), // Loading indicator
            SizedBox(height: 20),
            Text(
              loadingRandom ? 'Loading Random' : 'Loading Activities',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}