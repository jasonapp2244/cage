import 'package:cage/repository/auth_repository.dart';
import 'package:cage/utils/routes/routes_name.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:cage/view/auth/loginview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';

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
      if (e.toString().contains('permission-denied')) {
        print(
          'Firestore permission denied. User might not be authenticated properly.',
        );
        // You might want to re-authenticate the user here
      }
      rethrow; // Re-throw so the UI can handle it
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
    try {
      // Check if Firebase is initialized
      if (Firebase.apps.isEmpty) {
        throw FirebaseException(
          plugin: 'core',
          message: 'Firebase is not initialized',
          code: 'no-app',
        );
      }

      // Step 1: Create the email/password account
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      print("verified phone!");

      // Step 2: Link the phone credential
      //  await userCredential.user!.linkWithCredential(phoneCredential);

      print("User signed up with email, password, and verified phone!");

      // Step 3: Store email and phone number in Firestore collection 'userData'
      try {
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
      } catch (firestoreError) {
        print("Firestore Error: $firestoreError");
        // If Firestore fails, we still have a user account, so we can continue
        // but we should inform the user about the data sync issue
        Utils.flushBarErrorMassage(
          "Account created but there was an issue saving your profile data. Please try again later.",
          context,
        );
        // Don't rethrow - let the user continue to role selection
      }

      // Navigate to role selector after successful signup
      Navigator.pushNamed(context, RoutesName.roleView);
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Error Code: ${e.code}");
      print("Firebase Auth Error Message: ${e.message}");

      String errorMessage;

      // Handle Firebase error codes (with and without prefix)
      String errorCode = e.code;
      if (errorCode.startsWith('firebase_auth/')) {
        errorCode = errorCode.replaceFirst('firebase_auth/', '');
      }

      switch (errorCode) {
        case 'email-already-in-use':
          errorMessage =
              "An account with this email already exists. Please try logging in instead.";
          break;
        case 'invalid-email':
          errorMessage = "The email address is not valid.";
          break;
        case 'operation-not-allowed':
          errorMessage =
              "Email/password sign-up is not enabled. Please contact support.";
          break;
        case 'weak-password':
          errorMessage =
              "The password is too weak. Please choose a stronger password.";
          break;
        case 'network-request-failed':
          errorMessage =
              "Network error. Please check your internet connection.";
          break;
        case 'app-not-authorized':
          errorMessage =
              "App is not authorized. Please check your Firebase configuration.";
          break;
        case 'keychain-error':
          errorMessage = "Authentication error. Please try again.";
          break;
        case 'internal-error':
          errorMessage = "Internal authentication error. Please try again.";
          break;
        default:
          errorMessage = "Sign up failed: ${e.message ?? 'Unknown error'}";
      }

      Utils.flushBarErrorMassage(errorMessage, context);
      // Re-throw the exception so the UI can catch it and prevent navigation
    } catch (e) {
      // For unexpected errors
      print("Unexpected Error: $e");
      print("Error Type: ${e.runtimeType}");

      String errorMessage;

      // Handle specific credential errors that might not be FirebaseAuthException
      if (e.toString().contains('credential') ||
          e.toString().contains('expired')) {
        errorMessage =
            "Authentication credentials are invalid or expired. Please try again.";
      } else if (e.toString().contains('network')) {
        errorMessage = "Network error. Please check your internet connection.";
      } else if (e.toString().contains('timeout')) {
        errorMessage = "Request timed out. Please try again.";
      } else {
        errorMessage =
            "An unexpected error occurred during sign up. Please try again.";
      }

      Utils.flushBarErrorMassage(errorMessage, context);
      // Re-throw the exception so the UI can catch it and prevent navigation
      rethrow;
    }
  }

  Future<void> loginWithEmailPassword(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      // Check if Firebase is initialized
      if (Firebase.apps.isEmpty) {
        throw FirebaseException(
          plugin: 'core',
          message: 'Firebase is not initialized',
          code: 'no-app',
        );
      }

      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      print("User logged in: ${userCredential.user?.uid}");
      // Don't navigate here - let the UI handle navigation on success
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Error Code: ${e.code}");
      print("Firebase Auth Error Message: ${e.message}");

      String errorMessage;

      // Handle Firebase error codes (with and without prefix)
      String errorCode = e.code;
      if (errorCode.startsWith('firebase_auth/')) {
        errorCode = errorCode.replaceFirst('firebase_auth/', '');
      }

      switch (errorCode) {
        case 'invalid-email':
          errorMessage = "The email address is not valid.";
          break;
        case 'user-disabled':
          errorMessage = "This user account has been disabled.";
          break;
        case 'user-not-found':
          errorMessage = "No user found with this email.";
          break;
        case 'wrong-password':
          errorMessage = "Incorrect password. Please try again.";
          break;
        case 'too-many-requests':
          errorMessage = "Too many login attempts. Try again later.";
          break;
        case 'invalid-credential':
          errorMessage =
              "Invalid email or password. Please check your credentials and try again.";
          break;
        case 'credential-already-in-use':
          errorMessage =
              "This account is already linked to another sign-in method.";
          break;
        case 'operation-not-allowed':
          errorMessage =
              "Email/password sign-in is not enabled. Please contact support.";
          break;
        case 'network-request-failed':
          errorMessage =
              "Network error. Please check your internet connection.";
          break;
        case 'app-not-authorized':
          errorMessage =
              "App is not authorized. Please check your Firebase configuration.";
          break;
        case 'keychain-error':
          errorMessage = "Authentication error. Please try again.";
          break;
        case 'internal-error':
          errorMessage = "Internal authentication error. Please try again.";
          break;
        default:
          errorMessage = "Login failed: ${e.message ?? 'Unknown error'}";
      }

      Utils.flushBarErrorMassage(errorMessage, context);
      // Re-throw the exception so the UI can catch it and prevent navigation
    } catch (e) {
      // For unexpected errors
      print("Unexpected Error: $e");
      print("Error Type: ${e.runtimeType}");

      String errorMessage;

      // Handle specific credential errors that might not be FirebaseAuthException
      if (e.toString().contains('credential') ||
          e.toString().contains('expired')) {
        errorMessage =
            "Authentication credentials are invalid or expired. Please try logging in again.";
      } else if (e.toString().contains('network')) {
        errorMessage = "Network error. Please check your internet connection.";
      } else if (e.toString().contains('timeout')) {
        errorMessage = "Request timed out. Please try again.";
      } else {
        errorMessage = "An unexpected error occurred. Please try again.";
      }

      Utils.flushBarErrorMassage(errorMessage, context);
      // Re-throw the exception so the UI can catch it and prevent navigation
      rethrow;
    }
  }

  // New comprehensive login method that handles validation and navigation
  Future<void> performLogin(
    String email,
    String password,
    BuildContext context,
  ) async {
    // Validate email
    if (email.isEmpty) {
      Utils.flushBarErrorMassage("Please Enter Email First", context);
      return;
    }

    if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email)) {
      Utils.flushBarErrorMassage("Please Enter Correct Email First", context);
      return;
    }

    // Validate password
    if (password.isEmpty) {
      Utils.flushBarErrorMassage("Please Enter Password First", context);
      return;
    }

    if (password.length < 8) {
      Utils.flushBarErrorMassage("Please Enter 8 digits", context);
      return;
    }

    try {
      // Check if Firebase is initialized
      if (Firebase.apps.isEmpty) {
        Utils.flushBarErrorMassage(
          "Firebase is not initialized. Please restart the app.",
          context,
        );
        return;
      }

      // Attempt login
      await loginWithEmailPassword(email, password, context);

      // If login successful, check user role and navigate accordingly
      final uid = Utils.getCurrentUid();
      if (uid != null) {
        try {
          final userDoc = await FirebaseFirestore.instance
              .collection('userData')
              .doc(uid)
              .get();

          if (userDoc.exists) {
            final userData = userDoc.data();
            final role = userData?['role'];
            print('Login - User data: $userData');
            print('Login - Detected role: $role');

            if (role == 'Fighter') {
              Navigator.pushNamedAndRemoveUntil(
                context,
                RoutesName.home,
                (route) => false,
              );
            } else if (role == 'Promoter') {
              print(
                'Login - Navigating to promoter home route: ${RoutesName.PromoterHome}',
              );
              Navigator.pushNamedAndRemoveUntil(
                context,
                RoutesName.PromotorBottomNavBar,
                (route) => false,
              );
            } else {
              // No role set, go to role selection
              Navigator.pushNamedAndRemoveUntil(
                context,
                RoutesName.roleView,
                (route) => false,
              );
            }
          } else {
            // No user data, go to role selection
            Navigator.pushNamedAndRemoveUntil(
              context,
              RoutesName.roleView,
              (route) => false,
            );
          }
        } catch (firestoreError) {
          print('Firestore error during login: $firestoreError');
          if (firestoreError.toString().contains('permission-denied')) {
            Utils.flushBarErrorMassage(
              "Permission denied. Please check your Firebase configuration.",
              context,
            );
          } else {
            Utils.flushBarErrorMassage(
              "Error accessing user data. Please try again.",
              context,
            );
          }
        }
      }
    } catch (e) {
      // Error is already handled in loginWithEmailPassword method
      print('Login failed: $e');
    }
  }

  String? _userRole;

  Future<void> loadUserRole() async {
    try {
      print('=== Starting role detection ===');

      // First check local storage
      final savedRole = await Utils.getSavedRole('role');
      if (savedRole != null) {
        _userRole = savedRole;
        print('Role loaded from local storage: $_userRole');
      } else {
        print('Role not in local storage, fetching from database...');

        final userId = Utils.getCurrentUid();
        print('User ID: $userId');

        final doc = await FirebaseFirestore.instance
            .collection('userData')
            .doc(userId)
            .get();

        if (doc.exists) {
          final data = doc.data();
          print('Firestore data: $data');

          _userRole = data?['role'];
          print('Role from Firestore: $_userRole');

          if (_userRole != null) {
            await Utils.saveSavedRole('role', _userRole!);
            print('Role saved to local storage: $_userRole');
          }
        } else {
          print('User document does not exist in Firestore');
        }
      }

      print('Final detected role: $_userRole');
      print('Is promoter: ${_userRole == 'Promoter'}');
    } catch (e, st) {
      print('Error loading user role: $e');
      print(st);
      _userRole = null;
    } finally {}
  }

  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();

      await Utils.clearAll(); // Clear stored user id

      // Redirect to login
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const Loginview()));
    } catch (e) {
      print('Logout failed: $e');
    }
  }
}
