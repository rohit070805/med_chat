import 'package:flutter/material.dart';
import 'package:med_chat/utils/colors.dart';
import 'package:med_chat/utils/components.dart';
class Searchdoctorpage extends StatefulWidget {
  const Searchdoctorpage({super.key});

  @override
  State<Searchdoctorpage> createState() => _SearchdoctorpageState();
}

class _SearchdoctorpageState extends State<Searchdoctorpage> {
  @override

  final List<String> doctorTitles = [
    "Dr. Arjun Mehta",
    "Dr. Priya Sharma",
    "Dr. Rohit Kapoor",
    "Dr. Neha Verma",
    "Dr. Sameer Khanna",
    "Dr. Anjali Rao",
    "Dr. Vikram Sinha",
    "Dr. Kavita Iyer",
  ];


  final List<String> doctorSubtitles = [
    "Physician / General Medicine",
    "Pediatrician",
    "Dermatologist",
    "Orthopedic Surgeon",
    "Cardiologist",
    "Ophthalmologist",
    "Gynecologist",
    "Dental Surgeon",
  ];
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,
      toolbarHeight: 10,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text("Hello,",style: TextStyle(fontSize: 25,color: Colors.grey),),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text("Rohit Kumar",style: TextStyle(fontSize: 35,letterSpacing: 3,color: AppColors.appColor,fontWeight: FontWeight.w500),),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                        height: 55,
                        margin: EdgeInsets.symmetric( vertical: 10),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(13)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 15,
                              offset: Offset(5, 5),
                            )
                          ],
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            border: InputBorder.none,
                            hintText: "Search Doctor",

                            suffixIcon: SizedBox(
                                width: 50,
                                child: Icon(Icons.search, color: AppColors.appColor)
                            ),
                          ),
                        )),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Category",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                          Text("See All",style: TextStyle(fontSize:18,color: AppColors.appColor),)
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 230,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
              
                          Components().categoryCard("General", "30+", color: Color(0xff4cd1bc), lightColor: Color(0xff5ed6c3)),
                          Components().categoryCard("Child", "20+", color: Color(0xff71b4fb), lightColor: Color(0xff7fbcfb)),
                          Components().categoryCard("Skin", "80+", color:Color(0xfffa8c73), lightColor: Color(0xfffa9881)),
                          Components().categoryCard("Bones", "50+", color: Color(0xff8873f4), lightColor: Color(0xff9489f4)),
              
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Top Doctors",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                          Icon(Icons.sort,color: AppColors.appColor,size: 30,)
                        ],
                      ),
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context,index){
              
                        return Components().doctorTile(context,doctorTitles[index], doctorSubtitles[index]);
                      },
                      itemCount: doctorTitles.length,
                    ),
                  ],
                ),
              ),
            )
          
           

            ],
        ),
      ),
    );
  }
}
