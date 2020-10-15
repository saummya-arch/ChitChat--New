import 'package:chatapp/helper/authenticate.dart';
import 'package:chatapp/helper/helperfunctions.dart';
import 'package:chatapp/views/chatroom.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool isUserLoggedIn = false;

  @override
  void initState() {
   getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        isUserLoggedIn = value;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme :ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.indigo[400],
      ),
      home: isUserLoggedIn != null ? isUserLoggedIn ? ChatRoom() : Authenticate() 
      : Container(
        child: Center(
          child: Authenticate(),
        ),
      ),                               //default - authenticate() //true- Chatroom()
    );
  }
}

