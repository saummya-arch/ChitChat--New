
import 'package:chatapp/UI/onboarding.dart';
import 'package:chatapp/helper/authenticate.dart';
import 'package:chatapp/views/chatroom.dart';
import 'package:chatapp/views/register.dart';
import 'package:chatapp/views/signin.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.indigo[400],
      ),
      home: OnboardingScreen(),                        //default - authenticate(), SignIn()
    ));