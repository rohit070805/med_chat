import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:med_chat/screens/AskMedicine.dart';
import 'package:med_chat/screens/HomePage.dart';
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
    Text("Hello"),
    Text("Hello"),
    Homepage(),
    Askmedicine(),
    Userprofilepage()

  ];
  final List<Widget> _navigationitems = [
    const Icon(Icons.add,color: Colors.white,),
    const Icon(Icons.travel_explore_outlined,color: Colors.white,),
    const Icon(Icons.home,color: Colors.white,),
    const Icon(Icons.people,color: Colors.white,),
    const Icon(Icons.ac_unit,color: Colors.white,)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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


