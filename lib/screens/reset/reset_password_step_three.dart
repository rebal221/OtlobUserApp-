// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otlob/server/firebase_auth.dart';
import 'package:otlob/value/colors.dart';
import 'package:otlob/value/constant.dart';
import 'package:otlob/widget/app_style_text.dart';

import '../../server/controller/app_controller.dart';
import '../../widget/app_button.dart';
import '../../widget/card_template_not.dart';
import '../Auth/sing_in.dart';

class ResetPasswordStepThree extends StatefulWidget {
  Map<String, dynamic> data;

  ResetPasswordStepThree(this.data, {super.key});

  @override
  State<ResetPasswordStepThree> createState() => _ResetPasswordStepThreeState();
}

class _ResetPasswordStepThreeState extends State<ResetPasswordStepThree> {
  void onTapRecognizer() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SignIn()));
  }

  late TextEditingController _new;

  late TextEditingController _newConfirm;

  @override
  void initState() {
    // TODO: implement initState
    _new = TextEditingController();
    _newConfirm = TextEditingController();

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
    _new.dispose();
    _newConfirm.dispose();
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
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
          child: Column(
            // padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
            children: [
              Align(
                alignment: Alignment.center,
                child: AppTextStyle(
                  textAlign: TextAlign.center,
                  name: ''' تغير كلمة المرور الخاصة بالحساب  ''',
                  fontSize: 14.sp,
                  color: AppColors.black,
                  // fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 57.h,
              ),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: AppTextStyle(
                  textAlign: TextAlign.center,
                  name: 'كلمة السر الجديدة',
                  fontSize: 12.sp,
                  color: AppColors.black,
                  // fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 7.h,
              ),
              CardTemplateTransparent(
                  suffix: Icons.visibility_off_sharp,
                  prefix: 'password',
                  title: 'كلمة السر الجديدة',
                  controller: _new),
              SizedBox(
                height: 20.h,
              ),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: AppTextStyle(
                  textAlign: TextAlign.center,
                  name: 'كلمة السر مرة أخرى',
                  fontSize: 12.sp,
                  color: AppColors.black,
                  // fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 7.h,
              ),
              CardTemplateTransparent(
                  suffix: Icons.visibility_off_sharp,
                  prefix: 'password',
                  title: 'كلمة السر مرة أخرى',
                  controller: _newConfirm),
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
    if (_new.text.trim().isNotEmpty && _newConfirm.text.trim().isNotEmpty) {
      if (_new.text.trim() == _newConfirm.text.trim()) {
        return true;
      } else {
        getSheetError('كلمة المرور غير متطابقة');
        return false;
      }
    }
    getSheetError('يرجى ادخال البيانات');
    return false;
  }

  Future<bool> updatePassword() async {
    bool status = await FirebaseAuthController()
        .updatePassword(context: context, password: _newConfirm.text);
    return status;
  }

  Future<void> perform() async {
    if (checkData()) {
      await updatePassword();
    }
  }
}
