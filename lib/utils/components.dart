import 'dart:math';

import 'package:flutter/material.dart';
import 'package:med_chat/screens/DoctorDetailsPage.dart';
import 'package:med_chat/utils/colors.dart';
class Components{
PreferredSizeWidget homePageAppBar(  GlobalKey<ScaffoldState> _drawerkey){
  return AppBar(
    leading: IconButton(onPressed: (){
      _drawerkey.currentState?.openDrawer();
    },
        icon: Icon(Icons.menu,color: Colors.white,)),

    centerTitle: true,
    automaticallyImplyLeading: false,
    backgroundColor:AppColors.appColor,
    actions: [
    Padding(padding: EdgeInsets.all(10),
      child: IconButton(


          highlightColor: Colors.transparent,
          onPressed: (){}, icon: Icon(Icons.open_in_new,color: Colors.white,)),

    ),
    ],
    shape:const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom:Radius.circular(30) )
    ),
    title: Text("AI BOT",style: TextStyle(color: Colors.white,fontSize: 30),),
  );
}
Widget signUpwithPrefixTextFeild(BuildContext context,TextEditingController controller,String label,String prefix){
  return  TextField(
    style: TextStyle(fontSize: 18),
    controller: controller,
    decoration: InputDecoration(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: Colors.black,
              width: 1.5
          )
      ),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: Colors.grey,
              width: 1.5
          )
      ),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: Colors.grey,
              width: 1.5
          )
      ),
      labelText: label,
      prefixText: prefix,

      labelStyle: TextStyle(color: Colors.black,fontSize: 16),

      prefixStyle: TextStyle(color: Colors.grey),





    ),



  );
}


Widget signUptextFeild(BuildContext context,TextEditingController controller,String label){
  return  TextField(
    style: TextStyle(fontSize: 18),
    controller: controller,

    decoration: InputDecoration(
      alignLabelWithHint: true,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: Colors.grey,
              width: 1.5
          )
      ),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: Colors.grey,
              width: 1.5
          )
      ),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: Colors.grey,
              width: 1.5
          )
      ),
      labelText: label,
      labelStyle: TextStyle(color: Colors.black,fontSize: 16),







    ),



  );
}
Widget normaltextFeild(BuildContext context, TextEditingController controller, String label, {Future<void> Function(String)? onSave}) { // 1. Added the onSave function parameter
  return TextField(
    style: const TextStyle(fontSize: 18),
    controller: controller,
    maxLines: label == "Medical Details" ? 8 : 1,
    readOnly: true,
    decoration: InputDecoration(
      alignLabelWithHint: true,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey, width: 1.5)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey, width: 1.5)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey, width: 1.5)),
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black, fontSize: 16),
      suffixIcon: IconButton( // Note: suffixIcon is generally preferred over suffix for IconButtons
        icon: Icon(Icons.update, color: AppColors.appColor), // Using edit icon for clarity
        onPressed: () async {
          final newValue = await showDialog<String>(
            context: context,
            builder: (context) {
              final tempController = TextEditingController(
                text: controller.text,
              );
              return AlertDialog(
                backgroundColor: Colors.white,
                title: Text("Edit $label"),
                content: TextField(
                  controller: tempController,
                  decoration: InputDecoration(
                    hintText: "Enter new $label",
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.appColor),
                    onPressed: () =>
                        Navigator.pop(context, tempController.text),
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          );

          // If user pressed Save
          if (newValue != null && newValue.isNotEmpty) {
            // 2. Instead of updating the controller directly, call the onSave function
            if (onSave != null) {
              await onSave(newValue);
            }
          }
        },
      ),
    ),
  );
}
Widget withPrefixTextFeild(BuildContext context, TextEditingController controller, String label, String prefix, {Future<void> Function(String)? onSave}) { // 1. Added the onSave function parameter
  return TextField(
    style: const TextStyle(fontSize: 18),
    controller: controller,
    readOnly: true, // Kept this to prevent direct editing
    decoration: InputDecoration(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black, width: 1.5)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey, width: 1.5)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey, width: 1.5)),
      labelText: label,
      prefixText: prefix,
      prefixStyle: const TextStyle(color: Colors.grey),
      suffixIcon: IconButton( // Note: suffixIcon is generally preferred over suffix for IconButtons
        icon: Icon(Icons.update, color: AppColors.appColor), // Using edit icon for clarity
        onPressed: () async {
          final newValue = await showDialog<String>(
            context: context,
            builder: (context) {
              final tempController = TextEditingController(
                text: controller.text,
              );
              return AlertDialog(
                backgroundColor: Colors.white,
                title: Text("Edit $label"),
                content: TextField(
                  controller: tempController,
                  decoration: InputDecoration(
                    hintText: "Enter new $label",
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.appColor),
                    onPressed: () =>
                        Navigator.pop(context, tempController.text),
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          );

          // If user pressed Save
          if (newValue != null && newValue.isNotEmpty) {
            // 2. Instead of updating the controller directly, call the onSave function
            if (onSave != null) {
              await onSave(newValue);
            }
          }
        },
      ),
    ),
  );
}

Widget categoryCard(String title, String subtitle,
    {required Color color, required Color lightColor}) {

  return Container(
    height: 230,
    width:150,
    child: AspectRatio(
      aspectRatio: 6 / 8,
      child: Container(

        margin: EdgeInsets.only(left :10,right: 5, bottom: 20, top: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              offset: Offset(4, 4),
              blurRadius: 10,
              color: lightColor.withOpacity(.8),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: Container(

            child: Stack(
              children: <Widget>[
                Positioned(
                  top: -20,
                  left: -20,
                  child: CircleAvatar(
                    backgroundColor: lightColor,
                    radius: 60,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0,left: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        child: Text(title
                          ,style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.w600,letterSpacing: 3),),
                      ),

                      Flexible(
                        child: Text(
                          subtitle,style: TextStyle(color: Colors.white,fontSize: 21,fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ),
    ),
  );
}
Color randomColor() {
  var random = Random();
  final colorList = [

   AppColors.orange,
    AppColors.green,
    AppColors.grey,
    AppColors.lightOrange,
    AppColors.skyBlue,
    AppColors.titleTextColor,
    Colors.red,
    Colors.brown,
    AppColors.purpleExtraLight,
    AppColors.skyBlue,
  ];
  var color = colorList[random.nextInt(colorList.length)];
  return color;
}


Widget doctorTile(BuildContext context,String title,String subtitle,String doctorId) {
  return Container(

    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(20)),
      boxShadow: <BoxShadow>[
        BoxShadow(
          offset: Offset(4, 4),
          blurRadius: 10,
          color: AppColors.grey.withOpacity(.4),
        ),
        BoxShadow(
          offset: Offset(-3, 0),
          blurRadius: 15,
          color: AppColors.grey.withOpacity(.1),
        )
      ],
    ),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: ListTile(
        onTap: () {
          // Pass the doctorId to the Doctordetailspage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Doctordetailspage(doctorId: doctorId),
            ),
          );
        },
        contentPadding: EdgeInsets.all(0),
        leading: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(13)),
          child: Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: randomColor(),
            ),
            child: Image.asset(
              "assets/images/doctor.png",
              height: 50,
              width: 50,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(title, style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600)),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500,fontSize: 16),
        ),
        trailing: Icon(
          Icons.keyboard_arrow_right,
          size: 30,
          color: AppColors.appColor,
        ),
      ),
    )
  );
}


}