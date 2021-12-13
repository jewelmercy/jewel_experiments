import 'package:augmont_app/components.dart';
import 'package:augmont_app/googlelogin.dart';
import 'package:augmont_app/signinpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget { 
  final String username;
  final String useremail;
  const HomePage({ Key? key ,required this.username, required this.useremail}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool _isSigningOut = false;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'NAME: ${widget.username}',
            ),
            SizedBox(height: 16.0),
            Text(
              'EMAIL: ${widget.useremail}',
              
            ),
            SizedBox(height: 16.0),
            _isSigningOut
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isSigningOut = true;
                      });
                      // Sign out from logged in auth
                      await FirebaseAuth.instance.signOut();
                      if(await checkIfUserIsSignedIn())
                      {
                        handleSignOut();
                      }
                      setState(() {
                        _isSigningOut = false;
                      });
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => SignInPage(),
                        ),
                      );
                    },
                    child: Container( width: 300,
                      height: 40,child: Center(child: Text('Sign out'))),
                    style: ElevatedButton.styleFrom(
                      primary: themecolor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}