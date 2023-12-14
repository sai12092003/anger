import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../PatientScreens/HomePageNav.dart';
import '../urls.dart';
import 'PatientLoginpage.dart';

class PatientSingPage extends StatefulWidget {
  const PatientSingPage({Key? key}) : super(key: key);

  @override
  State<PatientSingPage> createState() => _PatientSingPageState();
}
class _PatientSingPageState extends State<PatientSingPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _Mobile_noController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController = TextEditingController();

  void _signup () async{
    final name=_nameController.text.trim();
    final Mobileno=_Mobile_noController.text.trim();
    final Email=_emailController.text.trim();
    final Password=_passwordController.text.trim();
    final CofirmPassword=_confirmpasswordController.text.trim();
    if (name.isEmpty || Mobileno.isEmpty||Email.isEmpty || Password.isEmpty||CofirmPassword.isEmpty) {
      print("Fields cannot be empty");
      return;
    }

    //const url =  "http://192.168.97.89:5000/signup";
    final response = await http.post(
      Uri.parse(api.signup),
      headers: {"Content-Type": "application/json"},

      body: jsonEncode({"Email_ID": Email, "Password": Password,"Mobile_No":Mobileno,"Confirm_Password":CofirmPassword,"Name":name  }),
    );

    if (response.statusCode == 200) {

      print("Signup successful");
      Navigator.push(context, MaterialPageRoute(builder: (context) => PatientLoginPage()));
    } else if (response.statusCode == 402) {
      print("EmailID Already exists!");

    }else {
      print( jsonEncode({"Email_ID": Email, "Password": Password,"Mobile_No":Mobileno,"Confirm_Password":CofirmPassword,"Name":name  }),);

    print("SignUp failed");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             const  SizedBox(height: 40.0),
              FadeInUp(
                duration:const  Duration(milliseconds: 2000),
                child:Text(
                  "Let's Start",
                  style: TextStyle(
                    fontSize: 42.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[600],
                  ),
                ),),
              const SizedBox(height: 10.0),
              FadeInUp(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration:const  BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color.fromRGBO(143, 148, 251, 1)),
                    ),
                  ),
                  child: FadeInUp(
                    duration:const Duration(milliseconds: 2000),
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        suffixIcon:const Icon(Icons.account_circle),
                        border: InputBorder.none,
                        hintText: "Name ",
                        hintStyle: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              FadeInUp(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration:const  BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color.fromRGBO(143, 148, 251, 1)),
                    ),
                  ),
                  child: FadeInUp(
                    duration: Duration(milliseconds: 2000),
                    child: TextField(
                      controller: _Mobile_noController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.call),
                        border: InputBorder.none,
                        hintText: "Mobile Number ",
                        hintStyle: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              FadeInUp(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color.fromRGBO(143, 148, 251, 1)),
                    ),
                  ),
                  child: FadeInUp(
                    duration: Duration(milliseconds: 2000),
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(

                        suffixIcon: Icon(Icons.email),
                        border: InputBorder.none,
                        hintText: "Email ",
                        hintStyle: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              FadeInUp(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color.fromRGBO(143, 148, 251, 1)),
                    ),
                  ),
                  child: FadeInUp(
                    duration: Duration(milliseconds: 2000),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.lock),
                        border: InputBorder.none,
                        hintText: "Create Password ",
                        hintStyle: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              FadeInUp(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color.fromRGBO(143, 148, 251, 1)),
                    ),
                  ),
                  child: FadeInUp(
                    duration: Duration(milliseconds: 2000),
                    child: TextField(
                      controller: _confirmpasswordController,
                      obscureText: true,
                      decoration: InputDecoration(

                        suffixIcon: Icon(Icons.lock),
                        border: InputBorder.none,
                        hintText: "Confirm Password ",
                        hintStyle: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 60.0),
              FadeInUp(
                child: Container(
                  width: 400,
                  child: FadeInUp(
                    duration: Duration(milliseconds: 2000),
                    child: ElevatedButton(
                      onPressed: _signup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                      ),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 40.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PatientLoginPage()));
                },
                child: FadeInUp(
                  duration: Duration(milliseconds: 2000),
                  child: Center(
                    child: Text(
                      "Already  have an account? Sign In",
                      style: TextStyle(

                        fontSize: 18,

                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(143, 148, 251, 1),
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
