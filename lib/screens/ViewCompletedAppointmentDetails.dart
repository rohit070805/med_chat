import 'package:flutter/material.dart';

import '../data/models/appointment_details_model.dart';
import '../utils/colors.dart';
class Viewcompletedappointmentdetails extends StatefulWidget {
  final AppointmentDetails details;
  const Viewcompletedappointmentdetails({super.key, required this.details});

  @override
  State<Viewcompletedappointmentdetails> createState() => _ViewcompletedappointmentdetailsState();
}

class _ViewcompletedappointmentdetailsState extends State<Viewcompletedappointmentdetails> {
  @override
  Widget build(BuildContext context) {
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
                                widget.details.doctor.name,
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
                          subtitle: Text(widget.details.doctor.category
                            ,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,letterSpacing: 3),
                          ),
                        ),
                        Divider(
                          thickness: .6,
                          color: AppColors.grey,
                        ),
                        Text("Doctor's Message",
                          style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,letterSpacing: 3),
                        ),
                        Text(
                          widget.details.appointment.doctorsMessage,
                          style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,letterSpacing: 3),
                        ),


                        Divider(
                          thickness: .6,
                          color: AppColors.grey,
                        ),







                        Text("Your Concern",
                          style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,letterSpacing: 3),
                        ),
                        Text(
                          widget.details.appointment.patientsConcern,
                          style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,letterSpacing: 3),
                        ),
                        SizedBox(height: 20,),

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
