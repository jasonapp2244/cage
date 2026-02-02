import 'package:cage/repository/auth_repository.dart';
import 'package:cage/utils/routes/routes_name.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:cage/view/auth/loginview.dart';
import 'dart:io';

import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Web client ID (serverClientId) — required for Android. From google-services.json.
const String _kGoogleSignInWebClientId =
    '230307676453-qm93u1vdbheo46hhsaog1e93b3iaonjj.apps.googleusercontent.com';

/// iOS client ID — used for initialize() on iOS. From GoogleService-Info.plist.
const String _kGoogleSignInIosClientId =
    '230307676453-qgp9eimk4djgbmatq1bimjeh57rj79eg.apps.googleusercontent.com';

class AuthViewmodel extends ChangeNotifier {
  static bool _googleSignInInitialized = false;

  static Future<void> _ensureGoogleSignInInitialized() async {
    if (_googleSignInInitialized) return;
    final isIOS = !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
    await GoogleSignIn.instance.initialize(
      serverClientId: _kGoogleSignInWebClientId,
      clientId: isIOS ? _kGoogleSignInIosClientId : null,
    );
    _googleSignInInitialized = true;
  }

  /// Call early (e.g. when login/signup screen loads) to avoid init delay on first tap.
  static Future<void> ensureGoogleSignInReady() =>
      _ensureGoogleSignInInitialized();

  final _myRepo = AuthRepository();
  bool _isloading = false;
  bool get loading => _isloading;

  bool _socialLoading = false;
  bool get socialLoading => _socialLoading;

  void setloaoding(bool value) {
    _isloading = value;
    notifyListeners();
  }

  void setSocialLoading(bool value) {
    _socialLoading = value;
    notifyListeners();
  }

  String? verificationIdGlobal;

  Future<void> startSignUp(
    String email,
    String password,
    String phoneNumber,
    BuildContext context, {
    bool rememberMe = false,
  }) async {
    // Set loading to true when signup process starts
    setloaoding(true);

    try {
      PhoneAuthCredential? credential;
      await completeSignUp(
        email,
        password,

        //credential ,
        phoneNumber,
        context,
        rememberMe: rememberMe,
      );
      // Loading is reset in completeSignUp before navigation
    } catch (e) {
      // Reset loading state on error
      setloaoding(false);
      // Re-throw to let error handlers in completeSignUp handle it
      rethrow;
    }
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

  Future<String?> uploadPoseImage(File imageFile, String uid) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('poseImages')
          .child('$uid.jpg');

      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading pose image: $e');
      return null;
    }
  }

  Future<String?> uploadProfileImage(File imageFile, String uid) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profileImages')
          .child('$uid.jpg');

      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading profile image: $e');
      return null;
    }
  }

  Future<void> verifyOtpAndSignUp(
    String otp,
    String email,
    String password,
    String phoneNumber,
    BuildContext context, {
    bool rememberMe = false,
  }) async {
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
      rememberMe: rememberMe,
    );
  }

  Future<void> completeSignUp(
    String email,
    String password,
    //  PhoneAuthCredential phoneCredential,
    String phoneNumber,
    BuildContext context, {
    bool rememberMe = false,
  }) async {
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

      // Reset loading state before navigation
      setloaoding(false);

      // Save login credentials if remember me is checked
      if (rememberMe) {
        await Utils.saveLoginCredentials(email, password);
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
    BuildContext context, {
    bool rememberMe = false,
  }) async {
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

    // Check if Firebase is initialized
    if (Firebase.apps.isEmpty) {
      Utils.flushBarErrorMassage(
        "Firebase is not initialized. Please restart the app.",
        context,
      );
      return;
    }

    // Set loading to true when login process starts
    setloaoding(true);

    try {
      // Attempt login - this will throw an exception if login fails
      await loginWithEmailPassword(email, password, context);

      // Only proceed with navigation if login was successful (no exception thrown)
      print('Login successful, proceeding with navigation...');

      final uid = Utils.getCurrentUid();
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

          // Check if user is blocked
          final isBlocked = userData?['isBlocked'] ?? false;
          if (isBlocked) {
            // Check if it's a temporary block and if it has expired
            final blockType = userData?['blockType'] as String?;
            final blockUntil = userData?['blockUntil'];
            final blockReason = userData?['blockReason'] as String?;

            bool shouldBlock = true;
            String blockMessage = 'Your account has been blocked.';

            if (blockType == 'temporary' && blockUntil != null) {
              DateTime? blockUntilDate;
              if (blockUntil is Timestamp) {
                blockUntilDate = blockUntil.toDate();
              } else if (blockUntil is DateTime) {
                blockUntilDate = blockUntil;
              }

              if (blockUntilDate != null) {
                if (DateTime.now().isAfter(blockUntilDate)) {
                  // Temporary block has expired, unblock the user
                  shouldBlock = false;
                  await FirebaseFirestore.instance
                      .collection('userData')
                      .doc(uid)
                      .update({
                        'isBlocked': false,
                        'blockType': null,
                        'blockUntil': null,
                        'blockReason': null,
                        'status': 'Active',
                      });
                  print('Temporary block expired, user unblocked');
                } else {
                  // Still blocked, show expiration date
                  final formattedDate =
                      '${blockUntilDate.day}/${blockUntilDate.month}/${blockUntilDate.year}';
                  blockMessage =
                      'Your account has been temporarily blocked until $formattedDate.';
                  if (blockReason != null && blockReason.isNotEmpty) {
                    blockMessage += '\nReason: $blockReason';
                  }
                }
              } else {
                // Permanent block or invalid date
                if (blockReason != null && blockReason.isNotEmpty) {
                  blockMessage += '\nReason: $blockReason';
                }
              }
            } else {
              // Permanent block
              if (blockReason != null && blockReason.isNotEmpty) {
                blockMessage += '\nReason: $blockReason';
              }
            }

            if (shouldBlock) {
              // Sign out the user from Firebase Auth
              await FirebaseAuth.instance.signOut();
              // Clear saved login credentials
              await Utils.clearLoginCredentials();
              setloaoding(false);
              Utils.flushBarErrorMassage(blockMessage, context);
              return;
            }
          }

          // Reset loading state before navigation
          setloaoding(false);

          // Save login credentials only if remember me is checked
          if (rememberMe) {
            await Utils.saveLoginCredentials(email, password);
          }

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
          // Reset loading state before navigation
          setloaoding(false);
          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesName.roleView,
            (route) => false,
          );
        }
      } catch (firestoreError) {
        print('Firestore error after successful login: $firestoreError');
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
        // Set loading to false on error
        setloaoding(false);
      }
    } catch (e) {
      // Login failed - error message already shown by loginWithEmailPassword
      print('Login failed, staying on login screen: $e');
      // Set loading to false on login failure
      setloaoding(false);
      return;
    }
  }

  /// Google Sign-In. If user's email is not registered (no userData or no role),
  /// navigate to role selector → profile setup (nameview / CompanyNameView).
  /// Uses google_sign_in 7.2.0 (GoogleSignIn.instance, initialize, authenticate).
  Future<void> performGoogleSignIn(BuildContext context) async {
    if (Firebase.apps.isEmpty) {
      Utils.flushBarErrorMassage(
        "Firebase is not initialized. Please restart the app.",
        context,
      );
      return;
    }
    setSocialLoading(true);
    try {
      await _ensureGoogleSignInInitialized();
      if (!context.mounted) return;

      if (!GoogleSignIn.instance.supportsAuthenticate()) {
        setSocialLoading(false);
        if (context.mounted) {
          Utils.flushBarErrorMassage(
            'Google Sign-In is not supported on this device.',
            context,
          );
        }
        return;
      }

      // Try lightweight auth first (fast path for returning users); otherwise show account picker.
      final lightweightFuture = GoogleSignIn.instance
          .attemptLightweightAuthentication();
      GoogleSignInAccount? googleUser = lightweightFuture != null
          ? await lightweightFuture
          : null;
      googleUser ??= await GoogleSignIn.instance.authenticate();
      if (!context.mounted) return;

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      if (!context.mounted) return;
      final String? idToken = googleAuth.idToken;
      if (idToken == null || idToken.isEmpty) {
        setSocialLoading(false);
        if (context.mounted) {
          Utils.flushBarErrorMassage(
            'Google sign-in failed: no ID token received.',
            context,
          );
        }
        return;
      }
      final credential = GoogleAuthProvider.credential(
        idToken: idToken,
        accessToken: null,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (!context.mounted) return;
      final user = FirebaseAuth.instance.currentUser;
      final email = user?.email ?? '';
      final uid = user?.uid ?? Utils.getCurrentUid();

      final userDoc = await FirebaseFirestore.instance
          .collection('userData')
          .doc(uid)
          .get();
      if (!context.mounted) return;

      if (userDoc.exists) {
        final userData = userDoc.data();
        final role = userData?['role'];

        final isBlocked = userData?['isBlocked'] ?? false;
        if (isBlocked) {
          final blockType = userData?['blockType'] as String?;
          final blockUntil = userData?['blockUntil'];
          final blockReason = userData?['blockReason'] as String?;
          bool shouldBlock = true;
          String blockMessage = 'Your account has been blocked.';

          if (blockType == 'temporary' && blockUntil != null) {
            DateTime? blockUntilDate;
            if (blockUntil is Timestamp) {
              blockUntilDate = blockUntil.toDate();
            } else if (blockUntil is DateTime) {
              blockUntilDate = blockUntil;
            }
            if (blockUntilDate != null) {
              if (DateTime.now().isAfter(blockUntilDate)) {
                shouldBlock = false;
                await FirebaseFirestore.instance
                    .collection('userData')
                    .doc(uid)
                    .update({
                      'isBlocked': false,
                      'blockType': null,
                      'blockUntil': null,
                      'blockReason': null,
                      'status': 'Active',
                    });
                if (!context.mounted) return;
              } else {
                final d = blockUntilDate;
                blockMessage =
                    'Your account has been temporarily blocked until ${d.day}/${d.month}/${d.year}.';
                if (blockReason != null && blockReason.isNotEmpty) {
                  blockMessage += '\nReason: $blockReason';
                }
              }
            } else if (blockReason != null && blockReason.isNotEmpty) {
              blockMessage += '\nReason: $blockReason';
            }
          } else if (blockReason != null && blockReason.isNotEmpty) {
            blockMessage += '\nReason: $blockReason';
          }

          if (shouldBlock) {
            await FirebaseAuth.instance.signOut();
            await GoogleSignIn.instance.signOut();
            setSocialLoading(false);
            if (context.mounted) {
              Utils.flushBarErrorMassage(blockMessage, context);
            }
            return;
          }
        }

        setSocialLoading(false);
        if (role == 'Fighter') {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesName.home,
            (route) => false,
          );
        } else if (role == 'Promoter') {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesName.PromotorBottomNavBar,
            (route) => false,
          );
        } else {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesName.roleView,
            (route) => false,
          );
        }
        return;
      }

      // Not registered: create userData and go to role selector → profile setup
      await FirebaseFirestore.instance.collection('userData').doc(uid).set({
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'role': null,
        'fighterData': null,
        'promoterData': null,
      });
      if (!context.mounted) return;
      setSocialLoading(false);
      Navigator.pushNamedAndRemoveUntil(
        context,
        RoutesName.roleView,
        (route) => false,
      );
    } on GoogleSignInException catch (e) {
      setSocialLoading(false);
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return; // User cancelled — no error message
      }
      if (!context.mounted) return;
      Utils.flushBarErrorMassage(
        'Google sign-in failed: ${e.description ?? 'Unknown error'}',
        context,
      );
    } on FirebaseAuthException catch (e) {
      setSocialLoading(false);
      if (!context.mounted) return;
      String code = e.code;
      if (code.startsWith('firebase_auth/')) {
        code = code.replaceFirst('firebase_auth/', '');
      }
      String msg;
      switch (code) {
        case 'account-exists-with-different-credential':
          msg =
              'An account already exists with the same email. Try signing in with email/password.';
          break;
        case 'invalid-credential':
          msg = 'Google sign-in failed. Please try again.';
          break;
        case 'operation-not-allowed':
          msg = 'Google sign-in is not enabled. Please contact support.';
          break;
        case 'user-disabled':
          msg = 'This account has been disabled.';
          break;
        default:
          msg = 'Google sign-in failed: ${e.message ?? 'Unknown error'}';
      }
      Utils.flushBarErrorMassage(msg, context);
    } catch (e) {
      setSocialLoading(false);
      if (context.mounted) {
        Utils.flushBarErrorMassage(
          e.toString().contains('network')
              ? 'Network error. Check your connection.'
              : 'Google sign-in failed. Please try again.',
          context,
        );
      }
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
    // Set loading to true when logout process starts
    setloaoding(true);

    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn.instance.signOut();

      await Utils.clearAll(); // Clear stored user id
      await Utils.clearLoginCredentials(); // Clear saved login credentials

      // Reset loading state before navigation
      setloaoding(false);

      // Redirect to login
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const Loginview()));
    } catch (e) {
      print('Logout failed: $e');
      // Reset loading state on error
      setloaoding(false);
    }
  }

  /// Delete account: remove login only, notify admin. Admin can later remove data.
  Future<void> requestAccountDeletion(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setloaoding(true);
    try {
      final uid = user.uid;
      final email = user.email ?? '';
      String userName = 'Unknown';
      String role = 'User';

      final doc = await FirebaseFirestore.instance
          .collection('userData')
          .doc(uid)
          .get();
      if (doc.exists) {
        final d = doc.data()!;
        role = d['role'] ?? 'User';
        final fd = d['fighterData'];
        final pd = d['promoterData'];
        if (fd is Map<String, dynamic>) {
          final v = fd['fullName'] ?? fd['name'];
          if (v is String && v.isNotEmpty) userName = v;
        } else if (pd is Map<String, dynamic>) {
          final v = pd['companyName'] ?? pd['prompterName'] ?? pd['fullName'];
          if (v is String && v.isNotEmpty) userName = v;
        }
      }

      await FirebaseFirestore.instance.collection('accountDeleteRequests').add({
        'userId': uid,
        'userEmail': email,
        'userName': userName,
        'role': role,
        'deletedAt': FieldValue.serverTimestamp(),
        'dataRemoved': false,
      });

      await FirebaseFirestore.instance.collection('userData').doc(uid).set({
        'accountDeleted': true,
        'accountDeletedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      bool authDeleted = false;
      try {
        await user.delete();
        authDeleted = true;
      } on FirebaseAuthException catch (e) {
        if (!context.mounted) return;
        final code = e.code.replaceFirst('firebase_auth/', '');
        String msg = 'Could not delete account. Please try again.';
        if (code == 'requires-recent-login') {
          msg =
              'For security, please sign out, sign in again, then try Delete Account.';
        } else if (e.message != null && e.message!.isNotEmpty) {
          msg = e.message!;
        }
        Utils.flushBarErrorMassage(msg, context);
      } catch (e) {
        if (context.mounted) {
          Utils.flushBarErrorMassage(
            'Could not delete account. Please sign out, sign in again, and retry.',
            context,
          );
        }
      }

      if (!authDeleted) {
        setloaoding(false);
        return;
      }

      await FirebaseAuth.instance.signOut();
      await GoogleSignIn.instance.signOut();
      await Utils.clearAll();
      await Utils.clearLoginCredentials();

      if (!context.mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const Loginview()),
        (r) => false,
      );
    } catch (e) {
      print('Request account deletion error: $e');
      if (context.mounted) {
        Utils.flushBarErrorMassage(
          'Something went wrong. Please try again.',
          context,
        );
      }
    } finally {
      setloaoding(false);
    }
  }
}
