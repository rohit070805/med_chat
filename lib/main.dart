import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:med_chat/screens/AppointmentsPage.dart';
import 'package:med_chat/screens/AskMedicine.dart';
import 'package:med_chat/screens/HomePage.dart';
import 'package:med_chat/screens/SearchDoctorPage.dart';
import 'package:med_chat/screens/UserProfilePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BottomNavigate(),
    );
  }
}

class BottomNavigate extends StatefulWidget {
  const BottomNavigate({super.key});
  @override
  State<BottomNavigate> createState() => _BottomNavigateState();
}
class _BottomNavigateState extends State<BottomNavigate> {
  int myIndex = 2;
  List<Widget> _widgetList = [

    Homepage(),
    Askmedicine(),
    Searchdoctorpage(),
    Appointmentspage(),
    Userprofilepage()

  ];
  final List<Widget> _navigationitems = [
    const Icon(Icons.smart_toy_outlined,color: Colors.white,size: 25,),
    const Icon(Icons.local_pharmacy_outlined,color: Colors.white,size: 25),
    const Icon(Icons.home,color: Colors.white,size: 25),
    const Icon(Icons.calendar_month_sharp,color: Colors.white,size: 25),
    const Icon(Icons.person,color: Colors.white,size: 25)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _widgetList[myIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: myIndex,
        backgroundColor: Colors.white,
        color: Colors.blue,
        height: 55,
        items: _navigationitems,
        onTap: (index){
          setState(() {
            myIndex = index;
          });
        },

      ),
    );
  }
}


