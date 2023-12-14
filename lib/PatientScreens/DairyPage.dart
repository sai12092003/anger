import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart'as http;
import 'package:ira/PatientScreens/settings.dart';
import 'dart:convert';
import 'Profilepage.dart';

class DairyPage extends StatefulWidget {
  final String email;
    const DairyPage({Key? key, required this.email, }) : super(key: key);

  @override
  State<DairyPage> createState() => _DairyPageState();
}

class _DairyPageState extends State<DairyPage> {
  TextEditingController _textEditingController = TextEditingController();
  bool _showShareButton = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  void shareThoughts() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.86.89:5000/insert_thoughts'),
        headers: {
          'content-type': 'application/json',
          'Accept': 'application/json',
          'Connection': 'keep-alive',
        },
        body: jsonEncode({
          "Email_ID": widget.email,
          "thoughts": _textEditingController.text,
        }),
      );

      if (response.statusCode == 200) {
        print('Thoughts shared successfully');
        // Clear the text controller
        _textEditingController.clear();
      } else {
        print('Failed to share thoughts: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false,),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Horizontal Calendar (You can replace this with your calendar widget)
            Container(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 30,
                itemBuilder: (context, index) {
                  DateTime currentDate = DateTime.now().add(Duration(days: index));
                  String formattedDate = DateFormat('dd/MM').format(currentDate);
                  bool isToday = DateTime.now().day == currentDate.day;

                  // Replace this with your calendar item widget
                  return Container(
                    width: 50,

                    decoration: BoxDecoration(color: isToday ? Colors.purple : Colors.grey,
                      borderRadius: BorderRadius.circular(13)
                    ),
                    margin: EdgeInsets.all(4),
                    alignment: Alignment.center,
                    child: Text(
                      formattedDate,
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            // Text Input Area
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _textEditingController,
                    maxLines: null,
                    onChanged: (text) {
                      setState(() {
                        // Show the Share button when there is text
                        _showShareButton = text.isNotEmpty;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Share your thoughts...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            // Share Button
            Visibility(
              visible: _showShareButton,
              child: Container(
                width: 150,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple[100],
                  ),
                  onPressed: () {
                    // Add your logic for sharing here
                    shareThoughts();
                    print('Sharing: ${_textEditingController.text}');
                  },
                  child: Text('Share'),
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }

}

