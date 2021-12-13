import 'package:augmont_app/homepage.dart';
import 'package:augmont_app/signinpage.dart';
import 'package:augmont_app/signuppage.dart';
import 'package:flutter/material.dart';
 
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Augmont_App', 
      debugShowCheckedModeBanner: false,
      //defining Initial routes
      initialRoute: '/',  
      //defining routes
      routes: {
        '/': (context) => SignInPage(),
        '/signuppage': (context) => SignUpPage(),  
      }, 
    );
  }
} 
