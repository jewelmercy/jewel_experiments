//All the function and methods used for google sign in

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';


GoogleSignIn _googleSignIn = GoogleSignIn();


//checking if user already signed in or not
Future<bool> checkIfUserIsSignedIn() async {
  var userSignedIn = await _googleSignIn.isSignedIn();
  return userSignedIn;
}

//checkimg whether any user exists
Future<bool> checkuserexists( FirebaseAuth auth) async {
  var userSignedIn = false;
  if (auth.currentUser != null) {
    userSignedIn = await _googleSignIn.isSignedIn();
  }
  return userSignedIn;
}

 Future<void> handleSignOut() => _googleSignIn.disconnect();

//google sign in handler which returns user
Future<User> handleSignIn(FirebaseAuth auth) async {
  User user;
  bool userSignedIn = await _googleSignIn.isSignedIn();
  if (userSignedIn) {
    user = auth.currentUser!;
  } else {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final AuthCredential credential =
       GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    user = (await auth.signInWithCredential(credential)).user!;
    userSignedIn = await _googleSignIn.isSignedIn();
    print(userSignedIn);
  }
  return user;
}
