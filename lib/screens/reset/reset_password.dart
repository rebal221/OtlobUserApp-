// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otlob/screens/reset/verfication_reset_password.dart';
import 'package:otlob/server/firebase_store.dart';
import 'package:otlob/value/colors.dart';
import 'package:otlob/widget/app_style_text.dart';
import 'package:otlob/widget/card_template.dart';

import '../../server/controller/app_controller.dart';
import '../../value/constant.dart';
import '../../widget/app_button.dart';
import '../../widget/card_template_phone.dart';
import '../Auth/sing_in.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  void onTapRecognizer() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SignIn()));
  }

  late TextEditingController email;

  @override
  void initState() {
    // TODO: implement initState
    email = TextEditingController();

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
    email.dispose();

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

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //     statusBarColor: HexColor(AppController.hexColorPrimary.value)
    // ));
    return Obx(() {
      return Scaffold(
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
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
          child: Column(
            // padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
            children: [
              Align(
                alignment: Alignment.center,
                child: AppTextStyle(
                  textAlign: TextAlign.center,
                  name:
                      'من فضلك قم بأدخال بريدك الالكتروني كي يتم تعيين كلمة السر',
                  fontSize: 14.sp,
                  color: AppColors.black,
                  // fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 57.h,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: CardTemplate(
                      isPassword: false,
                      inputType: TextInputType.emailAddress,
                      prefix: 'mail',
                      title: 'البريد الإلكتروني',
                      controller: email)),
              const Spacer(),
              AppButton(
                  color: HexColor(AppController.hexColorPrimary.value),
                  title: 'التالي',
                  onPressed: () async {
                    await perform();
                  }),
            ],
          ),
        ),
      );
    });
  }

  bool checkData() {
    if (email.text.trim().isNotEmpty) {
      return true;
    }
    getSheetError('يرجى تعبئة البريد الالكتروني');
    return false;
  }

  Future<bool> checkPhoneFromFirestore() async {
    SVProgressHUD.show();

    Map<String, dynamic>? data =
        await FirebaseFirestoreController().getUserbyemail(email: email.text);
    if (!data.isNull) {
      if (data!['provider'] == 'email') {
        SVProgressHUD.dismiss();
        Get.to(VerificationResetPasswordScreen(data: data));
        return true;
      } else if (data['provider'] == 'Google') {
        SVProgressHUD.dismiss();

        getSheetSucsses(
            'الحساب موجود ، يجب تسجيل الدخول باستخدام جوجل ، لا يمكن استرجاع كلمة المرور عبر العملية الحالية');
        Get.off(const SignIn());
        return false;
      } else {
        SVProgressHUD.dismiss();

        getSheetSucsses(
            'الحساب موجود ، يجب تسجيل الدخول باستخدام فيسبوك ، لا يمكن استرجاع كلمة المرور عبر العملية الحالية');
        Get.off(const SignIn());
        return false;
      }
    }
    getSheetError('لا يوجد حساب لرقم الهاتف المدخل');
    SVProgressHUD.dismiss();
    return false;
  }

  Future<void> perform() async {
    if (checkData()) {
      await checkPhoneFromFirestore();
    }
  }
}
