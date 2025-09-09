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

Widget normaltextFeild(BuildContext context,TextEditingController controller,String label){
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
        suffix: IconButton(icon:Icon(Icons.update,color: AppColors.appColor,),
          onPressed: () async{
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
  child: Text("Cancel"),
  ),
  ElevatedButton(
    style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.appColor
    ),
  onPressed: () =>
  Navigator.pop(context, tempController.text),
  child: Text("Save",style: TextStyle(color: Colors.white),),
  ),
  ],
  );
  },
  );

  // If user pressed Save
  if (newValue != null && newValue.isNotEmpty) {
  controller.text = newValue;
  }


          },),






    ),
    readOnly: true,


  );
}
Widget withPrefixTextFeild(BuildContext context,TextEditingController controller,String label,String prefix){
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



    suffix: IconButton(icon:Icon(Icons.update,color: AppColors.appColor,),
      onPressed: () async{
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
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.appColor
                  ),
                  onPressed: () =>
                      Navigator.pop(context, tempController.text),
                  child: Text("Save",style: TextStyle(color: Colors.white),),
                ),
              ],
            );
          },
        );

        // If user pressed Save
        if (newValue != null && newValue.isNotEmpty) {
          controller.text = newValue;
        }


      },),

  ),
  readOnly: true,


  );
}

}