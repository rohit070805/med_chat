import 'package:flutter/material.dart';
import 'package:med_chat/utils/colors.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context);
    return Container(
        
        child: Scaffold(
         // backgroundColor: Colors.transparent,
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
                                  },
                                child: const Text("Sign Up!",style: TextStyle(fontSize: 18,color: Colors.blue),))
                          ],
                        ),
                        SizedBox(
                          height: 60,
                          child: ElevatedButton(onPressed: (){

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
