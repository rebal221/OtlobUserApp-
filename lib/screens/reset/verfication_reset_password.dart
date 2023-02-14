// ignore_for_file: must_be_immutable, void_checks

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otlob/screens/reset/reset_password_step_three.dart';
import 'package:otlob/server/firebase_auth.dart';
import 'package:otlob/server/firebase_store.dart';
import 'package:otlob/value/colors.dart';
import 'package:otlob/value/constant.dart';
import 'package:otlob/widget/app_button.dart';
import 'package:otlob/widget/app_style_text.dart';
import 'package:otlob/widget/card_template.dart';
import 'package:pinput/pinput.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../../server/controller/app_controller.dart';
import '../Auth/sing_in.dart';

class VerificationResetPasswordScreen extends StatefulWidget {
  Map<String, dynamic> data;

  VerificationResetPasswordScreen({super.key, required this.data});

  @override
  State<VerificationResetPasswordScreen> createState() =>
      _VerificationResetPasswordScreenState();
}

class _VerificationResetPasswordScreenState
    extends State<VerificationResetPasswordScreen> {
  void onTapRecognizer() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SignIn()));
  }

  String _verificationId = "";
  int? _resendToken;
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  int timer = 120;
  bool visibleButton = false;
  String codeOTP = '';
  final defaultPinTheme = PinTheme(
    width: 51.w,
    height: 51.h,
    textStyle: TextStyle(
        locale: const Locale('ar', 'SA'),
        fontSize: 18.sp,
        color: AppColors.black,
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      color: AppColors.greyF,
      borderRadius: BorderRadius.circular(10.r),
      border: Border.all(
        color: AppColors.greyF,
      ),
    ),
  );

  @override
  void initState() {
    // TODO: implement initState
    perform();
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
    _pinPutController.dispose();
    _pinPutFocusNode.dispose();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ));
    super.dispose();
  }

  TextEditingController _password = TextEditingController();
  TextEditingController _passwordconfirm = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //     statusBarColor: HexColor(AppController.hexColorPrimary.value)
    // ));
    print('22222222222222222');
    print(widget.data);
    return Obx(() {
      return Scaffold(
        key: _scaffoldkey,
        backgroundColor: AppColors.white,
        appBar: AppBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.r),
                  bottomRight: Radius.circular(10.r))),
          backgroundColor: HexColor(AppController.hexColorPrimary.value),
          leadingWidth: 100.w,
          leading: TextButton.icon(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.white,
                size: 25.r,
              ),
              label: AppTextStyle(
                name: 'رجوع',
                fontSize: 10.sp,
              )),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
            children: [
              Spacer(),
              Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.password_outlined,
                  size: 55.sp,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
              Align(
                alignment: Alignment.center,
                child: AppTextStyle(
                  textAlign: TextAlign.start,
                  name: 'قم بأدخال كلمة سر جديدة',
                  fontSize: 13.sp,
                  color: AppColors.black,
                  // fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              CardTemplate(
                  isPassword: false,
                  inputType: TextInputType.emailAddress,
                  prefix: 'password',
                  title: 'كلمة السر',
                  controller: _password),
              SizedBox(
                height: 20.h,
              ),
              Align(
                alignment: Alignment.center,
                child: AppTextStyle(
                  textAlign: TextAlign.start,
                  name: 'قم بتأكيد كلمة سر',
                  fontSize: 13.sp,
                  color: AppColors.black,
                  // fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              CardTemplate(
                  isPassword: false,
                  inputType: TextInputType.emailAddress,
                  prefix: 'password',
                  title: 'تأكيد كلمة السر',
                  controller: _passwordconfirm),
              const Spacer(),
              Visibility(
                child: AppButton(
                    color: HexColor(AppController.hexColorPrimary.value),
                    title: 'التالي',
                    onPressed: () async {
                      if (_password.text == _passwordconfirm.text) {
                        FirebaseFirestoreController()
                            .updatePassword(
                                password: _passwordconfirm.text,
                                uid: widget.data['uid'])
                            .then((value) {
                          getSheetSucsses('تم تغيير كلمة السر بنجاح');
                          Get.to(const SignIn());
                        });
                      } else {
                        getSheetError('كلمة السر غير متطابقة');
                      }
                      // try {
                      //   await finalOtp();
                      // } catch (e) {
                      //   log('ex $e');
                      //   getSheetError(e.toString());
                      // }
                    }),
              ),
            ],
          ),
        ),
      );
    });
  }

  Future<void> finalOtp() async {
    try {
      await FirebaseAuth.instance
          .signInWithCredential(PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _pinPutController.text,
      ))
          .then((value) async {
        if (value.user != null) {
          //ToDo:here search in firestore in phoneAuthUid and get doc id and save him to update password from firebase auth and firestore;

          ///FIRST WE WILL TO LOGIN TO THIS USER IN FIREBASE AUTH BY EMAIL AND PASSWORD

          bool status = await FirebaseAuthController().signIn(context,
              email: widget.data['email'], password: widget.data['password']);
          if (status) {
            Get.off(ResetPasswordStepThree(widget.data));
          } else {
            getSheetError('حدث خطأ اثناء تنفيذ العملية ، يرجى المحاولة لاحقا');
          }

          ///Current user now is login to email and password

        }
      }).catchError((error) {
        getSheetError(error.toString());
        SVProgressHUD.dismiss();
      });
    } catch (e) {
      SVProgressHUD.dismiss();
      getSheetError(e.toString());

      FocusScope.of(context).unfocus();
    }
  }

  Future<bool> sendOTP() async {
    await FirebaseAuth.instance
        .verifyPhoneNumber(
      phoneNumber: widget.data['phone'],
      verificationCompleted: (PhoneAuthCredential credential) async {
        try {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              //ToDo:here search in firestore in phoneAuthUid and get doc id and save him to update password from firebase auth and firestore;

              ///FIRST WE WILL TO LOGIN TO THIS USER IN FIREBASE AUTH BY EMAIL AND PASSWORD

              bool status = await FirebaseAuthController().signIn(context,
                  email: widget.data['email'],
                  password: widget.data['password']);
              if (status) {
                Get.off(ResetPasswordStepThree(widget.data));
              } else {
                getSheetError(
                    'حدث خطأ اثناء تنفيذ العملية ، يرجى المحاولة لاحقا');
              }

              ///Current user now is login to email and password

            }
          }).catchError((error) {
            getSheetError(error.toString());
          });
        } catch (e) {
          SVProgressHUD.dismiss();
          getSheetError(e.toString());

          FocusScope.of(context).unfocus();
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        log(e.message.toString());
      },
      timeout: Duration(seconds: timer),
      forceResendingToken: _resendToken,
      codeSent: (String verficationID, int? resendToken) {
        if (mounted) {
          setState(() {
            _verificationId = verficationID;
            _resendToken = resendToken;
            log('codeSent ');
            timer = 120;
          });
        }
      },
      codeAutoRetrievalTimeout: (String verificationID) {
        if (mounted) {
          setState(() {
            timer = 120;
            _verificationId = verificationID;
          });
        }
      },
    )
        .onError((error, stackTrace) {
      getSheetError(error.toString());
      SVProgressHUD.dismiss();
      return false;
    });
    return true;
  }

  Future<void> perform() async {
    await sendOTP().catchError((onError) {
      getSheetError(onError.toString());
      SVProgressHUD.dismiss();
      log(onError.toString());
    });
  }
}
