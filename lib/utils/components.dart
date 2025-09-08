import 'package:flutter/material.dart';
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

Widget normaltextFeild(TextEditingController controller,String label){
 return  TextField(
    style: TextStyle(fontSize: 18),
    controller: controller,
    maxLines: label=="Medical Details"?8:1,
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
        suffixIcon: Icon(Icons.update),
        suffixIconColor: AppColors.appColor




    ),
    readOnly: true,


  );
}
Widget withPrefixTextFeild(TextEditingController controller,String label,String prefix){
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
  prefixStyle: TextStyle(color: Colors.grey),


  suffixIcon: Icon(Icons.update),
  suffixIconColor: AppColors.appColor

  ),
  readOnly: true,


  );
}

}