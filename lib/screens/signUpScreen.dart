import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:med_chat/main.dart';
import 'package:med_chat/screens/loginPage.dart';
import 'package:med_chat/utils/colors.dart';

import '../data/models/patient_model.dart';
import '../data/services/auth_services.dart';
import '../utils/components.dart';
class Signupscreen extends StatefulWidget {
  const Signupscreen({super.key});

  @override
  State<Signupscreen> createState() => _SignupscreenState();
}

class _SignupscreenState extends State<Signupscreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  final _authService = AuthService();
  final TextEditingController _nameController  = TextEditingController();
  final TextEditingController _emailController  = TextEditingController();
  final TextEditingController _passwordController  = TextEditingController();

  final TextEditingController _weightController  = TextEditingController();
  final TextEditingController _heightController  = TextEditingController();
  final TextEditingController _ageController  = TextEditingController();
  final TextEditingController _bloodgrpController  = TextEditingController();
  final TextEditingController _genderController  = TextEditingController();
  final TextEditingController _contactController  = TextEditingController();
  final TextEditingController _medicalDetailsController  = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    // Dispose controllers to free up resources
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _bloodgrpController.dispose();
    _ageController.dispose();
    _contactController.dispose();
    _genderController.dispose();
    _medicalDetailsController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    // Validation
    if (_emailController.text.trim().isEmpty) {
      _showError('Please enter your email');
      return;
    }

    if (_nameController.text.trim().isEmpty) {
      _showError('Please enter your name');
      return;
    }

    if (_passwordController.text.isEmpty) {
      _showError('Please enter a password');
      return;
    }

    if (_passwordController.text.length < 6) {
      _showError('Password must be at least 6 characters');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      print('📝 Preparing patient data...');

      // Create a Patient model
      final patient = Patient(
        uid: '', // Will be set by AuthService
        email: _emailController.text.trim(),
        name: _nameController.text.trim(),
        weight: double.tryParse(_weightController.text.trim()),
        height: double.tryParse(_heightController.text.trim()),
        bloodGroup: _bloodgrpController.text.trim().isEmpty
            ? null
            : _bloodgrpController.text.trim(),
        age: int.tryParse(_ageController.text.trim()),
        contactNumber: _contactController.text.trim().isEmpty
            ? null
            : _contactController.text.trim(),
        gender: _genderController.text.trim().isEmpty
            ? null
            : _genderController.text.trim(),
        profileImageUrl: null,
        medicalDetails: _medicalDetailsController.text.trim().isEmpty
            ? null
            : _medicalDetailsController.text.trim(),
      );

      print('🔵 Calling signUpPatient...');

      // Call the sign-up method
      User? user = await _authService.signUpPatient(
        patientData: patient,
        password: _passwordController.text,
      );

      print('✅ Signup successful! User: ${user?.uid}');

      // Navigate to home screen on success
      if (user != null && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => BottomNavigate()),
        );
      } else {
        throw Exception('User is null after signup');
      }

    } catch (e) {
      print('❌ Signup error in UI: $e');
      if (mounted) {
        _showError(e.toString().replaceAll('Exception: ', ''));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

// Helper method to show errors
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context);
    return Container(

        child: Scaffold(

          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.only(top: 30,left: 15,right: 15,bottom: 15),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: const EdgeInsets.only(left: 20),
                            child: const Text("Sign In",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w400),)),
                        const SizedBox(height: 20,),
                        Center(
                          child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.grey ,
                              child: CircleAvatar(
                                radius: 59,
                                backgroundImage: AssetImage('assets/images/person.png'),
                                backgroundColor: Colors.grey.shade200,
                              )
                          ),
                        ),
                  
                        SizedBox(height: 10,),
                  
                  
                  
                        Components().signUptextFeild(context,_nameController, "Name"),
                        SizedBox(height:  10),
                        Components().signUptextFeild(context,_emailController, "Email"),
                        SizedBox(height:  10),
                        Components().signUptextFeild(context,_passwordController, "Password"),
                  
                  
                  
                        SizedBox(height: 10,),
                        Row(
                            children: [
                              Expanded(
                                  child: Components().signUpwithPrefixTextFeild(context,_weightController, "Weight", "Kg  ")
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                  child: Components().signUpwithPrefixTextFeild(context,_heightController, "Height", "CM  ")
                  
                              )
                            ]
                  
                        ),
                        SizedBox(height: 10,),
                        Row(
                            children: [
                              Expanded(
                                child: Components().signUptextFeild(context,_bloodgrpController, "Blood Group"),
                  
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                  child: Components().signUptextFeild(context,_ageController, "Age")
                              )
                            ]
                  
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Expanded(
                                flex: 5,
                                child: Components().signUpwithPrefixTextFeild(context,_contactController, "Contact Number", "+91  ")
                            ),
                            SizedBox(width: 10,),
                  
                            Expanded(
                              flex: 2,
                              child: Components().signUptextFeild(context,_genderController, "Gender"),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Divider(thickness: 1,color: Colors.grey,),
                        SizedBox(height: 10,),
                  
                  
                        Components().signUptextFeild(context,_medicalDetailsController, "Medical Details"),
                        const SizedBox(height: 40,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Already have a Account?",style: TextStyle(fontSize: 16),),
                                InkWell(
                                    onTap: (){
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Loginpage()));
                                    },
                                    child: const Text("Log In!",style: TextStyle(fontSize: 18,color: Colors.blue),))
                              ],
                            ),
                            SizedBox(
                              height: 60,
                              child: ElevatedButton(onPressed: () async{
                                // await _firebaseFirestore.collection('users').doc("currentuserUid").set({
                                //   'email':_emailController.text,
                                //   'username':_nameController.text,
                                //   'aadharNumber':"123456876543",
                                //   'dob':"02/09/03",
                                //   'followers':[],
                                //   'following':[]
                                // });
                                  _signUp();
                              },
                                  style:  ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.appColor,
                                  ),
                                  child: const Icon(Icons.arrow_forward_ios,color: Colors.white,)),
                            )
                          ],
                        ),
                  
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
        )
    );
  }
}
