import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/helper/helperfunctions.dart';
import 'package:chatapp/services/database.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {

  final String chatRoomId;
  ConversationScreen(this.chatRoomId);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {


  DatabaseMethods databaseMethods = new DatabaseMethods();

  TextEditingController messageEditingController = new TextEditingController();

  Stream chatMessageStream;
  Stream chatRoomStream;

  Widget chatMessageList() {
    return StreamBuilder(
      stream:  chatMessageStream,
      builder: (context, snapshot) {
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            return MessageTile(snapshot.data.documents[index].data["message"],
            snapshot.data.documents[index].data["sendBy"] == Constants.myName
            );
          }) : Container();
      },
      );
  }


  sendMessage() {

    if(messageEditingController.text.isNotEmpty) {
      Map<String,dynamic> messageMap = {
        "message" : messageEditingController.text,
        "sendBy" : Constants.myName,
        "time" : DateTime.now().millisecondsSinceEpoch,
      };

       databaseMethods.addConversationMessage(widget.chatRoomId, messageMap);
       messageEditingController.text = "";
    }
  }


  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getChatRooms(Constants.myName).then((value){
    setState(() {
      chatRoomStream = value;
    });
    });
    setState(() {
      
    });
  }

  @override
  void initState() {
    getUserInfo();
    databaseMethods.getConversationMessage(widget.chatRoomId)
    .then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
        return Scaffold(
        appBar: AppBar(
          title: const Text('Chat Here'),
        ),
        body: Container(
          decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/chatbackround2.png"),
            fit: BoxFit.cover,
          ),
        ),
          child: Stack(
            children: [
              chatMessageList(),
              Container(alignment: Alignment.bottomCenter,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
             // padding: EdgeInsets.only(left: 15.0, right: 15.0),
              child: Container(
              color: Colors.blueGrey[50],
                height: 70.0,
                padding: EdgeInsets.only(left: 15.0, right: 15.0 ,top: 10.0, bottom:  10.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          child: TextField(
                            controller: messageEditingController,
                            decoration: InputDecoration(
                                hintText: "Message ...",
                                hintStyle: TextStyle(
                                  height: 2.0,
                                  color: Colors.grey,
                                  fontSize: 15.0,
                                ),
                                border: new OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40.0),
                                ),
                            ),
                          ),
                        ),),
                    SizedBox(width: 16,),
                    GestureDetector(
                      onTap: () {
                       sendMessage();
                      },
                      child: Container(
                        alignment: Alignment.center,
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    const Color(0x36FFFFFF),
                                    const Color(0x0FFFFFFF)
                                  ],
                                  begin: FractionalOffset.topLeft,
                                  end: FractionalOffset.bottomRight
                              ),
                              borderRadius: BorderRadius.circular(30)
                          ),
                          padding: EdgeInsets.all(12),
                          child: Icon(Icons.send),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ],
          ),
        ),
      );  
  }
}


class MessageTile  extends StatelessWidget {

  final String message;
  final bool isSendByMe;
  MessageTile(this.message , this.isSendByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left : isSendByMe ? 0: 10.0 , right : isSendByMe ? 10.0 : 0),
      margin: EdgeInsets.symmetric(vertical : isSendByMe ? 4.0 : (!isSendByMe ? 4.0 : 7.0)),
      width:  MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal : 16.0 , vertical : 16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSendByMe ? 
            [
              const Color(0xFF9575CD),
              const Color(0xFF9575CD)
            ]
            : [
              const Color(0xFFCFD8DC),
              const Color(0xFFCFD8DC)
            ],
          ),
          borderRadius: isSendByMe ?
          BorderRadius.only(
            topLeft:  Radius.circular(23.0),
            topRight: Radius.circular(23.0),
            bottomLeft: Radius.circular(23.0),
          ) 
          : BorderRadius.only(
            topLeft:  Radius.circular(23.0),
            topRight: Radius.circular(23.0),
            bottomRight: Radius.circular(23.0),
          ),
        ),
        child: Text(message, style:  TextStyle(
          color: Colors.black,
          fontSize: 17.0,
        ),),
      ),
    );
  }
}