import 'package:chatapp/helper/authenticate.dart';
import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/helper/helperfunctions.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/animation.dart';
import 'package:chatapp/views/conversation_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  DatabaseMethods databaseMethods = new DatabaseMethods();

  TextEditingController searchTextEditingController = new TextEditingController();

  QuerySnapshot searchSnapshot;

  Stream chatRoomStream;

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomStream,
    builder: (context, snapshot) {
      return snapshot.hasData ? ListView.builder(
        itemCount: snapshot.data.documents.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return ChatRoomTile(
          userName:  snapshot.data.documents[index].data["chatroomId"]
            .toString().replaceAll("_", "")
            .replaceAll(Constants.myName, ""),
          chatRoomId:  snapshot.data.documents[index].data["chatroomId"]
          );
        }): Container();
    });
  }

  @override
  void initState(){
    getUserInfo();
    super.initState();
  }


  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getChatRooms(Constants.myName).then((value){
    setState(() {
      chatRoomStream = value;
      print("We got the data + ${chatRoomStream.toString()} this is Name ${Constants.myName}");
    });
    });
    // setState(() {
      
    // });
  }

  initiateSearch(){
     databaseMethods.getUserByContactNo(searchTextEditingController.text)
        .then((val){
          setState(() {
            searchSnapshot = val; 
          });
        });
  }

  //create chatroom, send user to conversation screen , pushreplacement to go back
createConversationScreen({String userName}){
  print("${Constants.myName}");

  if(userName != Constants.myName){
    
    String chatRoomId = getChatRoomId(userName, Constants.myName);

    List<String> users = [userName, Constants.myName];
    
    Map<String, dynamic> charRoomMap = {
      "users" : users,
      "chatroomId" : chatRoomId
    };

    databaseMethods.createChatRoom(chatRoomId, charRoomMap);
    Navigator.push(
          context, MaterialPageRoute(
            builder: (context) => ConversationScreen(chatRoomId),
          ));
  }else{
    print("You Cannot Message to Yourself ");
  }
  }


  Widget searchTile({String userContactNo, String userName, String userEmail}){
    return Container(
      padding:  EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
     // height: 100.0,
      //color: Colors.yellow,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Text(userContactNo, style: TextStyle(color: Colors.black),),
                Text(userName, style: TextStyle(color: Colors.black),),
                Text(userEmail, style: TextStyle(color: Colors.black),),
            ],
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: SizedBox(
              height: 40.0,
              width: 100.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: BorderSide(color: Colors.indigo[400])
                ),
                color: Colors.white,
                elevation: 5.0,
                onPressed: (){
                    createConversationScreen(
                      userName: userName,
                    );
                },
                child: const Text("Message", style: TextStyle(fontSize: 13.0, color: Colors.black),),
                ),
            ),
          ),
        ],
      ),
    );
  }

  

  Widget searchList(){
      return searchSnapshot != null ? ListView.builder(
       // padding: EdgeInsets.only(left: 5.0 , right: 5.0,  bottom: 30.0),
        itemCount: searchSnapshot.documents.length,
        shrinkWrap: true,
        itemBuilder: (context, index){
          return searchTile(
             userContactNo: searchSnapshot.documents[index].data["contactno"],
             userName: searchSnapshot.documents[index].data["name"],
             userEmail: searchSnapshot.documents[index].data["email"],
          );
        }) : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      //backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            Container(
            height: 160,
            color: Colors.indigo[400],
            child: Row(
             // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                children: <Widget>[
                  Padding(padding: const EdgeInsets.only(left: 14.0),),
                  Text("ChitChat", style: TextStyle(color: Colors.white, fontSize: 25.0, fontStyle : FontStyle.italic, fontFamily: 'OpenSans'),)
                ],
              ),
              Row(
                children: <Widget>[
                  Padding(padding: const EdgeInsets.only(left: 230.0),),
                  GestureDetector(
                    onTap: (){
                       Navigator.push(
                       context,
                       MaterialPageRoute(builder: (context) => Authenticate()),
                      );
                    },
                    child: Icon(
                    Icons.exit_to_app,
                    color: Colors.white70,
                     size: 29.0,
              ),
                  ),
                ],
              ),
              ],
            ),
            ),
                Expanded(
                  child: FadeAnimation(1.5,
                     Container(
                      // height: 60.0,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      height: 10.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color.fromRGBO(143, 148, 251, .2),
                                        blurRadius: 20.0,
                                        offset: Offset(0, 10))
                                  ]
                      ),
                        child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                                       Flexible(
                                          child: TextField(
                                            controller: searchTextEditingController,
                                          decoration: InputDecoration(
                                              border:new OutlineInputBorder(
                                              borderSide: new BorderSide(color: Colors.teal),
                                              borderRadius: BorderRadius.circular(20.0),
                                              ),
                                              // prefixIcon: Icon(Icons.lock,
                                              //     color: Colors.grey[400]),
                                              hintText: "Search User By Contact No...",
                                              hintStyle:
                                                  TextStyle(color: Colors.grey[400]),
                                              suffixIcon: IconButton(
                                                icon: Icon(Icons.search),
                                                onPressed: (){
                                                 initiateSearch();
                                                },
                                  ),
                                ),
                             ),
                            ),
                            //yaha tha pehle chatroomlist()
                           ],
                      ),
                    ),//iske andarrr hi krna hoga tabhi iss contaner ke anda aayegi list
                    ),
                  ),
                ),
                searchList(),
                chatRoomList(),
          ],
        ),
    );
  }
}



getChatRoomId(String a, String b) {
  if(a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  }else{
    return "$a\_$b";
  }
}


class ChatRoomTile extends StatelessWidget {

  final String userName;
  final String chatRoomId;
  ChatRoomTile({this.userName,@required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context, MaterialPageRoute(
            builder: (context) => ConversationScreen(chatRoomId),
          ));
      },
        child: Container(
          color:  Colors.black26,
        padding: EdgeInsets.symmetric(horizontal : 24.0 , vertical: 16.0),
        child: Row(
          children: [
            Container(
              height: 40.0,
              width: 40.0,
              alignment:  Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius:  BorderRadiusDirectional.circular(40.0),
              ),
              child: Text("${userName.substring(0,1).toUpperCase()}",),
            ),
            SizedBox(
              width: 8.0,
            ),
            Text(userName),
          ],
        ),
      ),
    );
  }
}