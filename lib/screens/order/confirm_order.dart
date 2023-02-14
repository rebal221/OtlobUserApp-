import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otlob/screens/order/track_order.dart';
import 'package:otlob/value/colors.dart';
import 'package:otlob/widget/app_style_text.dart';

import '../../server/controller/app_controller.dart';
import '../../widget/app_button.dart';
import '../../widget/custom_image.dart';
import '../Auth/sing_in.dart';

class ConfirmOrder extends StatefulWidget {
  const ConfirmOrder({Key? key}) : super(key: key);

  @override
  State<ConfirmOrder> createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrder> {
  void onTapRecognizer() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SignIn()));
  }

  @override
  void initState() {
    // TODO: implement initState
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
            // mainAxisSize: MainAxisSize.min,

            // mainAxisAlignment: MainAxisAlignment.center,
            // padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
            children: [
              const Spacer(),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomSvgImage(
                    imageName: 'confirm',
                    width: 255.w,
                    height: 245.h,
                  ),
                  SizedBox(
                    height: 14.h,
                  ),
                  AppTextStyle(
                    textAlign: TextAlign.center,
                    name: '''طلبك في الطريق اليك''',
                    fontSize: 19.sp,
                    color: AppColors.black,
                    // fontWeight: FontWeight.w400,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  AppTextStyle(
                    textAlign: TextAlign.center,
                    name: '''تم ارسال الطلب بنجاح''',
                    fontSize: 14.sp,
                    color: AppColors.black,
                    // fontWeight: FontWeight.w400,
                  ),
                ],
              ),
              const Spacer(),
              AppButton(
                  color: HexColor(AppController.hexColorPrimary.value),
                  title: 'تتبع الطلبية',
                  onPressed: () {
                    // Get.to(const TrackOrder());
                  }),
            ],
          ),
        ),
      );
    });
  }
}
