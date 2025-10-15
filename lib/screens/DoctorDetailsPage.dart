import 'package:flutter/material.dart';
import 'package:med_chat/screens/AskForAppointment.dart';
import 'package:med_chat/utils/colors.dart';

import '../data/models/doctor_model.dart';
import '../data/services/firestore_services.dart';
class Doctordetailspage extends StatefulWidget {
  final String doctorId;
  const Doctordetailspage({super.key, required this.doctorId});

  @override
  State<Doctordetailspage> createState() => _DoctordetailspageState();
}

class _DoctordetailspageState extends State<Doctordetailspage> {
  final FirestoreService _firestoreService = FirestoreService();

  // 2. State variables for loading and doctor data
  bool _isLoading = true;
  Doctor? doctor;

  @override
  void initState() {
    super.initState();
    // 3. Fetch the doctor's details when the page loads
    _fetchDoctorDetails();
  }

  Future<void> _fetchDoctorDetails() async {
    final doctorData = await _firestoreService.getDoctorById(widget.doctorId);
    if (mounted) {
      setState(() {
        doctor = doctorData;
        _isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      backgroundColor: AppColors.extraLightBlue,
      body:_isLoading
          ? const Center(child: CircularProgressIndicator())
          : doctor == null
          ? const Center(child: Text('Doctor not found.'))
          :  SafeArea(
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
                                "Dr. ${doctor!.name.toString()}",
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
                          subtitle: Text(doctor!.category.toString()
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
                            "Experience:${doctor!.experienceInYears}",
                            style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,letterSpacing: 3),
                          ),
                         Text("Qualification: ${doctor!.qualification.toString()}",
                            style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,letterSpacing: 3),


                        ),
                        Divider(
                          thickness: .6,
                          color: AppColors.grey,
                        ),







                        Text(doctor!.about.toString(),
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
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>Askforappointment(doctor: doctor!,)));
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
