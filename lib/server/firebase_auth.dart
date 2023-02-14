// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:otlob/screens/Auth/sing_in.dart';
import 'package:otlob/server/firebase_store.dart';
import 'package:otlob/server/model/user_model.dart';
import 'package:otlob/services/preferences/app_preferences.dart';
import 'package:otlob/value/constant.dart';

import '../utils/helpers.dart';

class FirebaseAuthController with Helpers {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FacebookAuth _facebookAuth = FacebookAuth.instance;
  final GoogleSignIn _googleAuth = GoogleSignIn();

  // final twitterLogin = TwitterLogin(
  //     apiKey: Config.apikey_twitter,
  //     apiSecretKey: Config.secretkey_twitter,
  //     redirectURI: "socialauth://");
  User get user => _firebaseAuth.currentUser!;

  bool get isLoggedIn => _firebaseAuth.currentUser != null;

  Future<User?> createAccount(BuildContext context,
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      // await _controlEmailValidation(context, credential: userCredential);
      return userCredential.user;
    } on FirebaseException catch (e) {
      _controllerErrorCode(context, e);
      getSheetError(e.toString());
      SVProgressHUD.dismiss();
    } catch (e) {
      log(e.toString());
      getSheetError(e.toString());
      SVProgressHUD.dismiss();

      return null;
    }
    return null;
  }

  Future<bool> forgetPassword(BuildContext context,
      {required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      //
      _controllerErrorCode(context, e);
    } catch (e) {
      log('exception is =>$e');
      return false;
    }
    return false;
  }

  Future<void> signOut() async {
    await _googleAuth.signOut();
    await _facebookAuth.logOut();
    await _firebaseAuth.signOut();
  }

  Future<bool> signIn(BuildContext context,
      {required String email, required String password}) async {
    bool r = false;
    try {
      log('i am in try');
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: userCredential.user!.uid)
          .get()
          .then((value) {
        r = value.docs[0]['isVerifyPhone'];
      });
      return r ? r : false;
    } on FirebaseAuthException catch (e) {
      _controllerErrorCode(context, e);
      getSheetError(e.toString());
      SVProgressHUD.dismiss();
      return false;
    } catch (e) {
      log('i am in catch $e');
      getSheetError(e.toString());

      SVProgressHUD.dismiss();

      //
    }
    return false;
  }

  Future<bool> _controlEmailValidation(BuildContext context,
      {required UserCredential credential}) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      Map e = value.data() as Map;
      if (!e['isVerifyPhone']) {
        credential.user!.sendEmailVerification();
        _firebaseAuth.signOut();

        getSheetError('تم إرسال رابط لتفعيل حسابك على البريد الإلكتروني');
        SVProgressHUD.dismiss();

        return false;
      }
    });

    return true;
  }

  void _controllerErrorCode(
      BuildContext context, FirebaseException authException) {
    String message = '';

    switch (authException.code) {
      case 'email-already-in-use':
        message = 'عذرًا البريد الإلكتروني موجود مسبقًا';

        break;
      case 'invalid-email':
        message = 'عذرًا  خطأ في البريد الإلكتروني';

        break;
      case 'operation-not-allowed':
        message = 'عذرًا  العملية غير مسموح بها';

        break;
      case 'weak-password':
        message = 'عذرًا  كلمة المرور ضعيفة';

        break;
      case 'user-not-found':
        message = 'عذرًا  المستخدم غير موجود';

        break;
      case 'requires-recent-login':
        message = 'عذرًا يرجى إعادة تسجيل الدخول';

        break;

      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
        // case "email-already-in-use":
        message = 'عذرًا البريد الإلكتروني موجود مسبقًا';
        break;

      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        message = "عذرًا خطأ في كلمة المرور/ البريد الإلكتروني";
        break;
      case "ERROR_USER_NOT_FOUND":
        // case "user-not-found":
        message = 'عذرًا  المستخدم غير موجود';
        break;
      case "ERROR_USER_DISABLED":
      case "user-disabled":
        message = "عذرًا الحساب معطل";
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        // case "operation-not-allowed":
        message = 'عذرًا  العملية غير مسموح بها';
        break;
      // case "ERROR_OPERATION_NOT_ALLOWED":
      // case "operation-not-allowed":
      //   message = "Server error, please try again later.";
      //   break;
      case "ERROR_INVALID_EMAIL":
        // case "invalid-email":
        message = 'عذرًا  خطأ في البريد الإلكتروني';
        break;

      default:
        message = "مشكلة في تسجيل الدخول الرجاء المحاولة مرة أخرى";
        break;
    }
    getSheetError(message);
  }

  Future<bool> updateEmailAuth(BuildContext context,
      {required String email}) async {
    try {
      if (email != user.email) {
        await _firebaseAuth.currentUser!.verifyBeforeUpdateEmail(email);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log('error${e.toString()}');
      showSnackBar(
          context: context, content: 'عذرًا البريد موجود مسبقًا', error: true);
      return false;
    }
  }

  Future<bool> updatePassword(
      {required BuildContext context, required String? password}) async {
    if (password != null && password.isNotEmpty) {
      if (password.length >= 6) {
        await _firebaseAuth.currentUser!
            .updatePassword(password)
            .then((value) async {
          bool status = await FirebaseFirestoreController().updatePassword(
              password: password, uid: _firebaseAuth.currentUser!.uid);
          if (status) {
            SVProgressHUD.dismiss();
            getSheetSucsses('تمت العملية بنجاح');
            AppPreferences().logOutUser();
            Get.off(const SignIn());
          }
          return status;
        }).catchError((value) {
          debugPrint('updatePassword error is $value');
          getSheetError(value.toString());
          SVProgressHUD.dismiss();

          return false;
        });
      }
      return false;
    } else {
      getSheetError('يجب ان تحتوي كلمة المرور على 6 ارقام او احرف');
      return false;
    }
  }

  Future<bool> signInWithGoogle({required BuildContext context}) async {
    final GoogleSignInAccount? googleSignInAccount = await _googleAuth.signIn();
    if (googleSignInAccount != null) {
      try {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        // signing to firebase user instance
        final User userDetails =
            (await _firebaseAuth.signInWithCredential(credential)).user!;

        // now save all values
        AppPreferences()
            .setData(key: 'name', value: userDetails.displayName.toString());
        AppPreferences()
            .setData(key: 'email', value: userDetails.email.toString());
        AppPreferences()
            .setData(key: 'image', value: userDetails.photoURL.toString());
        AppPreferences().setData(key: 'provider', value: 'Google');
        AppPreferences().setData(key: 'uid', value: userDetails.uid);
        //ToDo:this function is starting when user comp all data in form;
        await FirebaseFirestoreController().checkUserExists(userDetails.uid);

        return true;
      } on FirebaseAuthException catch (e) {
        _controllerErrorCode(context, e);
        getSheetError(e.toString());
        SVProgressHUD.dismiss();

        return false;
      }
    }
    SVProgressHUD.dismiss();
    return false;
  }

  Future signInWithFacebook({required BuildContext context}) async {
    // final status = await Permission.appTrackingTransparency.request();
    // if (status == PermissionStatus.granted) {
    log('PermissionStatus.granted');

    final LoginResult result = await _facebookAuth.login(
      permissions: [
        'public_profile',
        'email',
        // 'pages_show_list',
        // 'pages_messaging',
        // 'pages_manage_metadata'
      ],
    );
    log('result === >>> ${result.status}');
    log('message === >>> ${result.message}');
    final token = result.accessToken!.token;
    log('token ===>>>> $token');

    log('Facebook token userID : ${result.accessToken!.grantedPermissions}');
    final graphResponse = await http.get(Uri.parse('https://graph.facebook.com/'
        'v2.12/me?fields=name,first_name,last_name,email&access_token=$token'));
    final userData = await _facebookAuth.getUserData();
    log('facebook_login_data:-');
    log(userData.toString());
    if (result.status == LoginStatus.success) {
      final profile = jsonDecode(graphResponse.body);
      log("Profile is equal to $profile");
      try {
        log('token is ${result.accessToken!.token}');
        try {
          final OAuthCredential credential =
              FacebookAuthProvider.credential(result.accessToken!.token);
          await _firebaseAuth
              .signInWithCredential(credential)
              .catchError((onError) {
            getSheetError(onError.toString());
          });
        } catch (e) {
          getSheetError(e.toString());
        }
        // saving the values
        AppPreferences().setData(
            key: 'nameRegister',
            value: profile['first_name'] + ' ' + profile['last_name']);
        AppPreferences().setData(key: 'emailRegister', value: profile['email']);
        AppPreferences()
            .setData(key: 'image', value: userData['picture']['data']['url']);
        AppPreferences().setData(key: 'provider', value: 'FACEBOOK');
        AppPreferences().setData(key: 'uid', value: profile['id']);
        //ToDo:this function is starting when user comp all data in form;
        await FirebaseFirestoreController().checkUserExists(profile['id']);
      } on FirebaseAuthException catch (e) {
        _controllerErrorCode(context, e);
        getSheetError(e.toString());
        SVProgressHUD.dismiss();

        return false;
      }
    }
    SVProgressHUD.dismiss();
    return false;
  }
}
