// SearchResults.dart

import 'package:flutter/material.dart';

import 'PatientDetails.dart';

class SearchResults extends StatelessWidget {
  final List<Map<String, dynamic>> searchResults;

  SearchResults({required this.searchResults});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(searchResults[index]['Name']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PatientDetails(email: searchResults[index]['Email_ID']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
