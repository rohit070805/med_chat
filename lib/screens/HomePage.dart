import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:med_chat/screens/SideMenu.dart';
import 'package:med_chat/utils/colors.dart';
import '../utils/components.dart';
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  ChatUser geminiUser = ChatUser(id: "1", firstName: "Seire");
  List<ChatMessage> messages = [];
  GlobalKey<ScaffoldState> drawerkey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        endDrawerEnableOpenDragGesture: true,
        key: drawerkey,
        drawer: Sidemenu(),
      appBar:Components().homePageAppBar(drawerkey) ,
        body: buildUI()
    );
  }

  Widget buildUI() {
    return DashChat(currentUser: currentUser,

      inputOptions: InputOptions(
        sendButtonBuilder: defaultSendButton(color: AppColors.appColor,),
        autocorrect: true,

        alwaysShowSend: true,
        inputTextStyle: TextStyle(fontSize: 18)
      ),
      onSend: _sendMessage,
      messages: messages,
      messageOptions: MessageOptions(
        messageTextBuilder: (ChatMessage message, ChatMessage? previousMessage,
            ChatMessage? nextMessage){
          return Text(message.text,style: TextStyle(fontSize: 15,color: Colors.white),);

        },
          currentUserContainerColor: Colors.blueAccent,


      ),);
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });
  }
}

