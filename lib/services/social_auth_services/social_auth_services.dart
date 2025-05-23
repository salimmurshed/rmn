import 'package:flutter/cupertino.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SocialAuthServices {
  static Future<void> signOutSocially () async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    await FacebookLogin().logOut();
  }
  static Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser;
       await GoogleSignIn().signOut();
       googleUser = await GoogleSignIn().signIn();
       return googleUser;
      // Proceed with the authentication process using googleSignInAccount
    } catch (error) {
      debugPrint("Google Login User Error--> $error");
      throw Exception(error.toString());
    }
  }

  static Future<FacebookLogin?>signInWithFacebook() async {
    try {
      FacebookLogin facebookLogin = FacebookLogin(debug: false);
      FacebookLoginResult facebookLoginResult = await facebookLogin.logIn(permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email,
      ]);
      if (facebookLoginResult.status == FacebookLoginStatus.success) {
        return facebookLogin;
      }else{
        return null;
      }
    } catch (e) {

      throw Exception(e.toString());
    }
  }
}