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

}