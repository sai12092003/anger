import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:ira/PatientScreens/HomePage.dart';
import 'package:localstorage/localstorage.dart';
import '../PatientScreens/FillDetailsPopupPage.dart';
import '../urls.dart';
import '../userdata.dart';
import 'PatientSignUp.dart';

class PatientLoginPage extends StatefulWidget {
  const PatientLoginPage({Key? key}) : super(key: key);

  @override
  State<PatientLoginPage> createState() => _PatientLoginPageState();
}
class _PatientLoginPageState extends State<PatientLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LocalStorage storage = LocalStorage('app_data');

  void _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      print("Email and password cannot be empty");
      return;
    }


    //const url =  "http://192.168.97.89:5000/login";
    final response = await http.post(
      Uri.parse(api.login),
      headers: {"Content-Type": "application/json"},

      body: jsonEncode({"Email_ID": email, "Password": password}),
    );

    if (response.statusCode == 200) {

      print("Login successful");

      Navigator.push(context, MaterialPageRoute(builder: (context) => popupdetails(email: email,)));


      _emailController.clear();
      _passwordController.clear();
    }

    else {
    print(response.statusCode );
      print( jsonEncode({"Email_ID": email, "Password": password}));
      print("login failed");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[100],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             const  SizedBox(height: 60.0),
          FadeInUp(
            duration:const  Duration(milliseconds: 1000),
              child:const Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 42.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),),
              FadeInUp(
                duration:const Duration(milliseconds: 1000),
                child:const Text(
                  'Back!',
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
              ),
              const SizedBox(height: 90.0),
              FadeInUp(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(

                    border: Border(
                      bottom: BorderSide(color: Color.fromRGBO(143, 148, 251, 1)),
                    ),
                  ),
                  child: FadeInUp(
                    duration: Duration(milliseconds: 1000),
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
                    duration: Duration(milliseconds: 1000),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.lock),
                        border: InputBorder.none,
                        hintText: "Password ",
                        hintStyle: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 60.0),
              Container(
                width: 400,
                child: FadeInUp(
                  duration: Duration(milliseconds: 1000),
                  child: ElevatedButton(
                    onPressed:_login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PatientSingPage()));

                },
                child: FadeInUp(
                  duration: Duration(milliseconds: 1000),
                  child: Center(
                    child: Text(
                      "Don't have an account? Sign Up",
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



