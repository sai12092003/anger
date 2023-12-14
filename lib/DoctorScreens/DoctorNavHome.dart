import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:ira/DoctorScreens/thirdtab.dart';
import 'package:ira/DoctorScreens/thoughtsCheckingpage.dart';
import 'package:iconsax/iconsax.dart';
import 'DoctorHomePage.dart';
import 'Upload page.dart';


class DhomePage extends StatefulWidget {
  final String email;
  const DhomePage({Key? key, required this.email}) : super(key: key);

  @override
  State<DhomePage> createState() => _DhomePageState();
}

class _DhomePageState extends State<DhomePage> {
  int _selectedIndex = 0;
  late final String _email = "";

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3), () {
     //_showCustomPopu();
    });
  }


  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  void _showCustomPopu() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(

          content: Column(

            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/popimage.png',
                height: 100,
                width: 200,
              ),

              Text(
                'Important!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Please Attend Anger Scale Questions',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Container(
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(

                      backgroundColor: Colors.deepPurple
                  ),
                  onPressed: () {

                  },
                  child: Text('Continue',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final List<Widget> _pages = [
      DoctorHomepage(),
      ThoughtsList(),
      UploadPage(),
      ThirdTab(email: widget.email,)
      //ProfileDetailsDisplay(email: _email),
      // Add other pages here
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        color: Colors.grey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 20),
          child: GNav(
            backgroundColor: Colors.grey,
            color: Colors.black,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey.shade800,
            gap: 10,
            onTabChange: _onTabChange,
            selectedIndex: _selectedIndex,
            padding: EdgeInsets.all(13),
            tabs: const [
              GButton(icon: Icons.home, text: 'Home',),
              GButton(icon: Icons.book_outlined, text: 'Dairy'),
              GButton(icon: Iconsax.video_add, text: 'Upload'),
              GButton(icon: Icons.account_circle, text: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }
}
