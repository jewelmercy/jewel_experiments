import 'package:augmont_app/components.dart';
import 'package:augmont_app/firebase.dart';
import 'package:augmont_app/homepage.dart';
import 'package:augmont_app/screensize.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:augmont_app/googlelogin.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isProcessing = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cpasswordController = TextEditingController();
  final _focusname = FocusNode();
  final _focusemail = FocusNode();
  final _focuspassword = FocusNode();
  final _focuscpassword = FocusNode();
  FireBaselog firebase = FireBaselog();

  Future<void> register(BuildContext context, double width,double height) async {
    setState(() {
      _isProcessing = true;
    });

    if (!validateEmail(email: _emailController.text)) {
      errorbox(context, 'Please enter valid Email',width,height);
      setState(() {
        _isProcessing = false;
      });
      return;
    }

    if (_passwordController.text == null || _passwordController.text == " ") {
      errorbox(context, 'Please enter the Password',width,height);
      setState(() {
        _isProcessing = false;
      });
      return;
    }

    if (_passwordController.text.compareTo(_cpasswordController.text) != 0) {
      errorbox(context, 'Passwords do not match',width,height);
      setState(() {
        _isProcessing = false;
      });
      return;
    }

//register new user using name, email and password and add to the firebase
    User? user = await firebase.registerUsingEmailPassword(
      width: width,
      height:height,
      context: context,
      name: _nameController.text,
      email: _emailController.text,
      password: _cpasswordController.text,
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _cpasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double? width = SizeConfig.blockSizeWidth;
    double? height = SizeConfig.blockSizeHeight;
    return Scaffold(
      body: ModalProgressHUD(
        color: Colors.transparent, //Color(0xff464646),
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(themecolor)),
        inAsyncCall: _isProcessing,
        child: SingleChildScrollView(
          child: Theme(
            data: Theme.of(context).copyWith(
                hintColor: Colors.grey,
                colorScheme:
                    ThemeData().colorScheme.copyWith(primary: themecolor)),
            child: Column(
              children: [
                SizedBox(
                  height: height! * 3,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: BackButton(
                    color: Colors.black,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Container(
                    // height: 280,
                    // width: 900,
                    child: Center(
                        child: Text('Create Account',
                            style: TextStyle(
                                fontSize: width! * 11,
                                fontWeight: FontWeight.bold)))),
                Container(
                  padding: EdgeInsets.all(width * 10),
                  child: Column(
                    children: [
                      TextFieldbox(
                         width: width,
                        hinttext: 'Username',
                        obscuretext: false,
                        keyboardtype: TextInputType.text,
                        icon: Icon(Icons.person_outline),
                        textcontroller: _nameController,
                        focus: _focusname,
                      ),
                      TextFieldbox(
                         width: width,
                        hinttext: 'Email',
                        textcontroller: _emailController,
                        focus: _focusemail,
                        obscuretext: false,
                        keyboardtype: TextInputType.emailAddress,
                        icon: Icon(Icons.email_outlined),
                      ),
                      TextFieldbox(
                         width: width,
                        hinttext: 'Password',
                        textcontroller: _passwordController,
                        focus: _focuspassword,
                        obscuretext: true,
                        keyboardtype: TextInputType.text,
                        icon: Icon(Icons.lock_outline),
                      ),
                      TextFieldbox(
                         width: width,
                        hinttext: 'Confirm Password',
                        textcontroller: _cpasswordController,
                        focus: _focuscpassword,
                        obscuretext: true,
                        keyboardtype: TextInputType.text,
                        icon: Icon(Icons.lock_outline),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 1,
                ),
                ElevatedButton(
                  onPressed: () {
                    register(context,width,height);
                  },
                  child: Container(
                      width: width * 70,
                      height: height * 6,
                      child: Center(child: Text('Register'))),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(width * 1),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 2,
                ),
                Column(
                  children: [
                    Text(
                      'By registering you confirm that you accept our',
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: width * 20.0),
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Terms of Use',
                              style: TextStyle(
                                  color: themecolor,
                                  decoration: TextDecoration.underline,
                                  decorationThickness: 2),
                            ),
                          ),
                          Text(
                            'and',
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Privacy Policy',
                              style: TextStyle(
                                  color: themecolor,
                                  decoration: TextDecoration.underline,
                                  decorationThickness: 2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: width * 10.0, right: width * 10),
                  // ignore: deprecated_member_use
                  child: FlatButton(
                    // minWidth: width * 90,
                    //             height: height * 6,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(width * 1)),
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/', (route) => false);
                    },
                    color: Colors.red.withOpacity(0.3),
                    child: Padding(
                      padding: EdgeInsets.all(width * 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image(
                            width: width * 20,
                            height: width * 9,
                            // fit: BoxFit.fill,
                            image: AssetImage('assets/images/google.png'),
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
                ),
                SizedBox(
                  height: height * 2,
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: width * 10.0, right: width * 10),
                  // ignore: deprecated_member_use
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    onPressed: () {},
                    color: Colors.blue.withOpacity(0.3),
                    child: Padding(
                      padding: EdgeInsets.all(width * 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image(
                            width: width * 20,
                            height: width * 9,
                            // fit: BoxFit.fill,
                            image: AssetImage('assets/images/facebook.png'),
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
                ),
                Padding(
                  padding: EdgeInsets.only(left: width * 30.0),
                  child: Row(
                    children: [
                      Text(
                        'Have an account?',
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/', (route) => false);
                        },
                        child: Text(
                          'Sign In',
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
        ),
      ),
    );
  }
}
