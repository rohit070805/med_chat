import 'package:flutter/material.dart';
import 'package:med_chat/screens/auth_gate.dart';
import 'package:med_chat/utils/colors.dart';
import 'package:med_chat/utils/components.dart';

import '../data/models/patient_model.dart';
import '../data/services/auth_services.dart';
import '../data/services/firestore_services.dart';
class Userprofilepage extends StatefulWidget {
  const Userprofilepage({super.key});

  @override
  State<Userprofilepage> createState() => _UserprofilepageState();
}

class _UserprofilepageState extends State<Userprofilepage> {
  final AuthService _authService = AuthService();

  final FirestoreService _firestoreService = FirestoreService(); // Add FirestoreService

  // --- State Variables ---
  Patient? _patient; // To hold the fetched patient data
  bool _isLoading = true; //
  final TextEditingController _nameController  = TextEditingController();
  final TextEditingController _weightController  = TextEditingController();
  final TextEditingController _heightController  = TextEditingController();
  final TextEditingController _ageController  = TextEditingController();
  final TextEditingController _bloodgrpController  = TextEditingController();
  final TextEditingController _genderController  = TextEditingController();
  final TextEditingController _contactController  = TextEditingController();
  final TextEditingController _medicalDetailsController  = TextEditingController();
  final TextEditingController _emailController  = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch user data when the page loads instead of setting static text
    _loadUserData();
  }
  Future<void> _updateFieldInFirestore(String fieldKey, String newValue) async {
    if (_patient == null) return;

    // Convert the string value to the correct type if necessary
    dynamic processedValue = newValue;
    if (fieldKey == 'age') {
      processedValue = int.tryParse(newValue) ?? _patient!.age;
    } else if (fieldKey == 'weight' || fieldKey == 'height') {
      processedValue = double.tryParse(newValue) ?? 0.0;
    }

    try {
      final Map<String, dynamic> dataToUpdate = {fieldKey: processedValue};
      await _firestoreService.updatePatientDetails(_patient!.uid, dataToUpdate);

      // Reload the user data from Firestore to ensure UI is consistent
      await _loadUserData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${fieldKey.toUpperCase()} updated successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update $fieldKey.')),
        );
      }
    }
  }
  Future<void> _loadUserData() async {
    // Call the new method to get the current patient's data
    final patientData = await _firestoreService.getCurrentPatient();

    // Check if data was successfully fetched and the widget is still on screen
    if (patientData != null && mounted) {
      setState(() {
        _patient = patientData; // Store the patient object

        // Populate the controllers with data from the patient object
        _nameController.text = _patient!.name;
        _weightController.text = _patient!.weight?.toString() ?? '';
        _heightController.text = _patient!.height?.toString() ?? '';
        _ageController.text = _patient!.age?.toString() ?? '';
        _emailController.text = _patient!.email.toString()??'';
        _bloodgrpController.text = _patient!.bloodGroup ?? '';
        _genderController.text = _patient!.gender?.toUpperCase() ?? '';
        _contactController.text = _patient!.contactNumber ?? '';
        _medicalDetailsController.text = _patient!.medicalDetails ?? '';

        _isLoading = false; // Stop loading
      });
    } else if (mounted) {
      // Handle cases where the user data couldn't be loaded
      setState(() {
        _isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor:AppColors.appColor,
        shape:const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom:Radius.circular(30) )
        ),
        title: Text("User Profile",style: TextStyle(color: Colors.white,fontSize: 30),),
      ),
      body:  _isLoading
          ? const Center(child: CircularProgressIndicator()) // Show a loader while fetching data
          : _patient == null
          ? const Center(child: Text("Could not load profile.")) // Show error if patient is null
          :Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey ,
                      child: CircleAvatar(
                        radius: 39,
                        backgroundImage: AssetImage('assets/images/person.png'),
                        backgroundColor: Colors.grey.shade200,
                      )
                  ),
                  SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_nameController.text.toUpperCase(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      Text(_emailController.text,style: TextStyle(fontSize: 16),)
                    ],
                  ),
                  Spacer(),
                  IconButton(onPressed: ()async{

                    await _authService.signOut();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AuthGate()));
                  }, icon: Icon(Icons.logout_outlined,color: Colors.redAccent,size: 30,))
                ],
              ),
              SizedBox(height: 10,),
              Divider(thickness: 1,color: Colors.grey,),
              Text("Basic Details"),
              Components().normaltextFeild(context,_nameController, "Name",onSave: (newValue) async {
                // Pass the update logic, specifying the Firestore field key 'name'
                await _updateFieldInFirestore('name', newValue);
              },),
              SizedBox(width: 10),
              SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(
                    child:Components().withPrefixTextFeild(
                      context,
                      _weightController,
                      "Weight",
                      "Kg  ",
                      onSave: (newValue) async {
                        await _updateFieldInFirestore('weight', newValue);
                      },
                    )  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: Components().withPrefixTextFeild(context,_heightController, "Height", "CM  ",onSave: (newValue) async {
                      await _updateFieldInFirestore('height', newValue);
                    },)
          
                  )
                ]
          
              ),
              SizedBox(height: 10,),
              Row(
                  children: [
                    Expanded(
                      child: Components().normaltextFeild(context,_bloodgrpController, "Blood Group",onSave: (newValue) async {
                        await _updateFieldInFirestore('bloodGroup', newValue);
                      },),
          
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: Components().normaltextFeild(context,_ageController, "Age",onSave: (newValue) async {
                        await _updateFieldInFirestore('age', newValue);
                      },)
                    )
                  ]
          
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Components().withPrefixTextFeild(context,_contactController, "Contact Number", "+91  ",onSave: (newValue) async {
                      await _updateFieldInFirestore('contactNumber', newValue);
                    },)
                  ),
                  SizedBox(width: 10,),
          
                  Expanded(
                    flex: 2,
                    child: Components().normaltextFeild(context,_genderController, "Gender",onSave: (newValue) async {
                      await _updateFieldInFirestore('gender', newValue);
                    },),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Divider(thickness: 1,color: Colors.grey,),
              SizedBox(height: 10,),
          
          
              Components().normaltextFeild(context,_medicalDetailsController, "Medical Details",onSave: (newValue) async {
                await _updateFieldInFirestore('medicalDetails', newValue);
              },),
          
          
            ],
          ),
        ),
      )
    );
  }
}
