import 'package:flutter/material.dart';
import 'package:med_chat/utils/colors.dart';
import 'package:med_chat/utils/components.dart';

import '../data/models/doctor_model.dart';
import '../data/models/patient_model.dart';
import '../data/services/firestore_services.dart';
import 'doctorsListPage.dart';
class Searchdoctorpage extends StatefulWidget {
  const Searchdoctorpage({super.key});

  @override
  State<Searchdoctorpage> createState() => _SearchdoctorpageState();
}

class _SearchdoctorpageState extends State<Searchdoctorpage> {
  final GlobalKey<ScaffoldState> drawerkey = GlobalKey();
  final FirestoreService _firestoreService = FirestoreService();

  // State variables for loading status and doctors list
  bool _isLoading = true;
  List<Doctor> _doctors = [];

  Patient? _patient;
  @override
  void initState() {
    super.initState();
    // Fetch doctors when the page is first loaded
    _fetchDoctors();
    _loadUserData();
  }
  Future<void> _loadUserData() async {
    // Call the new method to get the current patient's data
    final patientData = await _firestoreService.getCurrentPatient();

    // Check if data was successfully fetched and the widget is still on screen
    if (patientData != null && mounted) {
      setState(() {
        _patient = patientData; // Store the patient object



        _isLoading = false; // Stop loading
      });
    } else if (mounted) {
      // Handle cases where the user data couldn't be loaded
      setState(() {
        _isLoading = false;
      });
    }
  }
  Future<void> _fetchDoctors() async {
    final doctorsList = await _firestoreService.getAllDoctors();
    if (mounted) {
      setState(() {
        _doctors = doctorsList;
        _isLoading = false;
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,
      toolbarHeight: 10,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text("Hello,",style: TextStyle(fontSize: 25,color: Colors.grey),),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: _isLoading?CircularProgressIndicator():Text(_patient!.name,style: TextStyle(fontSize: 35,letterSpacing: 3,color: AppColors.appColor,fontWeight: FontWeight.w500),),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                        height: 55,
                        margin: EdgeInsets.symmetric( vertical: 10),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(13)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 15,
                              offset: Offset(5, 5),
                            )
                          ],
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            border: InputBorder.none,
                            hintText: "Search Doctor",

                            suffixIcon: SizedBox(
                                width: 50,
                                child: Icon(Icons.search, color: AppColors.appColor)
                            ),
                          ),
                        )),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text("Category",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                    ),
                    SizedBox(
                      height: 230,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
              
                          _buildSingleCategoryCard(title: 'General', categoryKey: 'General', color: Color(0xff4cd1bc), lightColor: Color(0xff5ed6c3)),
                          _buildSingleCategoryCard(title: 'Skin', categoryKey: 'Skin', color: Color(0xff71b4fb), lightColor: Color(0xff7fbcfb)),
                          _buildSingleCategoryCard(title: 'Bones', categoryKey: 'Bones', color:Color(0xfffa8c73), lightColor: Color(0xfffa9881)),
                          _buildSingleCategoryCard(title: 'Child', categoryKey: 'Child', color: Color(0xff8873f4), lightColor: Color(0xff9489f4)),
              
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("All Doctors",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                          IconButton(icon:Icon(Icons.sort,color: AppColors.appColor,size: 30,),
                            onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const DoctorListPage(
                                      title: 'All Doctors'),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context,index){
              
                        return Components().doctorTile(context,_doctors[index].name, _doctors[index].category,_doctors[index].uid);
                      },
                      itemCount: _doctors.length,
                    ),
                  ],
                ),
              ),
            )
          
           

            ],
        ),
      ),
    );
  }
  Widget _buildSingleCategoryCard({
    required String title,
    required String categoryKey,
    required Color color,
    required Color lightColor,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DoctorListPage(title: title, category: categoryKey),
            ),
          );
        },
        child: FutureBuilder<int>(
          future: _firestoreService.getDoctorCountByCategory(categoryKey),
          builder: (context, snapshot) {
            String countText = '...'; // This becomes the subtitle
            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
              countText = '${snapshot.data}+'; // The final subtitle
            }
            // Your categoryCard is called here with the final subtitle
            return Components().categoryCard(
                title,
                countText, // Passed as the subtitle
                color: color,
                lightColor: lightColor
            );
          },
        ),
      ),
    );
  }
}
