import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:ira/PatientScreens/settings.dart';
import 'InsightsPage.dart';
import 'Profilepage.dart';
import 'TodayActivity.dart';
import 'TrackActivity.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';


class PHomePage extends StatefulWidget {
  final String email;
  const PHomePage({Key? key, required this.email}) : super(key: key);



  @override
  State<PHomePage> createState() => _PHomePageState();
}

class _PHomePageState extends State<PHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchProfileImageWithRetry();
  }
  String? base64Image;
  Future<void> fetchProfileImageWithRetry() async {
    int maxRetries = 3;

    while (maxRetries > 0) {
      try {
        final response = await http.post(
          Uri.parse('http://192.168.86.89:5000/fetch_image'),
          headers: {
            'content-type': 'application/json',
            'Accept': 'application/json',
            'Connection': 'keep-alive',
          },
          body: jsonEncode({"Email_ID": widget.email}),
        ).timeout(Duration(seconds: 30));

        if (response.statusCode == 200) {
          Map<String, dynamic> imageData = json.decode(response.body);

          setState(() {
            base64Image = imageData["base64_image"].toString();
          });

          break; // Break out of the loop if successful
        } else {
          print('Failed to fetch image: ${response.statusCode}');
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
    return RefreshIndicator(
      onRefresh:() =>
        fetchProfileImageWithRetry(),

      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                // Add your notification logic here
              },
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileSettingsPage(email: widget.email, img: base64Image!,)));
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: CircleAvatar(
                  backgroundImage: base64Image != null
                      ? MemoryImage(base64Decode(base64Image!)) as ImageProvider<Object>?
                      : AssetImage('assets/drpat.png') as ImageProvider<Object>?,
                ),
              ),
            ),
          ],
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.0),
              Text(
                "Welcome,",
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 23.0),
              Expanded(
                child: ListView(
                  children: [
                    _buildAnimatedCard(
                      title: "Track activity",
                      color: Colors.blue,
                      imagePath: 'assets/firstcardimg.png',
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => TodaysActivity(email: '${widget.email}',)));
                      },
                    ),
                    _buildAnimatedCard(
                      title: " Activities",
                      color: Colors.green,
                      imagePath: 'assets/secondcardimg.png',
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => TrackActivity(email: widget.email,)));
                      },
                    ),
                    _buildAnimatedCard(
                      title: "Insights",
                      color: Colors.purple.shade700,
                      imagePath: 'assets/thirdcardimg.png',
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Insights(email: widget.email,)));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedCard({
    required String title,
    required Color color,
    required String imagePath,
    required void Function() onTap,
    bool reverse = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ElasticIn(
        child: Card(
          color: color,
          elevation: 9.0,
          child: InkWell(
            onTap: onTap,
            child: Row(
              children: [
                if (!reverse)
                  Expanded(
                    flex: 1,
                    child: Image.asset(
                      imagePath,
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                  ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.all(3),
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                if (reverse)
                  Expanded(
                    flex: 3,
                    child: Image.asset(
                      imagePath,
                      height: 170,
                      fit: BoxFit.cover,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
