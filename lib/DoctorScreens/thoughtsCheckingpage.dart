import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ThoughtsList extends StatefulWidget {
  const ThoughtsList({Key? key}) : super(key: key);

  @override
  _ThoughtsListState createState() => _ThoughtsListState();
}

class _ThoughtsListState extends State<ThoughtsList> {
  late List<Map<String, dynamic>>? thoughtsData;

  @override
  void initState() {
    super.initState();
    fetchThoughts();
  }

  Future<void> fetchThoughts() async {
    final response = await http.get(Uri.parse('http://192.168.86.89:5000/fetch_thoughts'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        thoughtsData = List<Map<String, dynamic>>.from(data);
      });
    } else {
      print('Failed to fetch thoughts: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Thoughts Analysis',style: TextStyle(fontWeight: FontWeight.bold,),),
        automaticallyImplyLeading: false,
      ),
      body: thoughtsData == null
          ? Center(
        child: CircularProgressIndicator(),
      )
          : thoughtsData!.isEmpty
          ? Center(
        child: Text('No thoughts available.'),
      )
          : Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
        itemCount: thoughtsData!.length,
        itemBuilder: (context, index) {
            Map<String, dynamic> thought = thoughtsData![index];

            Color tileColor = thought['Output'] == 'NEGATIVE'
                ? Colors.red[100]!
                : Colors.green[100]!;

            return Card(
              color: tileColor,
              child: ListTile(
                title: Text(thought['Email_ID']),
                subtitle: Text(thought['thoughts']),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Date: ${DateTime.parse(thought['received_time']).toLocal().toString().split(" ")[0]}',
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      'Time: ${DateTime.parse(thought['received_time']).toLocal().toString().split(" ")[1]}',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                contentPadding: EdgeInsets.all(16),
                onTap: () {
                  // Handle item click if needed
                },
              ),
            );
        },
      ),
          ),
    );
  }
}
