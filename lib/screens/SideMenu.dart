import 'package:flutter/material.dart';
import 'package:med_chat/utils/colors.dart';
class Sidemenu extends StatefulWidget {
  const Sidemenu({super.key});

  @override
  State<Sidemenu> createState() => _SidemenuState();
}

class _SidemenuState extends State<Sidemenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 25,vertical: 16),
                  child: Text("H I S T O R Y",style: TextStyle(color: AppColors.appColor,fontSize: 25,fontWeight: FontWeight.w500),)),
              Divider(
                color: Colors.black.withOpacity(0.2),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 5,right: 5),
                  margin: EdgeInsets.only(right: 20),
                  
                  child: Column(
                    
                    children: [
                      Expanded(
                        child: ListView.builder(itemBuilder: (context,index){
                          return ListTile(

                            title: Text("Chat ${index+1}",style: TextStyle(fontSize: 18),),
                          );
                          
                        },
                          itemCount: 30,
                        ),
                      ),

                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),

    );
  }
}
