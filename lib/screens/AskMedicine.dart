import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:med_chat/screens/MedicineDetails.dart';
import 'package:med_chat/utils/components.dart';

import '../data/services/api_service.dart';
import '../utils/colors.dart';
 class Askmedicine extends StatefulWidget {
   const Askmedicine({super.key});

   @override
   State<Askmedicine> createState() => _AskmedicineState();
 }

 class _AskmedicineState extends State<Askmedicine> {
   File? _pickedImage=null;

   bool _isLoading = false;

   final ApiService _apiService = ApiService();



   void _getMedicineDetails() async {
     if (_pickedImage == null) return;

     setState(() {
       _isLoading = true;
     });

     final details = await _apiService.getMedicineDetails(_pickedImage!);

     setState(() {
       _isLoading = false;
     });

     if (details.containsKey('error')) {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(details['error'])),
       );
     } else {
       Navigator.push(
         context,
         MaterialPageRoute(
           builder: (context) => Medicinedetails(
             medicineData: details, // Pass the dynamic data
           ),
         ),
       );
     }
   }

   Future<void> _pickImage(ImageSource source) async {
     final picker = ImagePicker();
     final pickedFile = await picker.pickImage(source: source);

     if (pickedFile != null) {
       setState(() {
         _pickedImage = File(pickedFile.path);
       });
     }
   }

   void _showPickerOptions() {
     showModalBottomSheet(
       backgroundColor: Colors.white,
       context: context,
       builder: (context) {
         return SafeArea(
           child: Wrap(
             children: [
               ListTile(
                 leading: const Icon(Icons.photo_library),
                 title: const Text('Pick from Gallery'),
                 onTap: () {
                   Navigator.of(context).pop();
                   _pickImage(ImageSource.gallery);
                 },
               ),
               ListTile(
                 leading: const Icon(Icons.photo_camera),
                 title: const Text('Take a Photo'),
                 onTap: () {
                   Navigator.of(context).pop();
                   _pickImage(ImageSource.camera);
                 },
               ),
             ],
           ),
         );
       },
     );
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
         title: Text("Know Your Medicine",style: TextStyle(color: Colors.white,fontSize: 30),),
       ),
       body: Padding(
         padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10
         ),
         child: Center(
           child: GestureDetector(
             onTap: _showPickerOptions,

             child:_pickedImage==null? Column(
               crossAxisAlignment: CrossAxisAlignment.center,
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Text("Uplaod a Clear photo of your medicine to learn its usage and details",style: TextStyle(fontSize: 22,color: Colors.black54),textAlign: TextAlign.center,),
                 SizedBox(
                     height: MediaQuery.sizeOf(context).height*0.3,
                     width: MediaQuery.sizeOf(context).width*0.6,
                     child: Lottie.asset("assets/animations/upload_image.json",repeat: true)),
               ],
             ):
                 SingleChildScrollView(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.center,
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       ClipRRect(
                         borderRadius: BorderRadius.circular(12),
                         child: Image.file(_pickedImage!,fit: BoxFit.cover,),
                       ),
                       SizedBox(height: 10,),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           IconButton(onPressed: (){
                             setState(() {
                               _pickedImage=null;
                             });
                           },
                               icon: Icon(Icons.arrow_back_ios)),
                           ElevatedButton(onPressed: _getMedicineDetails,
                               style: ElevatedButton.styleFrom(
                                 backgroundColor: AppColors.appColor
                               ),
                               child: Text("Proceed to Know",style: TextStyle(fontSize: 12,color: Colors.white),)),
                         ],
                       )
                     ],
                   ),
                 )
           ),
         ),
       ),

     );
   }
 }
