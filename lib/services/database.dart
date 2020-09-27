import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{
  getUserByName(String username){

  }


  uploadUserInfo(userMap){
  Firestore.instance.collection("users")
    .add(userMap);
  }
}