import 'package:flutter/material.dart';
import 'package:med_chat/data/models/doctor_model.dart';
import 'package:med_chat/data/services/firestore_services.dart';
import 'package:med_chat/utils/components.dart';

import '../utils/colors.dart';

class DoctorListPage extends StatefulWidget {
  final String title;
  final String? category;

  // This is the corrected constructor.
  // It correctly initializes the final variables 'title' and 'category'.
  const DoctorListPage({super.key, required this.title, this.category});

  @override
  State<DoctorListPage> createState() => _DoctorListPageState();
}

class _DoctorListPageState extends State<DoctorListPage> {
  final FirestoreService _firestoreService = FirestoreService();
  bool _isLoading = true;
  List<Doctor> _doctors = [];

  @override
  void initState() {
    super.initState();
    _fetchDoctors();
  }

  Future<void> _fetchDoctors() async {
    List<Doctor> doctorsList;
    if (widget.category != null) {
      // If a category is provided, fetch doctors for that category
      doctorsList = await _firestoreService.getDoctorsByCategory(widget.category!);
    } else {
      // If no category is provided, fetch all doctors
      doctorsList = await _firestoreService.getAlllDoctors();
    }

    if (mounted) {
      setState(() {
        _doctors = doctorsList;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor:AppColors.appColor,
        shape:const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom:Radius.circular(30) )
        ),
        title: Text(widget.title,style: TextStyle(color: Colors.white,fontSize: 30),),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _doctors.isEmpty
          ? Center(child: Text('No doctors found for ${widget.title}.'))
          : ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context,index){

          return Components().doctorTile(context,_doctors[index].name, _doctors[index].category,_doctors[index].uid);
        },
        itemCount: _doctors.length,
      ),
    );
  }

}
