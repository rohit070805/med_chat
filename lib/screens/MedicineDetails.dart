import 'package:flutter/material.dart';

import '../utils/colors.dart';
class Medicinedetails extends StatefulWidget {
  final Map<String, dynamic> medicineData; // New parameter

  const Medicinedetails({super.key, required this.medicineData});

  @override
  State<Medicinedetails> createState() => _MedicinedetailsState();
}

class _MedicinedetailsState extends State<Medicinedetails> {
  @override
  Widget build(BuildContext context) {
    final data = widget.medicineData;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
       
          
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor:AppColors.appColor,
        
        shape:const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom:Radius.circular(30) )
        ),
        title: Text(data['name'] ?? 'Medicine Details',style: TextStyle(color: Colors.white,fontSize: 20),),
      ),
      body:Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
              Text(
                data['name'] ?? '',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text(
                  "Description:\n${data['description'] ?? ''}", style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 12),
              Text(
                  "Dosage (Adults):\n${data['dosage_adults'] ?? ''}", style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 12),
              Text(
                "Dosage (Children):\n${data['dosage_children'] ?? ''}",
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 12),
              Text(
                "Dosage (Children):\n${data['dosage_children'] ?? ''}",
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 12),
              Text(
                  "Possible Side Effects:\n${data['side_effects'] ?? ''}", style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
