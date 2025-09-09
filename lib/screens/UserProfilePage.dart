import 'package:flutter/material.dart';
import 'package:med_chat/utils/colors.dart';
import 'package:med_chat/utils/components.dart';
class Userprofilepage extends StatefulWidget {
  const Userprofilepage({super.key});

  @override
  State<Userprofilepage> createState() => _UserprofilepageState();
}

class _UserprofilepageState extends State<Userprofilepage> {
  final TextEditingController _nameController  = TextEditingController();
  final TextEditingController _weightController  = TextEditingController();
  final TextEditingController _heightController  = TextEditingController();
  final TextEditingController _ageController  = TextEditingController();
  final TextEditingController _bloodgrpController  = TextEditingController();
  final TextEditingController _genderController  = TextEditingController();
  final TextEditingController _contactController  = TextEditingController();
  final TextEditingController _medicalDetailsController  = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController.text = "Rohit Kumar";
    _weightController.text = "60";
    _heightController.text = "170";
    _ageController.text = "20";
    _bloodgrpController.text = "AB+";
    _genderController.text = "M";
    _contactController.text = "9813258303";
    _medicalDetailsController.text = "I have no major chronic illnesses. I am not allergic to common medicines except penicillin. I have mild asthma since childhood and currently take an inhaler when required. No past surgeries. Family history of diabetes on my father’s side. Currently not taking any daily medications other than a vitamin supplement.";

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
      body: Padding(
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
                      Text("ROHIT KUMAR",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      Text("rohitdhankhar7347@gmail.com",style: TextStyle(fontSize: 16),)
                    ],
                  ),
                  Spacer(),
                  IconButton(onPressed: (){}, icon: Icon(Icons.logout_outlined,color: Colors.redAccent,size: 30,))
                ],
              ),
              SizedBox(height: 10,),
              Divider(thickness: 1,color: Colors.grey,),
              Text("Basic Details"),
              Components().normaltextFeild(context,_nameController, "Name"),
              SizedBox(width: 10),
              SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(
                    child: Components().withPrefixTextFeild(context,_weightController, "Weight", "Kg  ")
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: Components().withPrefixTextFeild(context,_heightController, "Height", "CM  ")
          
                  )
                ]
          
              ),
              SizedBox(height: 10,),
              Row(
                  children: [
                    Expanded(
                      child: Components().normaltextFeild(context,_bloodgrpController, "Blood Group"),
          
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: Components().normaltextFeild(context,_ageController, "Age")
                    )
                  ]
          
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Components().withPrefixTextFeild(context,_contactController, "Contact Number", "+91  ")
                  ),
                  SizedBox(width: 10,),
          
                  Expanded(
                    flex: 2,
                    child: Components().normaltextFeild(context,_genderController, "Gender"),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Divider(thickness: 1,color: Colors.grey,),
              SizedBox(height: 10,),
          
          
              Components().normaltextFeild(context,_medicalDetailsController, "Medical Details"),
          
          
            ],
          ),
        ),
      )
    );
  }
}
