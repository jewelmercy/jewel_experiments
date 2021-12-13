import 'package:augmont_app/components.dart';
import 'package:augmont_app/firebase.dart';
import 'package:augmont_app/googlelogin.dart';
import 'package:augmont_app/homepage.dart';
import 'package:augmont_app/screensize.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  FireBaselog firebase = FireBaselog();
  bool _isProcessing = false;
  late FirebaseAuth _auth;

  Future<FirebaseApp> _initializeFirebase() async {
    //Initializing app to firebase
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    //Authentication with firebase
    _auth = FirebaseAuth.instanceFor(app: firebaseApp);

    //if user is already signed in get the user information
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      //if user exists go to home page
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => HomePage(
                  username: user.displayName.toString(),
                  useremail: user.email.toString(),
                )),
      );
    }
    return firebaseApp;
  }

  Future<void> login(double width, double height) async {
    setState(() {
      _isProcessing = true;
    });

    //validate email id for typo errors using regular expression
    if (!validateEmail(email: _emailController.text)) {
      errorbox(context, 'Please enter valid Email', width, height);
      setState(() {
        _isProcessing = false;
      });
      return;
    }

    //validate password
    if (_passwordController.text == null || _passwordController.text == " ") {
      errorbox(context, 'Please enter the Password', width, height);
      setState(() {
        _isProcessing = false;
      });
      return;
    }

    //sign in using email and password
    User? user = await firebase.signInUsingEmailPassword(
      width: width,
      height: height,
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
    );

    setState(() {
      _isProcessing = false;
    });

    if (user != null) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => HomePage(
            username: user.displayName.toString(),
            useremail: user.email.toString(),
          ),
        ),
        ModalRoute.withName('/'),
      );
    }
  }

  //google sign in
  void onGoogleSignIn(BuildContext context) async {
    User? userdata = await handleSignIn(_auth);
    setState(() {
      _isProcessing = false;
    });
    // ignore: unnecessary_null_comparison
    if (userdata != null) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => HomePage(
            username: userdata.displayName.toString(),
            useremail: userdata.email.toString(),
          ),
        ),
        ModalRoute.withName('/'),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    //dispose used controllers
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //firebase app is build
      body: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            SizeConfig().init(context);
            double? width = SizeConfig.blockSizeWidth;
            double? height = SizeConfig.blockSizeHeight;
            return SingleChildScrollView(
              child: Theme(
                data: Theme.of(context).copyWith(
                    hintColor: Colors.grey,
                    colorScheme:
                        ThemeData().colorScheme.copyWith(primary: themecolor)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: height! * 40,
                      width: width! * 90,
                      color: Colors.white,
                      child: Center(
                        child: Image(
                          width: width * 80,
                          height: height * 30,
                          fit: BoxFit.fill,
                          image: AssetImage('assets/images/augmont.png'),
                          //width: 150,
                        ),
                      ),
                      //width: 150,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: width * 10,
                          right: width * 10,
                          bottom: height * 1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextFieldbox(
                            width: width,
                            hinttext: 'User Email',
                            obscuretext: false,
                            keyboardtype: TextInputType.emailAddress,
                            icon: Icon(Icons.person_outline),
                            textcontroller: _emailController,
                            focus: _focusEmail,
                          ),
                          TextFieldbox(
                            width: width,
                            hinttext: 'Password',
                            textcontroller: _passwordController,
                            focus: _focusPassword,
                            obscuretext: true,
                            keyboardtype: TextInputType.text,
                            icon: Icon(Icons.lock_outline),
                          ),
                          SizedBox(
                            height: height * 5,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              login(width, height);
                            },
                            child: Container(
                                width: width * 75,
                                height: height * 6,
                                child: _isProcessing
                                    ? Center(
                                        child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white)))
                                    : Center(child: Text('SIGN IN'))),
                            style: ElevatedButton.styleFrom(
                              primary: themecolor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(width * 1),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 1,
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: themecolor,
                              ),
                            ),
                          ),
                          // ignore: deprecated_member_use
                          FlatButton(
                            // minWidth: width * 90,
                            //             height: height * 6,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(width * 1)),
                            onPressed: () {
                              setState(() {
                                _isProcessing = true;
                              });
                              onGoogleSignIn(context);
                            },
                            color: Colors.red.withOpacity(0.3),
                            child: Padding(
                              padding: EdgeInsets.all(width * 2),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Image(
                                    width: width * 20,
                                    height: width * 9,
                                    // fit: BoxFit.fill,
                                    image:
                                        AssetImage('assets/images/google.png'),
                                    //width: 150,
                                  ),
                                  Text(
                                    "Sign In with Google",
                                    style: TextStyle(color: Colors.red),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 3,
                          ),
                          // ignore: deprecated_member_use
                          FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            onPressed: () {},
                            color: Colors.blue.withOpacity(0.3),
                            child: Padding(
                              padding: EdgeInsets.all(width * 2),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Image(
                                    width: width * 20,
                                    height: width * 9,
                                    // fit: BoxFit.fill,
                                    image: AssetImage(
                                        'assets/images/facebook.png'),
                                    //width: 150,
                                  ),
                                  Text(
                                    "Sign In with Facebook",
                                    style: TextStyle(color: Colors.blue),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 3,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 50.0),
                            child: Row(
                              children: [
                                Text(
                                  'Dont have an account?',
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/signuppage');
                                  },
                                  child: Text(
                                    'Create one',
                                    style: TextStyle(
                                      color: themecolor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(themecolor)),
            ),
          );
        },
      ),
    );
  }
}
