import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/animation.dart';
import 'package:chatapp/views/chatroom.dart';

import 'package:flutter/material.dart';

class Register extends StatefulWidget {

  final Function toggle;
  Register(this.toggle);

  @override
  _RegisterState createState() => _RegisterState();
}

AuthMethods authMethods = new AuthMethods();


DatabaseMethods databaseMethods = new DatabaseMethods();

final formKey = GlobalKey<FormState>();

class _RegisterState extends State<Register> {
  bool isLoading = false;
  bool _showPassword = false;

  @override
  void dispose() {
    passwordTextEditingController.dispose();
    super.dispose();
  }

  TextEditingController userNameTextEditingController =
      new TextEditingController();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();

  afterrValidation() {
    if (formKey.currentState.validate()) {
      
       Map<String, String> userInfoMap = {
          "name" : userNameTextEditingController.text,
          "email" : emailTextEditingController.text
        };

      setState(() {
        isLoading = true;
      });

      authMethods
          .signUpWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((val) {
        // print("${val.uid}");


        databaseMethods.uploadUserInfo(userInfoMap);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatRoom()));
      });
    }
  }

  loadIng() {
    Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: isLoading
            ? loadIng()
            : SingleChildScrollView(
                //if isLoading is true then , it goes in loadIng() func , and if it is not it goes normal
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 400,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/background.png'),
                                fit: BoxFit.fill)),
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              left: 30,
                              width: 80,
                              height: 200,
                              child: FadeAnimation(
                                  1,
                                  Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/light-1.png'))),
                                  )),
                            ),
                            Positioned(
                              left: 60,
                              width: 80,
                              height: 165,
                              child: FadeAnimation(
                                  1.3,
                                  Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/light-2.png'))),
                                  )),
                            ),
                            Positioned(
                              right: 40,
                              top: 40,
                              width: 80,
                              height: 150,
                              child: FadeAnimation(
                                  1.5,
                                  Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/clock.png'))),
                                  )),
                            ),
                            Positioned(
                              child: FadeAnimation(
                                  1.6,
                                  Container(
                                    margin: EdgeInsets.only(top: 50),
                                    child: Center(
                                      child: Text(
                                        "Register",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(30.0),
                        child: Column(
                          children: <Widget>[
                            FadeAnimation(
                                1.8,
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color.fromRGBO(
                                                143, 148, 251, .2),
                                            blurRadius: 20.0,
                                            offset: Offset(0, 10))
                                      ]),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.grey[100]))),
                                        child: Form(
                                          key: formKey,
                                          child: Column(
                                            children: [
                                              TextFormField(
                                                validator: (val) {
                                                  return val.isEmpty ||
                                                          val.length < 4
                                                      ? "Please Provide Username "
                                                      : null;
                                                },
                                                controller:
                                                    userNameTextEditingController,
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    prefixIcon: Icon(
                                                      Icons.perm_identity,
                                                      color: Colors.grey[400],
                                                    ),
                                                    hintText: "Username",
                                                    hintStyle: TextStyle(
                                                        color:
                                                            Colors.grey[400])),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.grey[100]))),
                                        child: TextFormField(
                                          validator: (val) {
                                            return RegExp(
                                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-      zA-Z0-9]+\.[a-zA-Z]+")
                                                    .hasMatch(val)
                                                ? null
                                                : "Enter correct email";
                                          },
                                          controller:
                                              emailTextEditingController,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              prefixIcon: Icon(Icons.email,
                                                  color: Colors.grey[400]),
                                              hintText: "Email or Phone number",
                                              hintStyle: TextStyle(
                                                  color: Colors.grey[400])),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(8.0),
                                        child: TextFormField(
                                           controller:
                                            passwordTextEditingController,
                                         // obscureText: true,
                                          validator: (val) {
                                            return val.length > 6
                                                ? null
                                                : "Please Provide a Strong Password";
                                          },
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              prefixIcon: Icon(Icons.lock,
                                                  color: Colors.grey[400]),
                                              hintText: "Password",
                                              suffixIcon: GestureDetector(
                                                onTap: (){
                                                  setState(() {
                                                    _showPassword = !_showPassword;
                                                  });
                                                },
                                                child: Icon(
                                                  _showPassword ? Icons.visibility : Icons.visibility_off,
                                                ),
                                              ),
                                              hintStyle: TextStyle(
                                                  color: Colors.grey[400]),
                                          ),
                                   obscureText: !_showPassword,
                                          ),
                                        ),
                                    ],
                                  ),
                                )),
                            SizedBox(
                              height: 30,
                            ),
                            FadeAnimation(
                                2,
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      gradient: LinearGradient(colors: [
                                        Color.fromRGBO(143, 148, 251, 1),
                                        Color.fromRGBO(143, 148, 251, .6),
                                      ])),
                                  child: RaisedButton(
                                    onPressed: () {
                                      afterrValidation();
                                    },
                                    color: Colors.indigo[400],
                                    child: Center(
                                      child: Text(
                                        "Create Account",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                )),

                            SizedBox(
                              height: 70,
                            ),
                            FadeAnimation(
                              1.5,
                              Column(
                                children: <Widget>[
                                  Text(
                                    "Already have An Account ?",
                                    style: TextStyle(fontSize: 13.0),
                                  ),
                                ],
                              ),
                            ),

                            // Login button

                            SizedBox(
                              height: 10,
                            ),
                            FadeAnimation(
                                1.5,
                                FlatButton(
                                  onPressed: () {
                                    
                                    // ignore: unnecessary_statements
                                    widget.toggle();
                                    
                                   // Navigator.pop(context);      //default- SignIn()
                                  },
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Color.fromRGBO(143, 148, 251, 1),
                                        fontSize: 17.0),
                                  ),
                                )),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ));
  }
}