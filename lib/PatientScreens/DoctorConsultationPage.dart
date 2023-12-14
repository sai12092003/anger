import 'package:flutter/material.dart';


class DoctorConsultationPage extends StatefulWidget {
  const DoctorConsultationPage({Key? key}) : super(key: key);

  @override
  State<DoctorConsultationPage> createState() => _DoctorConsultationPageState();
}

class _DoctorConsultationPageState extends State<DoctorConsultationPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text('Contact Doctor'),),
    );
  }
}
