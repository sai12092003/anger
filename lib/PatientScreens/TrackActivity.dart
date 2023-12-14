import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:http/http.dart'as http;
import 'activitysession.dart';

class TrackActivity extends StatefulWidget {
  final String email;
  const TrackActivity({Key? key, required this.email}) : super(key: key);

  @override
  State<TrackActivity> createState() => _TrackActivityState();
}

class _TrackActivityState extends State<TrackActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track Activity'),
      ),
      body: ListView.builder(
        itemCount: 13,
        itemBuilder: (context, index) {
          return ElasticInLeft(
            duration: Duration(milliseconds: 500),
            child: _buildCard(index + 1),
          );
        },
      ),
    );
  }

  Widget _buildCard(int day) {
    List<Color> cardColors = [
      Colors.lightBlue,
      Colors.orangeAccent,
      Colors.amber,
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
      Colors.pink,
      Colors.teal,
      Colors.amber,
      Colors.cyan,
      Colors.deepOrange,
      Colors.deepPurple,
    ];

    return Card(
      color: cardColors[day - 1],
      elevation: 5.0,
      margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Day $day',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.0),
            Text(''),
            SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.blue, backgroundColor: Colors.white,
              ),
              onPressed: () {
                // Navigate to the new page with the respective color and day
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(
                      backgroundColor: cardColors[day - 1],
                      day: day, email: widget.email,
                    ),
                  ),
                );
              },
              child: Text('Start'),
            ),
          ],
        ),
      ),
    );
  }
}
class DetailPage extends StatelessWidget {
  final Color backgroundColor;
  final int day;
  final String email;

  const DetailPage({Key? key, required this.backgroundColor, required this.day, required this.email})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Day $day'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.maxFinite,
              height: 150,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Center(
                child: Text(
                  'Day $day',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: ListView(
                children: [
                  SizedBox(

                    child: GestureDetector(
                      onTap: ()async{
                        final response = await http.post(
                          Uri.parse('http://192.168.86.89:5000/check_activity'), // Replace with your actual API endpoint
                          headers: {'Content-Type': 'application/json'},
                          body: jsonEncode({
                            'email': '${email}',
                            'day_activity': 'Day-${day} Activity 1', // Replace with the actual day activity
                          }),
                        );
                        if(response.statusCode==200)
                          {
                            Map<String, dynamic> data = jsonDecode(response.body);
                            if(data['result']=='yes')
                            {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ActivitySessionPage(day: day, activity: 'Activity 1', email: '$email',),
                                ),
                              );
                            }
                            else
                              {
                                ScaffoldMessenger.of(context).showSnackBar(

                                  SnackBar(

                                    content: Text('Previous activity not completed!'),
                                    duration: Duration(seconds: 2),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                          }
                      },
                      child: TimelineTile(
                        alignment: TimelineAlign.manual,
                        lineXY: 0.1,
                        isFirst: true,
                        indicatorStyle: const IndicatorStyle(
                          width: 40,
                          color: Colors.blue,
                        ),
                        endChild: Container(

                          margin: const EdgeInsets.all(15),
                          padding: const EdgeInsets.symmetric(),
                          color: Colors.deepPurple[300],
                          constraints: const BoxConstraints(
                            minHeight: 100,

                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(child: Text('Activity 1',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)),
                          ),
                        ),
                        beforeLineStyle: LineStyle(color:Colors.deepPurple),
                      ),
                    ),
                    height: 100,
                  ),

                  SizedBox(
                    child: GestureDetector(
                      onTap: ()async{
                        final response = await http.post(
                          Uri.parse('http://192.168.86.89:5000/check_activity'), // Replace with your actual API endpoint
                          headers: {'Content-Type': 'application/json'},
                          body: jsonEncode({
                            'email': '${email}',
                            'day_activity': 'Day-${day} Activity 1', // Replace with the actual day activity
                          }),
                        );
                        if(response.statusCode==200)
                        {
                          Map<String, dynamic> data = jsonDecode(response.body);
                          if(data['result']=='yes')
                          {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ActivitySessionPage(day: day, activity: 'Activity 2', email: '$email',),
                              ),
                            );
                          }
                          else
                          {
                            ScaffoldMessenger.of(context).showSnackBar(

                              SnackBar(

                                content: Text('Previous activity not completed!'),
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      child: TimelineTile(

                        alignment: TimelineAlign.manual,
                        lineXY: 0.1,
                        indicatorStyle: const IndicatorStyle(
                          width: 40,
                          color: Colors.blue,

                        ),

                        endChild: Container(
                          margin: const EdgeInsets.all(15),
                          color: Colors.deepPurple[300],

                          constraints: const BoxConstraints(
                            minHeight: 120,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(child: Text('Activity 2',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20))),
                          ),
                        ),
                        beforeLineStyle: LineStyle(color:Colors.deepPurple),

                      ),
                    ),
                    height: 100,
                  ),
                  // Add more TimelineTile widgets for additional events
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}