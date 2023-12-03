import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:to_do_list_nhatnam/screens/user_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import '../screens/task_page.dart';

//Determine if the user is authenticated.
class AuthService {
  handleAuthState() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            print('Được thành công lấy được dữ liệu gg');
            return UserPage();
          } else {
            print('Thất bại lấy được dữ liệu gg');
            return UserPage();
          }
        });
  }

  getProfileImage() {
    if (FirebaseAuth.instance != null &&
        FirebaseAuth.instance.currentUser != null) {
      return Image.network(FirebaseAuth.instance.currentUser!.photoURL ?? '',
          height: 100, width: 100);
    } else {
      return Icon(Icons.account_circle, size: 100);
    }
  }

  // signInWithGoogle() async {
  //   final bool googleUser1 = await GoogleSignIn().isSignedIn();
  //   bool hasSignedIn = false;

  //   if (googleUser1) {
  //     hasSignedIn = true;
  //   }

  //   // Trigger the authentication flow
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  //   if (googleUser != null) {
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;

  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     try {
  //       if (hasSignedIn) {
  //         await FirebaseAuth.instance.signOut();
  //       }

  //       // Once signed in, return the UserCredential
  //       return await FirebaseAuth.instance.signInWithCredential(credential);
  //     } catch (e) {
  //       // Handle error
  //       print(e.toString());
  //       return null;
  //     }
  //   }
  // }
  Future<bool> checkSignIn() async {
    final bool signInStatus = await GoogleSignIn().isSignedIn();

    if (signInStatus) {
      return true;
    } else
      return false;
  }

  signInWithGoogle() async {
    final bool googleUser1 = await GoogleSignIn().isSignedIn();

    if (googleUser1 == true) {
      await signOut();
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      // await GoogleSignIn(scopes: <String>["email"]).signIn();

      // Obtain the auth details from the request

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Once signed in, return the UserCredential
        return await FirebaseAuth.instance.signInWithCredential(credential);
      }
    }
    if (googleUser1 == false) {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      // await GoogleSignIn(scopes: <String>["email"]).signIn();

      // Obtain the auth details from the request

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Once signed in, return the UserCredential
        return await FirebaseAuth.instance.signInWithCredential(credential);
      }
    }
  }

//Sign out
  signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().disconnect();
  }
}
