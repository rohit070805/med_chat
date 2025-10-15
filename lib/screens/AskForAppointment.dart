import 'package:flutter/material.dart';
import 'package:med_chat/utils/components.dart';
import 'package:uuid/uuid.dart';

import '../data/models/appointment_model.dart';
import '../data/models/doctor_model.dart';
import '../data/models/patient_model.dart';
import '../data/services/firestore_services.dart';
import '../utils/colors.dart';
class Askforappointment extends StatefulWidget {
  final Doctor doctor;
  const Askforappointment({super.key, required this.doctor});

  @override
  State<Askforappointment> createState() => _AskforappointmentState();
}

class _AskforappointmentState extends State<Askforappointment> {
  final TextEditingController _issueController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  bool _isLoading = true;
  Patient? _currentPatient;

  @override
  void initState() {
    super.initState();
    _fetchCurrentPatient();
  }

  Future<void> _fetchCurrentPatient() async {
    final patientData = await _firestoreService.getCurrentPatient();
    if (mounted) {
      setState(() {
        _currentPatient = patientData;
        _isLoading = false;
      });
    }
  }

  Future<void> _submitAppointment() async {
    final patient = _currentPatient;
    if (patient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Patient data not available.')),
      );
      return;
    }
    if (_issueController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please describe your medical issue.')),
      );
      return;
    }
    setState(() { _isLoading = true; });

    try {
      var uuid = const Uuid();
      final newAppointment = Appointment(
        appointmentId: uuid.v4(),
        patientId: patient.uid,
        doctorId: widget.doctor.uid,
        status: 'pending',
        patientsConcern: _issueController.text.trim(),
        appointmentDate: null,
        doctorsMessage: '',
      );
      await _firestoreService.createAppointment(newAppointment);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Appointment request sent successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send request: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:  AppBar(

        centerTitle: true,

        titleTextStyle:TextStyle(letterSpacing: 3),
        automaticallyImplyLeading: false,
        backgroundColor:AppColors.appColor,
        shape:const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom:Radius.circular(30) )
        ),
        title: Text("Book Appointment",style: TextStyle(color: Colors.white,fontSize: 26,fontWeight: FontWeight.w500),),
      ),
      body: 
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Container(


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
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Components().randomColor(),
                    ),
                    child: Image.asset(
                      "assets/images/doctor.png",
                      height: 100,
                      width: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                title: Text(widget.doctor.name, style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600)),
                subtitle: Text(
                  widget.doctor.category,
                  style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500,fontSize: 16),
                ),

              ),
            )
              ) ,
            SizedBox(height: 10,),
            Text("Patient Details",style: TextStyle(fontSize: 22,color: Colors.black54,letterSpacing: 2),),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _currentPatient == null
                    ? const Center(child: Text('Could not load patient data.'))
                    : Column(
                  children: [
                    ListTile(
                      leading:   CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey ,
                          child: CircleAvatar(
                            radius: 29,
                            backgroundImage: AssetImage('assets/images/person.png'),
                            backgroundColor: Colors.grey.shade200,
                          )
                      ),
                      title: Text(_currentPatient!.name,style: TextStyle(fontSize: 18,letterSpacing: 2,fontWeight: FontWeight.w400),),
                      subtitle: Text("Age: ${_currentPatient!.age}, ${_currentPatient!.gender}"),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.email),
                      title: Text(_currentPatient!.email),
                    ),
                    Row(

                      children: [
                        Expanded(
                          flex: 1,
                          child: ListTile(
                            leading: Icon(Icons.water_drop,color: Colors.red,),
                            title: Text(_currentPatient!.bloodGroup!),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: ListTile(
                            leading: Icon(Icons.height,color: Colors.black54,),
                            title: Text(_currentPatient!.height.toString()),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: ListTile(
                            leading: Icon(Icons.monitor_weight_outlined,color: Colors.black54,),
                            title: Text(_currentPatient!.weight.toString()),
                          ),
                        ),
                      ],
                    ),


                  ],
                ),
              ),
              SizedBox(height: 10,),
              Text("Medical Issue",style: TextStyle(fontSize: 22,color: Colors.black54,letterSpacing: 2),),
              SizedBox(
                height: 10,
              ),
          TextField(
          style: TextStyle(fontSize: 18),
          controller: _issueController,
          maxLines: 8,
          decoration: InputDecoration(
            alignLabelWithHint: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1.5
                )
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1.5
                )
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1.5
                )
            ),
           hintText: "Enter Your Concern Here..",
            hintStyle: TextStyle(fontSize: 18,color: Colors.black54,letterSpacing: 2)





              ),






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
                    _submitAppointment();
                   },
                  child: Text(
                    "Submit Request",
                    style: TextStyle(color: Colors.white,letterSpacing: 2,fontWeight: FontWeight.w400,fontSize: 18),
                  ),
                ),
              )



            ],
          ),
        ),
      ),
    );
  }
}
