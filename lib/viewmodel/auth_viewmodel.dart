import 'package:cage/repository/auth_repository.dart';
import 'package:cage/utils/routes/routes_name.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'dart:io';

import 'package:cage/repository/auth_repository.dart';
import 'package:cage/utils/routes/routes_name.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthViewmodel extends ChangeNotifier {
  final _myRepo = AuthRepository();
  bool _isloading = false;
  bool get loading => _isloading;

  setloaoding(bool value) {
    _isloading = value;
    notifyListeners();
  }

  String? verificationIdGlobal;

  Future<void> startSignUp(
    String email,
    String password,
    String phoneNumber,
    BuildContext context,
  ) async {
    PhoneAuthCredential? credential;
    await completeSignUp(
      email,
      password,

      //credential ,
      phoneNumber,
      context,
    );
    // await FirebaseAuth.instance.verifyPhoneNumber(
    //   phoneNumber: phoneNumber,

    //   verificationCompleted: (PhoneAuthCredential credential) async {
    //     // This will be called automatically in some cases (Android auto-retrieval)
    //     await completeSignUp(email, password, credential, phoneNumber, context);
    //   },
    //   verificationFailed: (FirebaseAuthException e) {
    //     Utils.flushBarErrorMassage(
    //       'Verification failed: ${e.message}',
    //       context,
    //     );
    //   },
    //   codeSent: (String verificationId, int? resendToken) {
    //     verificationIdGlobal = verificationId;
    //     Utils.flushBarErrorMassage('OTP sent to $phoneNumber', context);
    //   },
    //   codeAutoRetrievalTimeout: (String verificationId) {
    //     verificationIdGlobal = verificationId;
    //   },
    // );
  }

  Future<void> addRole({
    required String uid,
    required String fieldName,
    required dynamic value,
  }) async {
    try {
      final userRef = FirebaseFirestore.instance
          .collection('userData')
          .doc(uid);

      // Step 1: Update the requested field
      await userRef.set({fieldName: value}, SetOptions(merge: true));

      print('Successfully updated $fieldName for user $uid');

      await Utils.saveSavedRole('role', value);

      // Step 2: If role is updated, handle role-specific fields
      if (fieldName == 'role') {
        await userRef.set({
          'fighterData': {
            'fullName': null,
            'coachName': null,
            'age': null,
            'height': null,
            'weight': null,
            'fightWin': null,
            'fightsLose': null,
            'fightsKnockout': null,
            'fightingStyle': null,
            'urlProfile': null,
            'uploadProfile': null,
            'selectLocation': null,
          },
          'promoterData': {
            'companyName': null,
            'companyAbout': null,
            'eventHistory': null,
            'prompterName': null,
            'contactEmail': null,
            'contactNumber': null,
            'companyLogo': null,
          },
        }, SetOptions(merge: true));
      }
    } catch (e) {
      print('Error updating user field: $e');
    }
  }

  Future<void> addUserFieldByRole({
    required String uid,
    required String fieldName,
    required dynamic value,
  }) async {
    try {
      // Step 1: Get role using Util.getSavedRole
      String? role = await Utils.getSavedRole('role');

      // If not in local storage, get from Firestore and save locally
      if (role == null) {
        final doc = await FirebaseFirestore.instance
            .collection('userData')
            .doc(uid)
            .get();

        role = doc.data()?['role'];

        if (role != null) {
          await Utils.saveSavedRole('userRole', role);
        }
      }

      if (role == null) {
        print('Role not found for user $uid');
        return;
      }

      // Step 2: Determine which section to update
      String sectionKey = role == 'Fighter' ? 'fighterData' : 'promoterData';

      // Step 3: Update specific field inside the section
      final userRef = FirebaseFirestore.instance
          .collection('userData')
          .doc(uid);

      await userRef.set({
        sectionKey: {fieldName: value},
      }, SetOptions(merge: true));

      print('Updated $fieldName for $role ($uid)');
    } catch (e) {
      print('Error updating user field: $e');
    }
  }

  Future<String?> uploadImage(File imageFile, String Uid) async {
    try {
      String uid = Uid;

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('userImages')
          .child('$uid.jpg');

      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Save downloadUrl to Firestore
      await FirebaseFirestore.instance.collection('userData').doc(uid).set({
        'profileImageUrl': downloadUrl,
      }, SetOptions(merge: true));

      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> verifyOtpAndSignUp(
    String otp,
    String email,
    String password,
    String phoneNumber,
    BuildContext context,
  ) async {
    // final credential = PhoneAuthProvider.credential(
    //   verificationId: verificationIdGlobal!,
    //   smsCode: otp,
    // );

    await completeSignUp(
      email,
      password,

      // credential,
      phoneNumber,
      context,
    );
  }

  Future<void> completeSignUp(
    String email,
    String password,
    //  PhoneAuthCredential phoneCredential,
    String phoneNumber,
    BuildContext context,
  ) async {
    // Step 1: Create the email/password account
    final userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    print("verified phone!");

    // Step 2: Link the phone credential
    //  await userCredential.user!.linkWithCredential(phoneCredential);

    print("User signed up with email, password, and verified phone!");

    // Step 3: Store email and phone number in Firestore collection 'userData'
    await FirebaseFirestore.instance
        .collection('userData')
        .doc(userCredential.user!.uid)
        .set({
          'email': email,
          //'phone': phoneCredential.smsCode,
          'createdAt': FieldValue.serverTimestamp(),
          'role': null,
          'fighterData': null,
          'promoterData': null,
        });

    print("User data saved to Firestore!");
  }

  Future<void> loginWithEmailPassword(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      print("User logged in: ${userCredential.user?.uid}");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Utils.flushBarErrorMassage('No user found for that email.', context);
      } else if (e.code == 'wrong-password') {
        Utils.flushBarErrorMassage('Wrong password provided.', context);
      } else {
        Utils.flushBarErrorMassage('Login failed: ${e.message}', context);
      }
    } catch (e) {
      Utils.flushBarErrorMassage('Unexpected error: $e', context);
    }
  }
}
