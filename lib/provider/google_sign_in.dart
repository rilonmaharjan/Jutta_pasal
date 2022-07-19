import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin(context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;
      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      await FirebaseFirestore.instance.collection("users").doc(user.email).set({
        'email': user.email.toLowerCase(),
        'name': user.displayName,
        'phoneNumber': "",
        'role': "user",
        'adminrole': "user",
      }).then((value) => Get.snackbar('Irasshaimase!', 'Logged in successfully',
          duration: const Duration(milliseconds: 2000),
          backgroundColor: const Color.fromARGB(126, 255, 255, 255)));
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      Get.snackbar('Failed to login', e.toString(),
          duration: const Duration(milliseconds: 2000),
          backgroundColor: const Color.fromARGB(126, 255, 255, 255));
    }
    notifyListeners();
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  Future googleLogout() async {
    await googleSignIn.disconnect();
  }
}
