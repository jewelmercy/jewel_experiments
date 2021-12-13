// Code is refactored for reusability 

import 'dart:ui';

import 'package:flutter/material.dart';

// Entire App theme color
Color themecolor = Colors.blue.shade700;


//Textfields widget for user for different fields
class TextFieldbox extends StatelessWidget {
  TextFieldbox(
      {Key? key,
      required this.hinttext,
      required this.obscuretext,
      required this.icon,
      required this.keyboardtype,
      required this.textcontroller,
      required this.focus,
      required this.width})
      : super(key: key);

  final String hinttext;
  final bool obscuretext;
  final TextInputType keyboardtype;
  final Icon icon;
  final TextEditingController textcontroller;
  final FocusNode focus;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: width*2.0),
      child: TextField(
        keyboardType: keyboardtype,
        obscureText: obscuretext,
        decoration: InputDecoration(
          hintText: hinttext,
          icon: icon,
        ),
        controller: textcontroller,
        focusNode: focus,
      ),
    );
  }
}


//Email validation method
  bool validateEmail({required String? email}) {
    bool retval = true;
    if (email == null) {
     retval = false;
    }

// regular expression which searches for @ and .com in a email id
    RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    if (email!.isEmpty) {
       retval = false;
    } else if (!emailRegExp.hasMatch(email)) {
      retval = false;
    }
    return retval;
  }

//A show dailog box for showing any errors to the user when something goes wrong
Future<dynamic> errorbox(BuildContext context, String errormsg, double width,double height) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: AlertDialog(
            contentPadding: EdgeInsets.all(width*2),
            backgroundColor: themecolor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(width*5))),
            //title: Text("Error"),
            content: Container(
                width: width*100,
                height: height*20,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(errormsg,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xfff6f4e6),
                            fontWeight:FontWeight.bold,
                            fontSize: width*5)),
                     SizedBox(
                  height: height*1,
                ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                          width: width*25,
                          height: height*2.2,
                          child: Center(child: Text('Okay',style: TextStyle(
                            color: themecolor,
                            )))),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                      
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(width*1),
                        ),
                      ),
                    ),
                    // ignore: deprecated_member_use
                  ],
                )),
          ),
        );
      });
}


