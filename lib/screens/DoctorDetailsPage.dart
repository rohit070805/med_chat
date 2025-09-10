import 'package:flutter/material.dart';
import 'package:med_chat/screens/AskForAppointment.dart';
import 'package:med_chat/utils/colors.dart';
class Doctordetailspage extends StatefulWidget {
  const Doctordetailspage({super.key});

  @override
  State<Doctordetailspage> createState() => _DoctordetailspageState();
}

class _DoctordetailspageState extends State<Doctordetailspage> {
  @override
  Widget build(BuildContext context) {
    final String doctorAbout =
        "Dr. Arjun Mehta is a trusted Physician with over 15 years of experience in general medicine. He specializes in diagnosing and managing common illnesses such as fever, diabetes, hypertension, and seasonal infections. Dr. Mehta is well known for his patient-friendly approach and clear guidance on preventive healthcare. His focus is on providing accurate diagnoses, effective treatments, and helping patients maintain long-term wellness.";

    return Scaffold(
      backgroundColor: AppColors.extraLightBlue,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: <Widget>[
            Image.asset(
              'assets/images/doctor.png',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
              fit: BoxFit.fill,
            ),
            DraggableScrollableSheet(
              maxChildSize: .8,
              initialChildSize: .6,
              minChildSize: .6,
              builder: (context, scrollController) {
                return Container(
                  height: MediaQuery.of(context).size.height*0.7,
                  padding: EdgeInsets.only(left: 19, right: 19, top: 16),
                  //symmetric(horizontal: 19, vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    color: Colors.white,
                  ),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          contentPadding: EdgeInsets.all(0),
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Dr. Arjun Mehta",
                                style: TextStyle(fontSize: 30,letterSpacing:2,fontWeight: FontWeight.w600,color: AppColors.appColor),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(Icons.check_circle,
                                  size: 25,
                                  color: AppColors.appColor),

                            ],
                          ),
                          subtitle: Text("Heart Surgeon"
                              ,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,letterSpacing: 3),
                          ),
                        ),
                        Divider(
                          thickness: .6,
                          color: AppColors.grey,
                        ),
                        Text("About",
                          style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,letterSpacing: 3),
                        ),
                         Text(
                            "Experience:13 Yr.",
                            style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,letterSpacing: 3),
                          ),
                         Text("Education: Manipal University 2012",
                            style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,letterSpacing: 3),


                        ),







                        Text(
                          "${doctorAbout}",
                          style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,letterSpacing: 2),


                        ),
                        SizedBox(height: 20,),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(

                             shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(10)),
                              backgroundColor: AppColors.appColor
                                                  ),
                             onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>Askforappointment()));
                             },
                             child: Text(
                               "Make an appointment",
                                style: TextStyle(color: Colors.white,letterSpacing: 2,fontWeight: FontWeight.w400,fontSize: 18),
                             ),
                           ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}
