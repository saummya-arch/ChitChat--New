import 'package:chatapp/helper/authenticate.dart';
import 'package:chatapp/views/animation.dart';
import 'package:chatapp/views/signin.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  TextEditingController searchTextEditingController = new TextEditingController();


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
                  Padding(padding: const EdgeInsets.only(left: 260.0),),
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
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
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
                                              hintText: "Search Contacts...",
                                              hintStyle:
                                                  TextStyle(color: Colors.grey[400]),
                                              suffixIcon: IconButton(
                                                icon: Icon(Icons.search),
                                                onPressed: (){
                                                  Navigator.pop(context);
                                                },
                                  ),
                                ),
                             ),
                            ),
                           ],
                      ),
                    ),//iske andarrr hi krna hoga tabhi iss contaner ke anda aayegi list
                    ),
                  ),
                ),
          ],
        ),
    );
  }
}