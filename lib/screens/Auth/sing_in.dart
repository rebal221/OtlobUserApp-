import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otlob/lanugage/app_get.dart';
import 'package:otlob/screens/Auth/sign_up.dart';
import 'package:otlob/server/firebase_auth.dart';
import 'package:otlob/server/firebase_store.dart';
import 'package:otlob/services/network/network_controller.dart';
import 'package:otlob/services/preferences/app_preferences.dart';
import 'package:otlob/value/colors.dart';
import 'package:otlob/value/constant.dart';
import 'package:otlob/widget/app_button.dart';
import 'package:otlob/widget/app_button_icon.dart';
import 'package:otlob/widget/app_style_text.dart';
import 'package:otlob/widget/card_template.dart';
import 'package:otlob/widget/custom_image.dart';

import '../../server/controller/app_controller.dart';
import '../menu/Drawer.dart';
import '../reset/reset_password.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late final TapGestureRecognizer _recognizer = TapGestureRecognizer()
    ..onTap = () => onTapRecognizer();
  AppGet appGet = Get.find();
  AppController controller = Get.find();

  NetworkController networkController = Get.find();
  late TextEditingController _email;
  late TextEditingController _password;

  void onTapRecognizer() {
    AppPreferences().clearKey('emailRegister');
    AppPreferences().clearKey('nameRegister');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
  }

  @override
  void initState() {
    log('app color is ${AppController.hexColorPrimary.value}');
    _email = TextEditingController();
    _password = TextEditingController();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ));
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: Stack(
          children: [
            const CustomPngImage(
              imageName: 'login_image',
              height: double.infinity,
              width: double.infinity,
              boxFit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    AppColors.black.withOpacity(.25),
                    AppColors.black,
                  ])),
              height: double.infinity,
              width: double.infinity,
            ),
            Center(
              child: ListView(
                padding: EdgeInsets.only(
                    right: 16.w, left: 16.w, top: 50.h, bottom: 20.h),
                shrinkWrap: true,
                children: [
                  CustomImageNetwork(
                    // iconSize: 40.r,
                    imageUrl: AppController.appData.value.appLogo,
                    height: 98.h,
                    width: 115.w,
                    // color: HexColor(AppController.hexColorPrimary.value),
                  ),
                  SizedBox(
                    height: 39.h,
                  ),
                  AppTextStyle(
                    name: 'البريد الالكتروني',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w900,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  CardTemplate(
                      isPassword: false,
                      inputType: TextInputType.emailAddress,
                      prefix: 'mail',
                      title: 'البريد الإلكتروني',
                      controller: _email),
                  SizedBox(
                    height: 13.h,
                  ),
                  AppTextStyle(
                    name: 'كلمة السر',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w900,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  CardTemplate(
                      isPassword: true,
                      inputType: TextInputType.visiblePassword,
                      prefix: 'password',
                      title: 'كلمة السر',
                      controller: _password),
                  SizedBox(
                    height: 5.h,
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(const ResetPassword());
                    },
                    child: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: AppTextStyle(
                        name: 'نسيت كلمة السر؟',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 19.h,
                  ),
                  AppButton(
                      color: HexColor(AppController.hexColorPrimary.value),
                      title: 'تسجيل دخول',
                      onPressed: () async {
                        await performSignIn();
                      }),
                  SizedBox(
                    height: 35.h,
                  ),
                  // ),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: Divider(
                  //         color: HexColor(AppController.hexColorPrimary.value),
                  //       ),
                  //     ),
                  //     SizedBox(
                  //       width: 13.w,
                  //     ),
                  //     Container(
                  //       height: 20.h,
                  //       width: 20.w,
                  //       decoration: BoxDecoration(
                  //         color: HexColor(AppController.hexColorPrimary.value),
                  //         shape: BoxShape.circle,
                  //       ),
                  //       child: Center(
                  //         child: AppTextStyle(
                  //           name: 'أو',
                  //           fontSize: 7.sp,
                  //         ),
                  //       ),
                  //     ),
                  //     SizedBox(
                  //       width: 13.w,
                  //     ),
                  //     Expanded(
                  //       child: Divider(
                  //         color: HexColor(AppController.hexColorPrimary.value),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 27.h,
                  // ),
                  // AppButtonIcon(
                  //   title: 'دخول باستخدام فيسبوك',
                  //   onPressed: () async {
                  //     await signInWithFacebook();
                  //   },
                  //   height: 23.h,
                  //   color: AppColors.facebook,
                  //   icon: 'facebook',
                  // ),
                  // SizedBox(
                  //   height: 17.h,
                  // ),
                  // AppButtonIcon(
                  //   title: 'دخول باستخدام جوجل',
                  //   onPressed: () async {
                  //     log('click');
                  //     await signInWithGoogle();
                  //   },
                  //   height: 22.h,
                  //   color: AppColors.google,
                  //   icon: 'google',
                  // ),

                  SizedBox(
                    height: 17.h,
                  ),
                  // AppButtonIcon(
                  //   title: 'دخول باستخدام تويتر',
                  //   onPressed: () {},
                  //   height: 20.h,
                  //   color: AppColors.twitter,
                  //   icon: 'twitter',
                  // ),
                  SizedBox(
                    height: 25.h,
                  ),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'ليس لديك حساب ؟',
                        style: GoogleFonts.almarai(
                            fontWeight: FontWeight.w900,
                            color: AppColors.white,
                            fontSize: 13.sp,
                            height: 1.5),
                        children: <TextSpan>[
                          const TextSpan(text: '  '),
                          TextSpan(
                              recognizer: _recognizer,
                              text: 'سجل الآن',
                              style: GoogleFonts.almarai(
                                  color: HexColor(
                                      AppController.hexColorPrimary.value),
                                  fontWeight: FontWeight.w900,
                                  fontSize: 13.sp,
                                  height: 1.5)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  //ToDo:Start in login

  ///Sign in with google provider
  Future<void> signInWithGoogle() async {
    bool checkInternet = await networkController.initConnectivity();
    if (checkInternet) {
      SVProgressHUD.show();
      bool status =
          await FirebaseAuthController().signInWithGoogle(context: context);
      if (status) {
        bool statusAccountStatus = await FirebaseFirestoreController()
            .checkUserExists(AppPreferences().getData(key: 'uid'));
        if (statusAccountStatus) {
          await generalCheckAuth(AppPreferences().getData(key: 'uid'));
        } else {
          //ToDo:get to create Account Data ;
          getSheetSucsses('يرجى استكمال البيانات المتبقية');
          SVProgressHUD.dismiss();
        }
      }
    } else {
      getSheetError('يرجى التحقق من اتصال الانترنت !');
    }
  }

  ///sign in with facebook provider

  Future<void> signInWithFacebook() async {
    bool checkInternet = await networkController.initConnectivity();
    if (checkInternet) {
      SVProgressHUD.show();
      bool? status = await FirebaseAuthController()
          .signInWithFacebook(context: context)
          .catchError((onError) {
        getSheetError(onError.toString());
        SVProgressHUD.dismiss();

        log('exc ===>>>> $onError');
      });
      if (status != null && status) {
        bool statusAccountStatus = await FirebaseFirestoreController()
            .checkUserExists(AppPreferences().getData(key: 'uid'));
        if (statusAccountStatus) {
          await generalCheckAuth(AppPreferences().getData(key: 'uid'));
        } else {
          //ToDo:get to create Account Data ;
          getSheetSucsses('يرجى استكمال البيانات المتبقية');
          SVProgressHUD.dismiss();
        }
      }
    } else {
      getSheetError('يرجى التحقق من اتصال الانترنت !');
    }
  }

  ///sign in with email provider
  //checkData
  bool checkData() {
    if (_email.text.trim().isNotEmpty && _password.text.trim().isNotEmpty) {
      if (EmailValidator.validate(_email.text.trim())) {
        return true;
      }
      getSheetError('يرجى التاكد من صيغة البريد الإكتروني');
    }
    getSheetError('يرجى تعبئة البريد الإكتروني وكلمة السر');
    return false;
  }

  //signInWithEmailAndPassword

  Future<bool> signInWithEmailAndPassword() async {
    return await FirebaseAuthController()
        .signIn(context, email: _email.text, password: _password.text);
  }

  //performSignIn

  Future<void> performSignIn() async {
    if (checkData()) {
      SVProgressHUD.show();
      FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: _email.text)
          .get()
          .then((value) {
        value.docs.isEmpty
            ? {
                getSheetError('عذرا المستخدم غير موجود'),
                SVProgressHUD.dismiss()
              }
            : checkLogin(value.docs[0]['uid']);
      });
    }
  }

  //checkLogin

  Future<void> checkLogin(uid) async {
    bool statusAccountStatus =
        await FirebaseFirestoreController().checkUserExists(uid);
    if (statusAccountStatus) {
      //ToDo:here get data user form firestore and save in local storage
      await generalCheckAuth(uid);
    }
  }

  //generalCheckAuth

  Future<void> generalCheckAuth(uid) async {
    Map e = {};
    await FirebaseFirestoreController()
        .getUserDataFromFirestore(uid: uid)
        .then((value) {
      if (value!['password'] == _password.text &&
          value!['email'] == _email.text) {
        FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _email.text, password: _password.text);
        getSheetSucsses('تمت عملية تسجيل الدخول بنجاح');
        SVProgressHUD.dismiss();
        log('to home');
        Get.offAll(menu(currentItem: MenuItems.Home));
      } else {
        getSheetError('كلمة السر او البريد خطأ يرجى التحقق');
        SVProgressHUD.dismiss();
      }
    });
  }
}
