import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File? _videoFile;
  String? _selectedActivity;
  String? _selectedAnger;
  bool _isUploading = false;

  // Define a list of activities
  List<String> activityList = List.generate(26, (index) {
    int day = (index ~/ 2) + 1;
    int activity = index.isEven ? 1 : 2;
    return 'Day-$day Activity $activity';
  });

  List<String>angerscale=["Minimal Anger","Mild Anger","Moderate Anger","Sever Anger"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Upload Activities',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue.shade400),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedAnger,
                    hint: Text('Select Anger Scale'),
                    items: angerscale.map((item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedAnger = value;
                      });
                    },
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.black),
                    isExpanded: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),

                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue.shade400),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      DropdownButtonFormField<String>(
                        value:  _selectedActivity ,
                        hint: Text('Select Day & Activity'),
                        items: activityList.map((activity) {
                          return DropdownMenuItem<String>(
                            value: activity,
                            child: Text(activity),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedActivity = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

              GestureDetector(
                onTap: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['mp4', 'mov', 'avi'],
                  );

                  if (result != null) {
                    File file = File(result.files.single.path!);

                    setState(() {
                      _videoFile = file;
                    });
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: Radius.circular(10),
                    dashPattern: [10, 4],
                    strokeCap: StrokeCap.round,
                    color: Colors.blue.shade400,
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50.withOpacity(.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Iconsax.video_add, color: Colors.blue, size: 40),
                          SizedBox(height: 15),
                          Text(
                            _videoFile != null ? _videoFile!.path.split('/').last : 'Select your file',
                            style: TextStyle(fontSize: 15, color: Colors.grey.shade400),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 350,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,

                  ),
                  onPressed: _isUploading ? null : () {
                    // Handle upload button press
                    // You can add additional logic here

                      uploadFile(_videoFile!);

                  },
                  child: _isUploading
                      ? CircularProgressIndicator()
                      : Text('Upload'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void uploadFile(File file) async {
    setState(() {
      _isUploading = true;
    });

    try {
      // Create a multipart request
      if(_selectedActivity==null ||_selectedAnger==null||_videoFile==null)
        {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'All Fields are required',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
              duration: Duration(milliseconds: 500),
            ),
          );
          return;
        }
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.86.89:5000/upload_video?activity=$_selectedActivity&scale=$_selectedAnger'),
      );

      // Attach the file to the request
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      // Send the request
      var response = await request.send();

      // Check if the request was successful
      if (response.statusCode == 200) {
        print('File uploaded successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Uploaded Successfully',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
            duration: Duration(milliseconds: 500),
          ),
        );
        // Perform additional actions if needed
      } else {
        print('Failed to upload file: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _selectedAnger=null;
        _selectedActivity = null;
        _isUploading = false;
        _videoFile = null;
      });
    }
  }
}
