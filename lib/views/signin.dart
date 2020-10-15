import 'package:chatapp/helper/helperfunctions.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/animation.dart';
import 'package:chatapp/views/chatroom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {

  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {


  final formKey = GlobalKey<FormState>();

  AuthMethods authMethods = new AuthMethods();

  DatabaseMethods databaseMethods = new DatabaseMethods();


  bool _rememberMe = false;
  bool _showPassword = false;


   TextEditingController emailTextEditingController =
      new TextEditingController();
    TextEditingController passwordTextEditingController =
      new TextEditingController();


  bool isLoading = false;

  QuerySnapshot snapshotUserInfo;

  afterSignInValidation(){

    if(formKey.currentState.validate()){


      HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);

      databaseMethods.getUserByUserEmail(emailTextEditingController.text)
          .then((val){
              snapshotUserInfo = val;
              HelperFunctions.saveUserNameSharedPreference(snapshotUserInfo.documents[0].data["name"]);
             // print("${snapshotUserInfo.documents[0].data["name"]} this is my world");
          });



      setState(() {
        isLoading = true;
      });


      authMethods.signInWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text)
          .then((val){
             if(val!= null) {
                HelperFunctions.saveUserLoggedInSharedPreference(true);

             Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatRoom()));
             }

          });      
      }

  }    


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
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
                                      image: AssetImage('assets/light-1.png'))),
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
                                      image: AssetImage('assets/light-2.png'))),
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
                                      image: AssetImage('assets/clock.png'))),
                            )),
                      ),
                      Positioned(
                        child: FadeAnimation(
                            1.6,
                            Container(
                              margin: EdgeInsets.only(top: 50),
                              child: Center(
                                child: Text(
                                  "Login",
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
                          Form(
                            key: formKey,
                                child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color.fromRGBO(143, 148, 251, .2),
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
                                    child: TextFormField(
                                      validator: (val) {
                                              return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) && val.isNotEmpty ? null : "Enter correct email";

                                            },
                                      controller: emailTextEditingController,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          prefixIcon: Icon(Icons.email,
                                              color: Colors.grey[400]),
                                          hintText: "Email",
                                          hintStyle:
                                              TextStyle(color: Colors.grey[400])),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextFormField(
                                       validator: (val) {
                                              return val.length > 6
                                                  ? null
                                                  : "Please Provide a Strong Password";
                                            },
                                      controller: passwordTextEditingController,
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
                                           hintStyle:
                                              TextStyle(color: Colors.grey[400]),
                                      ),
                                      obscureText: !_showPassword,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )),

                      // forgot password

                      SizedBox(height: 15),

                      FadeAnimation(
                        1.7,
                        Container(
                          //color: Colors.yellow,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                //color: Colors.brown,
                                //checkbox
                                child: Row(
                                  children: <Widget>[
                                    Theme(
                                      data: ThemeData(
                                          unselectedWidgetColor: Colors.grey),
                                      child: Checkbox(
                                          value: _rememberMe,
                                          checkColor: Colors.white,
                                          activeColor: Colors.indigo[400],
                                          onChanged: (value) {
                                            setState(() {
                                              _rememberMe = value;
                                            });
                                          }),
                                    ),
                                    Text(
                                      "Remember Me",
                                      style: TextStyle(fontSize: 12.0),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                //forgot password
                                child: Row(children: <Widget>[
                                  Container(
                                    //color: Colors.pink,
                                    alignment: Alignment.centerRight,
                                    child: FlatButton(
                                      onPressed: () {},
                                      padding: EdgeInsets.only(right: 0.0),
                                      child: Text(
                                        "Forgot Password ?",
                                        style: new TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.indigo[400],
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                            ],
                          ), //ROW
                        ),
                      ),

                      //login button

                      SizedBox(
                        height: 50,
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
                                afterSignInValidation();
                              },
                              color: Colors.indigo[400],
                              child: Center(
                                child: Text(
                                  "Login",
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
                              "Don't have an Account ?",
                              style: TextStyle(fontSize: 13.0),
                            ),
                          ],
                        ),
                      ),

                      //create account button

                      SizedBox(
                        height: 10,
                      ),
                      FadeAnimation(
                          1.5,
                          FlatButton(
                            onPressed: () {
                              // ignore: unnecessary_statements
                              widget.toggle();


                              //  Navigator.push(
                              //    context,
                              //    MaterialPageRoute(
                              //        builder: (context) => Register()),  //deafult
                              // );
                            },
                            child: Text(
                              "Create Account",
                              style: TextStyle(
                                  color: Color.fromRGBO(143, 148, 251, 1),
                                  fontSize: 16.0),
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