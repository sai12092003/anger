// TODO Implement this library.
import 'dart:ui';
import 'package:flutter/material.dart';
import '../Authpage/PatientLoginpage.dart';
import '../Authpage/DoctorLogin.dart';



class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 55, right: 55, bottom: 100),
      child: SizedBox(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            const Spacer(),

            const Spacer(),
            Container(
              height: 55,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF2DD4BD), Color(0xFF7BC1F2)],
                ),
                borderRadius: BorderRadius.circular(100),
              ),
              child:  Center(
                  child: Container(
                    width: 400,
                    height: 100,
                    child: ElevatedButton(


                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorLogin()));

                      },child:const Text('Continue',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      style:ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.deepPurple,
                        disabledForegroundColor: Colors.deepPurple.withOpacity(0.38),
                        disabledBackgroundColor: Colors.grey.withOpacity(0.12),

                      ) , ),
                  )
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 55),
      child: SizedBox(
        height: 280,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            const Spacer(),

            const Spacer(),

            const SizedBox(
              height: 20,
            ),
            Container(
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
              child:  Center(
                  child: Container(
                    width: 400,
                    height: 100,
                    child: ElevatedButton(


                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PatientLoginPage()));

                      },child: const Text('Continue',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      style:ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.purple,
                        disabledForegroundColor: Colors.deepPurple.withOpacity(0.38),
                        disabledBackgroundColor: Colors.grey.withOpacity(0.12),

                      ) , ),
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}


