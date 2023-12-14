import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileDetailsDisplay extends StatefulWidget {
  final String email;
  const ProfileDetailsDisplay({Key? key, required this.email}) : super(key: key);

  @override
  State<ProfileDetailsDisplay> createState() => _ProfileDetailsDisplayState();
}

class _ProfileDetailsDisplayState extends State<ProfileDetailsDisplay> {
  String profileImageUrl = '';

  @override
  void initState() {
    super.initState();
    // Call the function to fetch profile image when the widget is first created
    getProfileImage();
  }

  Future<void> getProfileImage() async {
    try {

      var response = await http.post(
        Uri.parse('http://192.168.86.89:5000/get_profile_image'),
        headers: {'Content-Type': 'application/json'},
        body: '{"Email_ID": "${widget.email}"}',
      );

      if (response.statusCode == 200) {
        // Parse the response JSON
        Map<String, dynamic> responseData = jsonDecode(response.body);

        // Get the profile image URL
        String imageUrl = responseData['ProfileImage'];

        // Update the state to trigger a rebuild
        setState(() {
          profileImageUrl = imageUrl;
        });

      } else {
        print('Failed to get profile image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Details'),
        centerTitle: true,
      ),
      body: Center(
        child: profileImageUrl.isNotEmpty
            ? ClipOval(
          child: Image.file(
            File(profileImageUrl),
            fit: BoxFit.cover, // You can adjust the BoxFit property based on your requirements
            width: 100.0, // Adjust the width and height as needed
            height: 100.0,
          ),
        )
        // Display the image using Image.network
            : CircularProgressIndicator(), // Display a loading indicator while fetching the image
      ),
    );
  }
}
