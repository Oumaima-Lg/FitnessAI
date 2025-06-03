import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/pages/bottomnavbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


Future<void> signInWithGoogle(BuildContext context) async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) return;

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BottomNavBar()),
    );
  } catch (e) {
    print('Erreur Google Sign-In: $e');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Erreur Google Sign-In"),
      backgroundColor: Colors.red,
    ));
  }
}

// Future<void> signInWithFacebook(BuildContext context) async {
//   try {
//     final LoginResult result = await FacebookAuth.instance.login();

//     if (result.status == LoginStatus.success) {
//       final OAuthCredential credential =
//           FacebookAuthProvider.credential(result.accessToken!.token);

//       await FirebaseAuth.instance.signInWithCredential(credential);

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => BottomNavBar()),
//       );
//     } else {
//       print('Facebook login annulé ou erreur');
//     }
//   } catch (e) {
//     print('Erreur Facebook Login: $e');
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text("Erreur Facebook Sign-In"),
//       backgroundColor: Colors.red,
//     ));
//   }
// }
