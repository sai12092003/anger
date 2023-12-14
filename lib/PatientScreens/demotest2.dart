import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CheckImages extends StatefulWidget {
  const CheckImages({Key? key}) : super(key: key);

  @override
  State<CheckImages> createState() => _CheckImagesState();
}

class _CheckImagesState extends State<CheckImages> {
  List<String> base64Images = [];

  @override
  void initState() {
    super.initState();
    fetchAllImagesWithRetry();
  }

  Future<void> fetchAllImagesWithRetry() async {
    int maxRetries = 3;

    while (maxRetries > 0) {
      try {
        final response = await http.get(
          Uri.parse('http://192.168.86.89:5000/fetch_all_images'),
          headers: {
            'content-type': 'application/json',
            'Accept': 'application/json',
            'Connection': 'keep-alive',
          },
        ).timeout(Duration(seconds: 30)); // Set a timeout for the request

        if (response.statusCode == 200) {
          List<Map<String, dynamic>> imagesData =
          List<Map<String, dynamic>>.from(json.decode(response.body));

          setState(() {
            base64Images =
                imagesData.map((image) => image["base64_image"].toString()).toList();
          });

          // Print base64_image values in the terminal
          base64Images.forEach((base64Image) {
            print(base64Image);
          });

          break; // Break out of the loop if successful
        } else {
          print('Failed to fetch images: ${response.statusCode}');
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
      appBar: AppBar(
        title: Text('Images'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: base64Images.length,
        itemBuilder: (context, index) {
          return Image.memory(
            base64Decode(base64Images[index]),
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
