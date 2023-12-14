import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../OnboardingScreens/authoptions.dart';
import 'ChangeProfileDetails.dart';
import 'feedbackscreen.dart';




class ProfileSettingsPage extends StatefulWidget {
  final String email;
  final String img;
  const ProfileSettingsPage({Key? key, required this.email, required this.img}) : super(key: key);
  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  bool isRequestSent = false;
  String? base64Image;
  String accountantName = '';
  String occupation = '';

  @override
  void initState() {
    super.initState();

    fetchAllDetailsWithRetry();
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
            occupation = detailsData["Occupation"].toString();
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
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildProfileHeader(),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Security Settings'),
                  _buildSettingItem(
                    'Account Settings',
                    Icons.account_balance_wallet,
                        () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChangeProfileData(email: '${widget.email}',)));

                        },
                  ),

                  _buildSettingItem(
                    'Log Out',
                    Icons.exit_to_app,
                        () async{
                          final response = await http.post(
                            Uri.parse('http://192.168.86.89:5000/log_activity'),
                            headers: {
                              'Content-Type': 'application/json',
                            },
                            body: jsonEncode({'email': widget.email,"type":"s"}),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => AuthPage()),
                          );
                    },
                    textColor: Colors.red, // Change text color to red for Log Out
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Emergency'),
                  _buildSettingItem(
                    'Feedback',
                    Icons.messenger_outline,
                        () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => FeedbackScreen()),
                          );
                    },
                  ),
                  _buildSettingItem(
                    'Help & Support',
                    Icons.help,
                        () {
                      // Implement Help & Support logic
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(

      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.red[300],
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              SizedBox(height: 20), // Adjusted space for profile picture
              CircleAvatar(
                radius: 50,
                backgroundImage: widget.img != null
                    ? MemoryImage(base64Decode(widget.img!))
                    : AssetImage('assets/drpat.png') as ImageProvider<Object>?,
              ),
              SizedBox(height: 10),
              Text(
                accountantName, // Replace with the accountant's name
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
              ),
              SizedBox(height: 10),
              Text(
                occupation, // Add designation or description
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),
      ),
    );
  }

  Widget _buildSettingItem(
      String title, IconData icon, Function onTap, {Color textColor = Colors.black}) {
    return ListTile(
      onTap: () => onTap(),
      leading: Icon(icon),
      title: Text(title, style: TextStyle(color: textColor)),
      trailing: const Icon(Icons.arrow_forward_ios),
    );
  }

  Widget _buildSwitchSettingItem(
      String title, IconData icon, bool value, Function(bool) onChanged) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
