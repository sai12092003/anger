import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'HomePage.dart';
import 'HomePageNav.dart';

class DetailsUpdatePage extends StatefulWidget {
  final String email;
  const DetailsUpdatePage({Key? key, required this.email}) : super(key: key);

  @override
  State<DetailsUpdatePage> createState() => _DetailsUpdatePageState();
}

class _DetailsUpdatePageState extends State<DetailsUpdatePage> {
  var resJson;
  String base64Image = "";
  
  
  String _name = "";
  String _bio = "";
  String _email = "";
  String _phone = "";
  File? _profileImage;
  String? _selectedGender;
  String username = "";

  @override
  void initState() {
    super.initState();
    _getProfileData();
  }

  Future<void> _getProfileData() async {
    try {
      var response = await http.post(
        Uri.parse('http://192.168.86.89:5000/get_profile_image'),
        headers: {'Content-Type': 'application/json'},
        body: '{"Email_ID": "${widget.email}"}',
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        String _fetchedUsername = responseData['Name'];

        setState(() {
          username = _fetchedUsername;
        });
      } else {
        print('Failed to fetch profile data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if(pickedFile!=null)
      {
        List<int> imageBytes = await pickedFile.readAsBytes();
        base64Image = base64Encode(imageBytes);
      }
    if (pickedFile != null) {
      setState(()  {
        _profileImage = File(pickedFile.path);

      });
    }
  }
  Future<void> onUploadImage() async {
    try {
      if (base64Image.isEmpty) {

        return;
      }

      var response = await http.post(
        Uri.parse("http://192.168.86.89:5000/upload"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"image": base64Image,"Email_ID":widget.email}),
      );

      setState(() {
        resJson = jsonDecode(response.body);
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _updateDetails() async {
    try {



      onUploadImage();
      Map<String, dynamic> data = {
        'Email_ID': widget.email,
        'Age': _phone,
        'Height': _name,
        'Weight': _bio,
        'Gender': _selectedGender ?? '',
        'Occupation': _email,
        'ProfileImage': widget.email+'.jpg',
      };

      var response = await http.post(
        Uri.parse('http://192.168.86.89:5000/update_details'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );


      if (response.statusCode == 200) {
        print(jsonEncode(data));
        print('Details updated successfully');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Update successfully!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );

        Future.delayed(Duration(seconds: 1), () {
          // Replace with your actual route
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PhomePage(email: widget.email,)),
          );
        });
      } else {
        print('Failed to update details: ${response.statusCode}');
        print(jsonEncode(data));
        print('Request failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bio-Data'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : AssetImage('assets/profilebanner.png') as ImageProvider<Object>?,
                child: _profileImage != null
                    ? null
                    : Icon(
                  Icons.camera_alt,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              '$username',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 18),
            buildTextField("Age", "Age", (value) => _phone = value),
            buildTextField("Name", "Height (cm)", (value) => _name = value),
            buildTextField("Bio", "Weight (kg)", (value) => _bio = value),
            buildTextField("Email", "Occupation", (value) => _email = value),
            SizedBox(height: 12),
            buildDropdownField("Select your gender", ["Male", "Female", "Others"]),
            SizedBox(height: 29),
            Container(
              width: 400,
              child: ElevatedButton(
                onPressed: _updateDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Update',
                  style: TextStyle(fontSize: 21, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, String hintText, Function(String) onChanged) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color.fromRGBO(143, 148, 251, 1)),
        ),
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[700]),
        ),
      ),
    );
  }

  Widget buildDropdownField(String labelText, List<String> options) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey),
        ),
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: labelText,
          hintText: "Select an option",
          border: OutlineInputBorder(),
        ),
        value: _selectedGender,
        items: options.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedGender = newValue;
          });
        },
      ),
    );
  }
}
