import 'package:chatapp/UI/styles.dart';
import 'package:chatapp/views/signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OnboardingScreen extends StatefulWidget {


  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

final formKey = GlobalKey<FormState>();

class _OnboardingScreenState extends State<OnboardingScreen> {

  TextEditingController contactnumberText  = new TextEditingController();

  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }


  contactNumberLength(String value){
    if(value.length != 10){
      Text("Incorrect Contact Length");
    }
  }

  contactNumberRegExp(String value){
    return RegExp(r'(^[0-9]{10,12}$)').hasMatch(value) ? null : "Enter correct Contact Number";
  }


  afterValidation(){
    if (formKey.currentState.validate()) {
      _pageController.nextPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.ease);
    }
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 20.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Color(0xFF7B51D3),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 0.4, 0.7, 0.9],
              colors: [
                Color(0xFF3594DD),
                Color(0xFF4563DB),
                Color(0xFF5036D5),
                Color(0xFF5B16D0),
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerRight,
                  // child: FlatButton(
                  //   onPressed: () => print('Skip'),
                  //   child: Text(
                  //     'Skip',
                  //     style: TextStyle(
                  //       color: Colors.white,
                  //       fontSize: 18.0,
                  //     ),
                  //   ),
                  // ),
                ),
                Container(
                  color: Colors.yellow,
                  height: 300.0,
                  child: PageView(
                    physics: ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage(
                                  'assets/onboarding0.png',
                                ),
                                height: 250.0,
                                width: 250.0,
                              ),
                            ),
                            Padding(padding: const EdgeInsets.only(top: 15.0),),
                            SizedBox(height: 15.0),
                            Container(
                              color: Colors.pink,
                              child:  Row(
                                children: <Widget>[
                                  Form(
                                          key: formKey,
                                          child: Expanded(
                                          child: TextFormField(
                                            validator: (val){
                                              contactNumberLength(val) || contactNumberRegExp(val);
                                              },
                                         controller: contactnumberText,
                                         decoration: InputDecoration(
                                           prefixText: ('+(91) |'),
                                           hintText: " Contact Number", 
                                           filled: true,
                                           fillColor: Colors.white,
                                           hintStyle: TextStyle(color: Colors.indigo[400]),
                                           border: OutlineInputBorder(
                                             borderRadius: BorderRadius.circular(10.0),
                                           ),
                                         ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage(
                                  'assets/onboarding1.png',
                                ),
                                height: 250.0,
                                width: 250.0,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              'Live your life smarter\nwith us!',
                              style: kTitleStyle,
                            ),
                            SizedBox(height: 0.0),
                             Text(
                              'Lorem ipsum dolor sit amet, consect adipiscing elit, sed do eiusmod tempor incididunt ut labore et.',
                              style: TextStyle(fontSize: 15.0 , fontWeight: FontWeight.w600 , color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage(
                                  'assets/onboarding2.png',
                                ),
                                height: 250.0,
                                width: 250.0,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              'Get a new experience\nof imagination',
                              style: kTitleStyle,
                            ),
                            SizedBox(height: 0.0),
                            Text(
                              'Lorem ipsum dolor sit amet, consect adipiscing elit, sed do eiusmod tempor incididunt ut labore et.',
                              style: TextStyle(fontSize: 15.0 , fontWeight: FontWeight.w600 , color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(padding: const EdgeInsets.only(top:40.0),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
                _currentPage != _numPages - 1
                    ? Expanded(
                        child: Align(
                          alignment: FractionalOffset.bottomRight,
                          child: FlatButton(
                            onPressed: () {
                              afterValidation();
                              
                            },
                            padding: const EdgeInsets.only(top:  35.0, right: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Next',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 30.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Text(''),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: _currentPage == _numPages - 1
          ? Container(
              height: 75.0,
              decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
              width: double.infinity,
              //color: Colors.white,
              child: GestureDetector(
                onTap: (){
                   // widget.toggle();
                  // Navigator.push(
                  // context,
                  // MaterialPageRoute(
                  // builder: (context) => SignIn(widget.toggle)),  //deafult
                 //);
                },
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 30.0),
                    child: Text(
                      'Get started',
                      style: TextStyle(
                        color: Color(0xFF5B16D0),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Text(''),
    );
  }
}