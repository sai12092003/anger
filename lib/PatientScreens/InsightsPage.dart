import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';


class DataItem {
  int x;
  double y1;
  double y2;
  double y3;

  DataItem({required this.x, required this.y1, required this.y2, required this.y3});
}

class Insights extends StatefulWidget {
  final String email;
  const Insights({Key? key, required this.email}) : super(key: key);

  @override
  State<Insights> createState() => _InsightsState();
}
class _InsightsState extends State<Insights> {
  late List<DataItem> _chartData;
  late List<DataItem> _horizontalChartData;

  double score1 = 0.0, score2 = 0.0;
  int negativeCount = 0, positiveCount = 0;

  @override
  void initState() {
    super.initState();

    // Vertical Bar Chart Data
    _chartData = [
      DataItem(x: 0, y1: 75.0, y2: 8.0, y3: 0.0),
      DataItem(x: 1, y1: 10.0, y2: 12.0, y3: 0.0),
    ];

    // Horizontal Bar Chart Data
    _horizontalChartData = List.generate(10, (index) => DataItem(x: index, y1: index.toDouble(), y2: 0.0, y3: 0.0));
    _fetchMoodCount();
    _checkScore1();
  }

  Future<void> _fetchMoodCount() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.86.89:5000/mood_count'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': widget.email}),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> moodCount = jsonDecode(response.body);

        // Define a list of mood names in the correct order
        List<String> moodListOrder = [
          "joyful",
          "happy",
          "amazed",
          "depression",
          "chill",
          "miserable",
          "furious",
          "irritated",
          "manic",
          "calm",
        ];

        // Update the _horizontalChartData list based on the received data
        _horizontalChartData = moodListOrder.map((mood) {
          final count = moodCount[mood] ?? 0;
          return DataItem(x: moodListOrder.indexOf(mood), y1: count.toDouble(), y2: 0.0, y3: 0.0);
        }).toList();

        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

    Future<void> _checkScore1() async {
    final url = 'http://192.168.86.89:5000/check_thoughts_count'; // Update with your Flask endpoint

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': widget.email}),
      );

      final response2 = await http.post(
        Uri.parse('http://192.168.86.89:5000/thoughts_count'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': widget.email}),
      );

      if (response2.statusCode == 200) {
        // Parse the JSON response
        Map<String, dynamic> thoughtsCount = jsonDecode(response2.body);

        // Extract 'NEGATIVE' and 'POSITIVE' counts
        negativeCount = thoughtsCount['NEGATIVE'] ?? 0;
        positiveCount = thoughtsCount['POSITIVE'] ?? 0;
      }

      // Assuming your API response contains 'score1' and 'score2' fields
      score1 = negativeCount.toDouble();
      score2 = positiveCount.toDouble();

      // Update Vertical Bar Chart Data
      setState(() {
        _chartData = [
          DataItem(x: 0, y1: score1, y2: 12.0, y3: 0.0),
          DataItem(x: 1, y1: score2, y2: 12.0, y3: 0.0),
        ];
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Insights'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 60,
              ),
              SizedBox(
                width: 300, // Set the desired width
                height: 210, // Set the desired height
                child: BarChart(
                  BarChartData(
                    // Hide axes
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(
                      // Show only bottom titles
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        axisNameWidget: Text("Sentiment", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        sideTitles: SideTitles(
                          showTitles: true,

                          getTitlesWidget: (double value, TitleMeta meta) {
                            if (value == 0) {
                              return Text("Negative", style: TextStyle(fontSize: 12));
                            } else if (value == 1) {
                              return Text("Postive", style: TextStyle(fontSize: 12));
                            }







                            return const SizedBox(); // Empty space for other values
                          },
                        ),
                      ),
                    ),
                    barGroups: _chartData
                        .map((dataItem) => BarChartGroupData(
                      x: dataItem.x,
                      barRods: [
                        BarChartRodData(
                            toY: dataItem.y1, width: 22, color: Colors.amber),
                      ],
                    ))
                        .toList(),
                  ),
                ),
              ),
              SizedBox(
                height: 90,
              ),
              Container(

                height: 250,
                width: 350,
                child: SizedBox(

                  width: 300,
                  height: 210,
                  child: RotatedBox(
                    quarterTurns: 0,
                    child: HorizontalBarChart(
                      BarChartData(
                        // Hide axes
                        groupsSpace: 15,
                        borderData: FlBorderData(show: true,
                        ),
                        gridData: FlGridData(show: true),
                        titlesData: FlTitlesData(
                          // Show only left titles
                          bottomTitles: AxisTitles(
                            axisNameWidget: Text("Most Common Mood", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            sideTitles: SideTitles(

                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                if (value == 0) {
                                  return Text("Joy", style: TextStyle(fontSize: 12));
                                } else if (value == 1) {
                                  return Text("Hap", style: TextStyle(fontSize: 12));
                                }
                                else if (value == 2) {
                                  return Text("amaz", style: TextStyle(fontSize: 12));
                                }
                                else if (value == 3) {
                                  return Text("dep", style: TextStyle(fontSize: 12));
                                }
                                else if (value == 4) {
                                  return Text("chil", style: TextStyle(fontSize: 12));
                                }
                                else if (value == 5) {
                                  return Text("mise", style: TextStyle(fontSize: 12));
                                }else if (value == 6) {
                                  return Text("fur", style: TextStyle(fontSize: 12));
                                }else if (value == 7) {
                                  return Text("irri", style: TextStyle(fontSize: 12));
                                }else if (value == 8) {
                                  return Text("mnic", style: TextStyle(fontSize: 12));
                                }else if (value == 9) {
                                  return Text("clam", style: TextStyle(fontSize: 12));
                                }
                                return const SizedBox(); // Empty space for other values
                              },
                            ),
                          ),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          leftTitles: AxisTitles(

                            //axisNameWidget: Text("Values", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                              sideTitles: SideTitles(showTitles: false)
                          ),
                        ),
                        barGroups: _horizontalChartData
                            .map((dataItem) => BarChartGroupData(
                          x: dataItem.x,
                          barRods: [
                            BarChartRodData(
                              toY: dataItem.y1, // Use toY for the horizontal bar chart
                              color: Colors.green,
                            ),
                          ],
                        ))
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HorizontalBarChart extends StatelessWidget {
  final BarChartData data;

  const HorizontalBarChart(this.data);

  @override
  Widget build(BuildContext context) {
    return BarChart(
      data,
      swapAnimationDuration: const Duration(milliseconds: 500),
      swapAnimationCurve: Curves.easeInOutBack,
       // Use grouped stacking
    );
  }
}


