import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otlob/screens/Auth/sing_in.dart';
import 'package:otlob/screens/menu/Drawer.dart';
import 'package:otlob/server/controller/app_controller.dart';
import 'package:otlob/server/firebase_auth.dart';
import 'package:otlob/server/firebase_store.dart';
import 'package:otlob/server/model/user_model.dart';
import 'package:otlob/services/preferences/app_preferences.dart';
import 'package:otlob/value/colors.dart';
import 'package:otlob/value/constant.dart';
import 'package:otlob/widget/app_button.dart';
import 'package:otlob/widget/app_style_text.dart';
// import 'package:phone_auth_project/home.dart';
import 'package:pinput/pinput.dart';
import 'package:timer_count_down/timer_count_down.dart';

class OTPScreen extends StatefulWidget {
  final String phone;
  final UserModel userModel;
  OTPScreen(this.phone, this.userModel);
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String? _verificationCode;
  final TextEditingController _pinPutController = TextEditingController();
  int timer = 60;
  bool visibleButton = false;
  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black),
      borderRadius: BorderRadius.circular(20),
    ),
  );
  @override
  Widget build(BuildContext context) {
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
              Spacer(),
              Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.done,
                  color: Colors.green.shade400,
                  size: 75.sp,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: AppTextStyle(
                  textAlign: TextAlign.center,
                  name:
                      'مرحباً ${widget.userModel.name}\nتم تسجيل الحساب بنجاح ',
                  fontSize: 14.sp,
                  color: AppColors.black,
                  // fontWeight: FontWeight.w400,
                ),
              ),

              SizedBox(
                height: 40.h,
              ),
              // const SizedBox(
              //   height: 20,
              // ),
              // Directionality(
              //   textDirection: TextDirection.ltr,
              //   child: Pinput(
              //     length: 6,
              //     errorTextStyle:
              //         const TextStyle(fontSize: 25.0, color: Colors.red),

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
              //       if (pin.isNotEmpty && pin.length == 6) {
              //         finalStep();
              //       }
              //     },
              //     onCompleted: (String value) {
              //       if (mounted) {
              //         setState(() {
              //           visibleButton = true;
              //         });
              //       }
              //       finalStep();
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
              //                 timer = 60;
              //                 _verifyPhone();
              //               });
              //             }
              //             // sendOTP(phone: widget.userModel.phone);
              //           },
              //         );
              //       }),
              //     ],
              //   ),
              // ),
              const Spacer(),
              Visibility(
                child: AppButton(
                    color: HexColor(AppController.hexColorPrimary.value),
                    title: 'التالي',
                    onPressed: () async {
                      finalStep();
                    }),
              ),
            ],
          ),
        ),
      );
    });
  }

  finalStep() async {
    SVProgressHUD.show();
    try {
      if (AppPreferences().getData(key: 'emailRegister').isNotEmpty) {
        widget.userModel.uid = AppPreferences().getData(key: 'uid');

        await FirebaseFirestoreController()
            .addUserToFirestore(userModel: widget.userModel);
        //ToDo: here sign up by author provider ;
        print('-----------author provider');
        SVProgressHUD.dismiss();
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
          // print('email provider');
          SVProgressHUD.dismiss();
          getSheetSucsses('تم إنشاء الحساب بنجاح !');
          Get.offAll(const SignIn());
        }
      }

      // await FirebaseAuth.instance
      //     .signInWithCredential(PhoneAuthProvider.credential(
      //         verificationId: _verificationCode!,
      //         smsCode: _pinPutController.text))
      //     .then((value) async {
      //   print('-----------login done');
      //   widget.userModel.isVerifyPhone = true;
      //   widget.userModel.phoneAuthUid = value.user!.uid;
      //ToDo:update all data in firestore

      // print(widget.userModel.);
      // if (value.user != null) {
      //   print('2222222222222222222222222');
      //   await FirebaseFirestoreController()
      //       .addUserToFirestore(userModel: widget.userModel);
      //   print('==================>>> login done');
      //   //ToDo: here sign up by author provider ;
      //   print('author provider');
      //   SVProgressHUD.dismiss();
      //   getSheetSucsses('تم إنشاء الحساب بنجاح');
      //   Get.offAll(const SignIn());
      // }
      // getSheetSucsses('تم التسجيل بنجاح');
      // });
    } catch (e) {
      getSheetError('عذرا هناك حطأ ما يرجى المحاولة مرة اخرى');
    }
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+1${widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {}
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String? verficationID, int? resendToken) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 60));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ));
    _verifyPhone();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ));
    super.dispose();
  }
}
