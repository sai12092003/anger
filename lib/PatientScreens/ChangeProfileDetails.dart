import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:ira/PatientScreens/settings.dart';

class ChangeProfileData extends StatefulWidget {
  final String email;

  const ChangeProfileData({Key? key, required this.email}) : super(key: key);

  @override
  State<ChangeProfileData> createState() => _ChangeProfileDataState();
}

class _ChangeProfileDataState extends State<ChangeProfileData> {
  var resJson;
  String base64Image = "";

  String _name = "";
  String _bio = "";
  String _email = "";
  String _phone = "";
  File? _profileImage;
  String? _selectedGender;
  String username = "";
  final ImagePicker _imagePicker = ImagePicker();

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
        setState(() {
          _name = responseData['Name'];
          _bio = responseData['Occupation'];
          _email = responseData['Email_ID'];
          _phone = responseData['Mobile_No'];
          _selectedGender = responseData['Gender'];
          username = _name;
        });
      } else {
        print('Failed to fetch profile data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      List<int> imageBytes = await pickedFile.readAsBytes();
      base64Image = base64Encode(imageBytes);
      setState(() {
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
        body: jsonEncode({"image": base64Image, "Email_ID": widget.email}),
      );
      if(response.statusCode==200)
        {
          ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Updated Profile ',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfileSettingsPage(email: '${widget.email}', img: '${base64Image}',)));

        }

      setState(() {
        resJson = jsonDecode(response.body);
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Edit Profile')),
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
            buildTextField("Name", _name, (value) => _name = value),
            buildTextField("Bio", _bio, (value) => _bio = value),
            buildTextField("Email", _email, (value) => _email = value),
            buildTextField("Phone", _phone, (value) => _phone = value),
            SizedBox(height: 12),
            buildDropdownField("Select your gender", ["Male", "Female", "Others"], _selectedGender),
            SizedBox(height: 29),
            Container(
              width: 400,
              child: ElevatedButton(
                onPressed: onUploadImage,
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

  Widget buildTextField(String labelText, String value, Function(String) onChanged) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color.fromRGBO(143, 148, 251, 1)),
        ),
      ),
      child: TextField(
        controller: TextEditingController(text: value),
        onChanged: onChanged,
        enabled: false, // Make the text field not editable
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.grey[700]),
        ),
      ),
    );
  }

  Widget buildDropdownField(String labelText, List<String> options, String? selectedGender) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border(

        ),
      ),

    );
  }
}



