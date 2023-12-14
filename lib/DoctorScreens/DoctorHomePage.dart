import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:http/http.dart' as http;

import 'PatientDetails.dart';
import 'Searchpage.dart';

class DoctorHomepage extends StatefulWidget {
  const DoctorHomepage({Key? key}) : super(key: key);

  @override
  State<DoctorHomepage> createState() => _DoctorHomepageState();
}

class _DoctorHomepageState extends State<DoctorHomepage> {
  List<Map<String, dynamic>> patients = [];
  String selectedCategory = 'Teen';

  @override
  void initState() {
    super.initState();
    fetchPatients();
  }

  Future<void> fetchPatients() async {
    try {
      var response = await http.get(
          Uri.parse('http://192.168.86.89:5000/get_details_with_images'),
          headers:{
      'content-type': 'application/json',
      'Accept': 'application/json',
      'Connection': 'keep-alive',
      } );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['details'];
        setState(() {
          patients = List<Map<String, dynamic>>.from(data);
        });
      } else {
        print('Failed to load patients: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              // Add your profile logic here
            },
          ),

        ],
        centerTitle: true,
        title: Text('IRA',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            SizedBox(height: 16.0),
            //_buildCategoryTitle('Recent Patients'),

            //SizedBox(height: 8.0),
           // _buildRecentPatients(),
            SizedBox(height: 15.0),
            _buildCategoryTitle('Patients'),
            SizedBox(height: 16.0),
            _buildCategoryRow(),
            SizedBox(height: 8.0),
            Expanded(
              child: _buildCardList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: InkWell(
            onTap: () async {
              List<Map<String, dynamic>>? searchResults = await showSearch(
                context: context,
                delegate: CustomSearchDelegate(patients),
              );

              if (searchResults != null) {

              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.search),
                  SizedBox(width: 8.0),
                  Text('Search Patients'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



  Widget _buildCategoryRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildCategoryButton('Teen'),
          _buildCategoryButton('Women'),
          _buildCategoryButton('Men'),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedCategory = category;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: selectedCategory == category ? Colors.blue : Colors.white24,
        ),
        child: selectedCategory == category
            ? Text(category, style: TextStyle(color: Colors.white))
            : Text(category, style: TextStyle(color: Colors.black)),
      ),
    );
  }

  Widget _buildRecentPatients() {
    return Container(
      height: 120.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (context, index) {
          return _buildRecentPatientCard(index + 1);
        },
      ),
    );
  }

  Widget _buildRecentPatientCard(int index) {
    return FadeInLeft(
      duration: Duration(milliseconds: 500),
      child: Container(
        width: 130,
        child: Card(
          color: Colors.yellow[200],
          elevation: 5.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30.0,
                backgroundImage: AssetImage('assets/drpat.png'),
              ),
              SizedBox(height: 8.0),
              Text(
                'Patients $index',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildCardList() {
    List<Map<String, dynamic>> filteredPatients = [];

    // Filter patients based on the selected category
    if (selectedCategory == 'Teen') {
      filteredPatients = patients.where((patient) => patient['Age'] < 20).toList();
    } else if (selectedCategory == 'Men') {
      filteredPatients = patients.where((patient) => patient['Gender'] == 'Male'&& patient['Age'] >= 20).toList();
    } else if (selectedCategory == 'Women') {
      filteredPatients = patients.where((patient) => patient['Gender'] == 'Female'&& patient['Age'] >= 20).toList();
    }
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: filteredPatients.length,
      itemBuilder: (context, index) {
        return FadeInUp(
          duration: Duration(milliseconds: 500),
          child: Container(

            height: 100,
            child: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => PatientDetails( email: filteredPatients[index]['Email_ID'], )));
              },
              child: Card(

                color: Colors.red[200],
                elevation: 5.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: filteredPatients[index]['ProfileImage'] != null
                          ? MemoryImage(base64Decode(filteredPatients[index]['ProfileImage']))
                          : AssetImage('assets/drpat.png') as ImageProvider<Object>?,
                      radius: 40,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      filteredPatients[index]['Name'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

}
class CustomSearchDelegate extends SearchDelegate<List<Map<String, dynamic>>> {
  final List<Map<String, dynamic>> patients;

  CustomSearchDelegate(this.patients);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () => query = '')];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, <Map<String, dynamic>>[]);
      },
    );
  }


  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(query);
  }

  Widget _buildSearchResults(String query) {
    final List<Map<String, dynamic>> results = patients
        .where((patient) => patient['Name'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.separated(
      itemCount: results.length,
      separatorBuilder: (context, index) => Divider(color: Colors.white),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            color: Colors.lightGreen[200],
            elevation: 3.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ListTile(
              selectedColor: Colors.green,
              splashColor: Colors.redAccent,
              contentPadding: EdgeInsets.all(16.0),
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: results[index]['ProfileImage'] != null
                    ? MemoryImage(base64Decode(results[index]['ProfileImage']))
                    : AssetImage('assets/default_profile.png') as ImageProvider<Object>?,
              ),
              title: Text(
                results[index]['Name'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              subtitle: Text(
                results[index]['Email_ID'],
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.blue,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PatientDetails(email: results[index]['Email_ID']),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

}
