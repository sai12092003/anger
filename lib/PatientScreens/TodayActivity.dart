import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class TodaysActivity extends StatefulWidget {
  final String email;

  const TodaysActivity({Key? key, required this.email}) : super(key: key);

  @override
  State<TodaysActivity> createState() => _TodaysActivityState();
}

class _TodaysActivityState extends State<TodaysActivity> {
  late List<int> updateList=[];

  @override
  void initState() {
    super.initState();
    updateList = List<int>.filled(26, 0);
    CheckActivitycall();
  }

  void CheckActivitycall() async {
    final response = await http.post(
      Uri.parse('http://192.168.86.89:5000/get_activity_update'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': widget.email,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        updateList = List<int>.from(data['update_list']);
      });
      print('Data Refreshed successfully');
    } else {
      print('Failed to Refresh data. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Track Activities"),
      ),
      body: _buildActivityList(),
    );
  }

  Widget _buildActivityList() {
    List<String> activityItems = [];
    for (int day = 1; day <= 13; day++) {
      for (int activity = 1; activity <= 2; activity++) {
        activityItems.add('Day${day}_Activity_${activity}');
      }
    }

    return ListView.builder(
      itemCount: activityItems.length,
      itemBuilder: (context, index) {
        return BounceInLeft(
          duration: Duration(milliseconds: 100),
          delay: Duration(milliseconds: index * 50),
          child: Card(
            color: Colors.yellowAccent[100],
            elevation: 5.0,
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(16.0),
              title: Text(
                activityItems[index],
                style: TextStyle(fontSize: 18.0),
              ),
              leading: _buildRandomIcon(index),
              onTap: () {
                // Handle onTap event
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildRandomIcon(int index) {
    return Icon(
      updateList[index] == 1 ? Icons.check_circle : Icons.cancel,
      color: updateList[index] == 1 ? Colors.green : Colors.red,
      size: 30.0,
    );
  }
}
