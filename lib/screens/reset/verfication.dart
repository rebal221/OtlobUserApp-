// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otlob/screens/menu/Drawer.dart';
import 'package:otlob/server/firebase_auth.dart';
import 'package:otlob/server/firebase_store.dart';
import 'package:otlob/server/model/user_model.dart';
import 'package:otlob/services/preferences/app_preferences.dart';
import 'package:otlob/value/colors.dart';
import 'package:otlob/value/constant.dart';
import 'package:otlob/widget/app_button.dart';
import 'package:otlob/widget/app_style_text.dart';
import 'package:pinput/pinput.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../../server/controller/app_controller.dart';
import '../Auth/sing_in.dart';

class VerificationScreen extends StatefulWidget {
  UserModel userModel;

  VerificationScreen({super.key, required this.userModel});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
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
    // sendOTP(phone: widget.userModel.phone);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ));
    super.initState();
    signUp();
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

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //     statusBarColor: HexColor(AppController.hexColorPrimary.value)
    // ));
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
            mainAxisAlignment: MainAxisAlignment.center,
            // padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
            children: [
              const Spacer(),
              Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        SizedBox(height: 30),
                        AppTextStyle(
                          textAlign: TextAlign.center,
                          name:
                              'نشكرك على انشاء الحساب تم ارسال رابط التفعيل الى بريدك الألكتروني',
                          fontSize: 14.sp,
                          color: AppColors.black,
                          // fontWeight: FontWeight.w400,
                        ),
                        SizedBox(height: 30),
                        Image.asset('images/send_email.png'),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
              // Directionality(
              //   textDirection: TextDirection.ltr,
              //   child: Pinput(
              //     length: 6,
              //     errorTextStyle:
              //         const TextStyle(fontSize: 25.0, color: Colors.red),

              //     focusNode: _pinPutFocusNode,
              //     controller: _pinPutController,
              //     // eachFieldWidth: 40.0,
              //     // eachFieldHeight: 55.0,
              //     pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
              //     androidSmsAutofillMethod:
              //         AndroidSmsAutofillMethod.smsUserConsentApi,
              //     submittedPinTheme: defaultPinTheme,
              //     focusedPinTheme: defaultPinTheme,
              //     followingPinTheme: defaultPinTheme,
              //     pinAnimationType: PinAnimationType.fade,
              //     onSubmitted: (pin) async {
              //       if (pin.isNotEmpty && pin.length == 6) {}
              //     },
              //     onCompleted: (String value) {
              //       if (mounted) {
              //         setState(() {
              //           codeOTP = value;
              //           visibleButton = true;
              //         });
              //       }
              //     },
              //   ),
              // ),
              // SizedBox(
              //   height: 5.h,
              // ),
              // Align(
              //   alignment: Alignment.center,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       AppTextStyle(
              //         textAlign: TextAlign.center,
              //         name: '''إعادة إرسال الرمز خلال''',
              //         fontSize: 10.sp,
              //         fontWeight: FontWeight.w400,
              //         color: AppColors.black,
              //         // fontWeight: FontWeight.w400,
              //       ),
              //       SizedBox(
              //         width: 5.w,
              //       ),
              //       Builder(builder: (context) {
              //         return Countdown(
              //           seconds: timer,
              //           build: (_, double time) => RichText(
              //             text: TextSpan(
              //                 text: '',
              //                 style: TextStyle(
              //                   fontSize: 10.sp,
              //                   fontWeight: FontWeight.w400,
              //                   color: HexColor(
              //                       AppController.hexColorPrimary.value),
              //                   // color: Theme.of(context).inputDecorationTheme.labelStyle?.color
              //                 ),
              //                 children: <TextSpan>[
              //                   TextSpan(
              //                     text: time.toString(),
              //                     style: GoogleFonts.cairo(
              //                       color: HexColor(
              //                           AppController.hexColorPrimary.value),
              //                       // letterSpacing: letterSpacing,
              //                       // wordSpacing: wordSpacing,
              //                       fontWeight: FontWeight.w400,
              //                       fontSize: 13.sp,
              //                     ),
              //                   ),
              //                   TextSpan(
              //                     text: '  ثانية',
              //                     style: GoogleFonts.cairo(
              //                       color: AppColors.black,
              //                       // letterSpacing: letterSpacing,
              //                       // wordSpacing: wordSpacing,
              //                       fontWeight: FontWeight.w400,
              //                       fontSize: 12.sp,
              //                     ),
              //                   )
              //                 ]),
              //           ),
              //           onFinished: () {
              //             if (mounted) {
              //               setState(() {
              //                 timer = 120;
              //               });
              //             }
              //             sendOTP(phone: widget.userModel.phone);
              //           },
              //         );
              //       }),
              //     ],
              //   ),
              // ),
              const Spacer(),
              AppButton(
                  color: HexColor(AppController.hexColorPrimary.value),
                  title: 'التالي',
                  onPressed: () async {
                    Get.to(SignIn());
                  }),
            ],
          ),
        ),
      );
    });
  }

  Future<void> signUp() async {
    SVProgressHUD.show();

    try {
      log('login done');
      widget.userModel.isVerifyPhone = true;
      // widget.userModel.phoneAuthUid = value.user!.uid;
      //ToDo:update all data in firestore

      if (AppPreferences().getData(key: 'emailRegister').isNotEmpty) {
        widget.userModel.uid = AppPreferences().getData(key: 'uid');

        await FirebaseFirestoreController()
            .addUserToFirestore(userModel: widget.userModel);
        //ToDo: here sign up by author provider ;
        log('author provider');
        SVProgressHUD.dismiss();
        getSheetSucsses('تم إنشاء الحساب بنجاح');
        Get.offAll(menu(currentItem: MenuItems.Home));
      } else {
        User? user = await FirebaseAuthController()
            .createAccount(context,
                email: widget.userModel.email.trim(),
                password: widget.userModel.password)
            .catchError((onError) {
          SVProgressHUD.dismiss();
        });
        if (user != null) {
          //ToDo: here sign up by email provider ;
          widget.userModel.uid = user.uid;
          widget.userModel.emailAuthUid = user.uid;
          await FirebaseFirestoreController()
              .addUserToFirestore(userModel: widget.userModel);
          log('email provider');
          SVProgressHUD.dismiss();
          getSheetSucsses(
              'تم إنشاء الحساب بنجاح ، يرجى تأكيد\n تفعيل الحساب عبر البريد الالكتروني !');
          Get.offAll(const SignIn());
        }
      }
    } catch (e) {
      SVProgressHUD.dismiss();
      getSheetError(e.toString());

      FocusScope.of(context).unfocus();
    }
  }

  Future<bool> sendOTP({required String phone}) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        try {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              log('login done');
              widget.userModel.isVerifyPhone = true;
              widget.userModel.phoneAuthUid = value.user!.uid;
              //ToDo:update all data in firestore

              if (AppPreferences().getData(key: 'email').isNotEmpty) {
                widget.userModel.uid = AppPreferences().getData(key: 'uid');

                await FirebaseFirestoreController()
                    .addUserToFirestore(userModel: widget.userModel);
                //ToDo: here sign up by author provider ;
                log('author provider');
                SVProgressHUD.dismiss();
                getSheetSucsses('تم إنشاء الحساب بنجاح');
                Get.offAll(menu(currentItem: MenuItems.Home));
              } else {
                User? user = await FirebaseAuthController()
                    .createAccount(context,
                        email: widget.userModel.email.trim(),
                        password: widget.userModel.password)
                    .catchError((onError) {
                  SVProgressHUD.dismiss();
                });
                if (user != null) {
                  //ToDo: here sign up by email provider ;
                  widget.userModel.uid = user.uid;
                  widget.userModel.emailAuthUid = user.uid;
                  await FirebaseFirestoreController()
                      .addUserToFirestore(userModel: widget.userModel);
                  log('email provider');
                  SVProgressHUD.dismiss();
                  getSheetSucsses(
                      'تم إنشاء الحساب بنجاح ، يرجى تأكيد تفعيل الحساب عبر البريد الالكتروني !');
                  Get.offAll(const SignIn());
                }
              }
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
            print(verficationID);
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
    );
    log("_verificationId: $_verificationId");
    return true;
  }
}
