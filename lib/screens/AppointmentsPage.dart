import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:med_chat/utils/colors.dart';
import 'package:med_chat/utils/components.dart';
class Appointmentspage extends StatefulWidget {
  const Appointmentspage({super.key});

  @override
  State<Appointmentspage> createState() => _AppointmentspageState();
}

class _AppointmentspageState extends State<Appointmentspage> {
  @override
  Widget build(BuildContext context) {
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
    final List<String> doctorTitles = [
      "Dr. Arjun Mehta ",
      "Dr. Priya Sharma",
      "Dr. Rohit Kapoor",
      "Dr. Neha Verma",
      "Dr. Sameer Khanna",
      "Dr. Anjali Rao",
      "Dr. Vikram Sinha",
      "Dr. Kavita Iyer",
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 30,
        backgroundColor: Colors.white,
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text("Upcoming",style: TextStyle(fontSize: 20,color: Colors.grey,fontWeight:FontWeight.w500,letterSpacing: 2),),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text("Appointments",style: TextStyle(fontSize: 30,color: AppColors.appColor,fontWeight:FontWeight.w500,letterSpacing: 2),),
          ),
          SizedBox(height: 10,),
          CarouselSlider(
            options: CarouselOptions(
              viewportFraction: 0.85,
              height: 130,

              enlargeCenterPage: true,

              autoPlay: true
            ),
            items: doctorTitles.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(

                      margin: EdgeInsets.symmetric( vertical:5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            offset: Offset(4, 4),
                            blurRadius: 10,
                            color: AppColors.grey.withOpacity(.7),
                          ),
                          BoxShadow(
                            offset: Offset(-3, 0),
                            blurRadius: 15,
                            color: AppColors.grey.withOpacity(.1),
                          )
                        ],
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                        child: Center(
                          child: ListTile(

                            contentPadding: EdgeInsets.all(0),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(13)),
                              child: Container(
                                height: 55,
                                width: 55,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Components().randomColor(),
                                ),
                                child: Image.asset(
                                  "assets/images/doctor.png",
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            title: Text(i, style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600)),
                            subtitle: Text("Sep-30 | 11:00 AM ",
                              style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500,fontSize: 16),
                            ),
                            trailing: Icon(
                              Icons.cancel_outlined,
                              size: 30,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      )
                  );
                },
              );
            }).toList(),
          ),
          SizedBox(height:10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Yet to be Approved",style: TextStyle(color: Colors.black54,fontSize: 18,fontWeight: FontWeight.w500,letterSpacing: 3),),
          ),
            Expanded(
              child: ListView.builder(
    itemCount: doctorTitles.length,
                  itemBuilder: (context,index){

                return  Container(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          offset: Offset(4, 4),
                          blurRadius: 10,
                          color: AppColors.grey.withOpacity(.4),
                        ),
                        BoxShadow(
                          offset: Offset(-3, 0),
                          blurRadius: 15,
                          color: AppColors.grey.withOpacity(.1),
                        )
                      ],
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(0),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(13)),
                          child: Container(
                            height: 55,
                            width: 55,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Components().randomColor(),
                            ),
                            child: Image.asset(
                              "assets/images/doctor.png",
                              height: 50,
                              width: 50,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        title: Text(doctorTitles[index], style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600)),
                        subtitle: Text(
                          doctorSubtitles[index],
                          style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500,fontSize: 16),
                        ),
                        trailing: Text("Withdraw",style: TextStyle(color: Colors.red,fontSize: 16),)
                      ),
                    )
                );
                  }),
            ),




        ],

      ),
    );
  }
}
