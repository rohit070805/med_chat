import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:med_chat/screens/AppointmentsPage.dart';
import 'package:med_chat/screens/AskMedicine.dart';
import 'package:med_chat/screens/HomePage.dart';
import 'package:med_chat/screens/SearchDoctorPage.dart';
import 'package:med_chat/screens/UserProfilePage.dart';
import 'package:med_chat/screens/auth_gate.dart';
import 'package:med_chat/screens/loginPage.dart';
import 'package:med_chat/screens/signUpScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(


  );  
  //await FirebaseAuth.instance.getInitialUser();
  //listModels();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:AuthGate(),
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

    ChatScreen(),
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


