import 'package:flutter/material.dart';

import '../utils/colors.dart';
class Medicinedetails extends StatefulWidget {
  const Medicinedetails({super.key});

  @override
  State<Medicinedetails> createState() => _MedicinedetailsState();
}

class _MedicinedetailsState extends State<Medicinedetails> {
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
        title: Text("Paracetamol",style: TextStyle(color: Colors.white,fontSize: 20),),
      ),
      body:Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Paracetamol (Acetaminophen)",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text(
                "Description:\nParacetamol is a commonly used medicine that helps reduce fever and relieve mild to moderate pain such as headaches, muscle aches, toothaches, and menstrual cramps.",
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 12),
              Text(
                "Dosage (Adults):\n• 500mg to 1000mg every 4–6 hours as needed\n• Do not exceed 4000mg in 24 hours",
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 12),
              Text(
                "Dosage (Children):\n• Based on weight (10–15mg per kg every 4–6 hours)\n• Do not exceed 5 doses in 24 hours",
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 12),
              Text(
                "Precautions:\n• Avoid taking with alcohol (risk of liver damage)\n• Use with caution if you have liver or kidney disease\n• Do not exceed recommended daily dosage",
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 12),
              Text(
                "Possible Side Effects:\n• Nausea, stomach upset, or rash (rare)\n• Seek medical help immediately in case of overdose (liver damage risk)",
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
