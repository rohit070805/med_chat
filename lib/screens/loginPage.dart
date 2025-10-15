import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:med_chat/screens/HomePage.dart';
import 'package:med_chat/screens/signUpScreen.dart';
import 'package:med_chat/utils/colors.dart';

import '../data/services/auth_services.dart';
import '../main.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final AuthService _authService = AuthService();

  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    pass.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context);
    return Container(
        
        child: Scaffold(
         backgroundColor: Colors.white,
          body: Container(
              margin: EdgeInsets.only(top: mediaquery.size.height*0.39,left: 50,right: 50),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: const EdgeInsets.only(left: 20),
                        child: const Text("Sign In",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w400),)),
                    const SizedBox(height: 20,),
                    TextField(
                      style: const TextStyle(fontSize: 16),
                      controller:email ,

                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email_outlined),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueAccent)
                          ),
                          hintText: "Email",
                          labelText: "Email",
                          labelStyle: const TextStyle(fontSize: 16,color: Colors.black),
                          hintStyle: const TextStyle(fontSize: 16),
                          fillColor: Colors.cyan.shade50,

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),

                          )
                      ),
                    ),
                    const SizedBox(height: 20,),
                    TextField(
                      obscureText: true,
                      obscuringCharacter: '*',
                      controller:pass ,
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(

                          prefixIcon:const Icon(Icons.lock),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueAccent)
                          ),
                          hintText: "Password",
                          labelText: "Password",
                          labelStyle: const TextStyle(fontSize: 16,color: Colors.black),
                          hintStyle: const TextStyle(fontSize: 16),
                          fillColor: Colors.cyan.shade50,

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )
                      ),
                    ),
                    const SizedBox(height: 40,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Don't have a Account?",style: TextStyle(fontSize: 16),),
                            InkWell(
                                onTap: (){
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Signupscreen()));
                                  },
                                child: const Text("Sign Up!",style: TextStyle(fontSize: 18,color: Colors.blue),))
                          ],
                        ),
                        SizedBox(
                          height: 60,
                          child: ElevatedButton(onPressed: () async {
                            // Get email and password from text controllers
                            final String userEmail = email.text.trim();
                            final String userPassword = pass.text.trim();

                            // Basic check for empty fields
                            if (userEmail.isEmpty || userPassword.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Please fill all fields.')),
                              );
                              return; // Stop the function
                            }

                            // Call the signIn method from your service
                            UserCredential? userCredential =
                            await _authService.signIn(
                              email: userEmail,
                              password: userPassword,
                            );

                            // Check the result
                            if (userCredential != null) {
                              // Login successful!
                              // You can navigate to the home screen here
                              print(
                                  '✅ Login successful for user: ${userCredential.user?.email}');
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomNavigate()));
                              } else {
                              // Login failed. Show an error message.
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Login Failed. Check your credentials.')),
                              );
                            }
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
              )

          ),
        )
    );
  }
}
