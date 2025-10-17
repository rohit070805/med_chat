import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:med_chat/screens/ViewCompletedAppointmentDetails.dart';
import 'package:med_chat/utils/colors.dart';
import 'package:med_chat/utils/components.dart';
import 'package:intl/intl.dart';
import '../data/models/appointment_details_model.dart';
import '../data/services/firestore_services.dart';
class Appointmentspage extends StatefulWidget {
  const Appointmentspage({super.key});

  @override
  State<Appointmentspage> createState() => _AppointmentspageState();
}

class _AppointmentspageState extends State<Appointmentspage> {
  final FirestoreService _firestoreService = FirestoreService();
  bool _isLoading = true;

  // Lists to hold the categorized appointments
  List<AppointmentDetails> _upcoming = [];
  List<AppointmentDetails> _pending = [];
  List<AppointmentDetails> _completed = [];

  @override
  void initState() {
    super.initState();
    _fetchAndCategorizeAppointments();
  }

  Future<void> _fetchAndCategorizeAppointments() async {
    setState(() { _isLoading = true; });

    final allAppointments = await _firestoreService.getMyAppointmentDetails();

    _upcoming.clear();
    _pending.clear();
    _completed.clear();

    for (var details in allAppointments) {
      final status = details.appointment.status;
      final date = details.appointment.appointmentDate;

      if (status == 'pending') {
        _pending.add(details);
      } else if (status == 'approved' && date != null && date.isAfter(DateTime.now())) {
        _upcoming.add(details);
      } else if (status == 'completed' || status == 'approved' && date != null && date.isBefore(DateTime.now())) {
        _completed.add(details);
      }
    }

    _upcoming.sort((a, b) => a.appointment.appointmentDate!.compareTo(b.appointment.appointmentDate!));

    if (mounted) {
      setState(() { _isLoading = false; });
    }
  }

  Future<void> _cancelOrWithdraw(String appointmentId) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Action'),
        content: const Text('Are you sure you want to cancel this appointment? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('No')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Yes')),
        ],
      ),
    );

    if (confirm == true) {
      try {
        // --- CHANGE THIS LINE ---
        // FROM: await _firestoreService.updateAppointmentStatus(appointmentId, 'cancelled');
        // TO:
        await _firestoreService.deleteAppointment(appointmentId);
        // -----------------------

        // Refresh the list after the deletion
        await _fetchAndCategorizeAppointments();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to cancel appointment: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 30,
        backgroundColor: Colors.white,
      ),
      body:_isLoading
    ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
    onRefresh: _fetchAndCategorizeAppointments,
    child: ListView(

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
          _upcoming.isEmpty==true?SizedBox(height: 130, child: Center(child: Text("No upcoming appointments.")))
             :     CarouselSlider(

            options: CarouselOptions(

              viewportFraction: 0.85,
              height: 130,

              enlargeCenterPage: true,

              autoPlay: true,
              enableInfiniteScroll: _upcoming.length > 1,
            ),

            items: _upcoming.map((i) {
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
                            title: Text(i.doctor.name, style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600)),
                            subtitle: Text(i.appointment.appointmentDate != null
                                ? DateFormat('MMM-dd | hh:mm a').format(i.appointment.appointmentDate!)
                                : 'Date not set',
                              style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500,fontSize: 16),
                            ),
                            trailing: IconButton(
                              onPressed: ()async{
                                await _cancelOrWithdraw(i.appointment.appointmentId);
                            },
                              icon: Icon(
                                Icons.cancel_outlined,
                                size: 30,
                                color: Colors.red,
                              ),
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
          _pending.isEmpty==true?SizedBox(height: 130, child: Center(child: Text("No pending appointments.")))
              :ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
                  itemCount: _pending.length,
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
                        title: Text(_pending[index].doctor.name, style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600)),
                        subtitle: Text(
                          _pending[index].doctor.category,
                          style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500,fontSize: 16),
                        ),
                        trailing: TextButton(
                            onPressed:  ()async{await _cancelOrWithdraw(_pending[index].appointment.appointmentId);},
                            child: Text("Withdraw",style: TextStyle(color: Colors.red,fontSize: 16),))
                      ),
                    )
                );
                  }),
          SizedBox(height:10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Completed",style: TextStyle(color: Colors.black54,fontSize: 18,fontWeight: FontWeight.w500,letterSpacing: 3),),
          ),
          _completed.isEmpty==true?SizedBox(height: 130, child: Center(child: Text("No completed appointments.")))
          :ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _completed.length,
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
                          title: Text(_completed[index].doctor.name, style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600)),
                          subtitle: Text(
                            _completed[index].doctor.category,
                            style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500,fontSize: 16),
                          ),
                          trailing: TextButton(
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>Viewcompletedappointmentdetails(details: _completed[index])));
                              },
                              child: Text("View Details",style: TextStyle(color: Colors.red,fontSize: 16),))
                      ),
                    )
                );
              }),




        ],

      ),)
    );
  }


}
