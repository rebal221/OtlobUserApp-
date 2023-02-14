import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otlob/screens/main/main_screens/profile.dart';
import 'package:otlob/screens/order/track_order.dart';
import 'package:otlob/services/preferences/app_preferences.dart';
import 'package:otlob/value/colors.dart';
import 'package:otlob/widget/app_style_text.dart';
import 'package:otlob/widget/card_template_radio.dart';

import '../../server/controller/app_controller.dart';
import '../../widget/app_button.dart';
import '../../widget/custom_image.dart';
import '../Auth/sing_in.dart';

class SelectPayment extends StatefulWidget {
  final String type;
  const SelectPayment({Key? key, required this.type}) : super(key: key);

  @override
  State<SelectPayment> createState() => _SelectPaymentState();
}

class _SelectPaymentState extends State<SelectPayment> {
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

  bool visa = false;
  bool master = false;
  bool paypal = false;
  bool cash = false;
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //     statusBarColor: HexColor(AppController.hexColorPrimary.value)
    // ));
    String t = widget.type;
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
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where('uid',
                    isEqualTo: AppPreferences().getUserDataAsMap()['uid'])
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                t = snapshot.data!.docs[0]['paymentType'];
                visa = t == 'visa' ? true : false;
                master = t == 'master' ? true : false;
                paypal = t == 'paypal' ? true : false;
                cash = t == 'الدفع عند الاستلام' ? true : false;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  // padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
                  children: [
                    AppTextStyle(
                      name: 'وسيلة الدفع',
                      color: AppColors.black,
                      fontSize: 10.sp,
                      isMarai: false,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(
                      height: 14.h,
                    ),
                    SizedBox(
                      height: 53.h,
                      child: Card(
                        color: visa
                            ? HexColor(AppController.hexColorPrimary.value)
                                .withOpacity(.2)
                            : AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: visa
                                  ? HexColor(
                                      AppController.hexColorPrimary.value)
                                  : AppColors.grey,
                            ),
                            borderRadius: BorderRadius.circular(8.r)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Row(
                            children: [
                              Expanded(
                                  child: RadioListTile(
                                activeColor: visa
                                    ? HexColor(
                                        AppController.hexColorPrimary.value)
                                    : AppColors.grey,
                                title: CustomSvgImage(
                                  imageName: 'visaradio',
                                  height: 20.w,
                                  width: 26.w,
                                ),
                                value: visa ? 1 : 0,
                                groupValue: 1,
                                onChanged: (value) {
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(AppPreferences()
                                          .getUserDataAsMap()['uid'])
                                      .set({
                                    'paymentType': 'visa'
                                  }, SetOptions(merge: true)).then((value) {
                                    AppPreferences().setData(
                                        key: 'paymentType', value: 'visa');
                                    print('visa');
                                  });
                                },
                              )),
                              CustomSvgImage(
                                imageName: 'visa',
                                height: 10.h,
                                width: 26.w,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 14.h,
                    ),
                    Card(
                      color: master
                          ? HexColor(AppController.hexColorPrimary.value)
                              .withOpacity(.2)
                          : AppColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: master
                                ? HexColor(AppController.hexColorPrimary.value)
                                : AppColors.grey,
                          ),
                          borderRadius: BorderRadius.circular(8.r)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Row(
                          children: [
                            Expanded(
                                child: RadioListTile(
                              activeColor: master
                                  ? HexColor(
                                      AppController.hexColorPrimary.value)
                                  : AppColors.grey,
                              title: CustomSvgImage(
                                imageName: 'master4',
                                height: 20.w,
                                width: 26.w,
                              ),
                              value: master ? 1 : 0,
                              groupValue: 1,
                              onChanged: (value) {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(AppPreferences()
                                        .getUserDataAsMap()['uid'])
                                    .set({'paymentType': 'master'},
                                        SetOptions(merge: true)).then((value) {
                                  AppPreferences().setData(
                                      key: 'paymentType', value: 'master');
                                  print('master');
                                });
                              },
                            )),
                            CustomSvgImage(
                              imageName: 'master',
                              height: 28.h,
                              width: 26.w,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 14.h,
                    ),
                    Card(
                      color: paypal
                          ? HexColor(AppController.hexColorPrimary.value)
                              .withOpacity(.2)
                          : AppColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: paypal
                                ? HexColor(AppController.hexColorPrimary.value)
                                : AppColors.grey,
                          ),
                          borderRadius: BorderRadius.circular(8.r)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Row(
                          children: [
                            Expanded(
                                child: RadioListTile(
                              activeColor: paypal
                                  ? HexColor(
                                      AppController.hexColorPrimary.value)
                                  : AppColors.grey,
                              title: AppTextStyle(
                                textAlign: TextAlign.center,
                                name: 'PayPal Checkout',
                                isMarai: false,
                                fontWeight: FontWeight.w600,
                                color: AppColors.black,
                                fontSize: 10.sp,
                              ),
                              value: paypal ? 1 : 0,
                              groupValue: 1,
                              onChanged: (value) {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(AppPreferences()
                                        .getUserDataAsMap()['uid'])
                                    .set({'paymentType': 'paypal'},
                                        SetOptions(merge: true)).then((value) {
                                  AppPreferences().setData(
                                      key: 'paymentType', value: 'paypal');
                                  print('paypal');
                                });
                              },
                            )),
                            CustomSvgImage(
                              imageName: 'paypal',
                              height: 28.h,
                              width: 26.w,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 14.h,
                    ),
                    Card(
                      color: cash
                          ? HexColor(AppController.hexColorPrimary.value)
                              .withOpacity(.2)
                          : AppColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: cash
                                ? HexColor(AppController.hexColorPrimary.value)
                                : AppColors.grey,
                          ),
                          borderRadius: BorderRadius.circular(8.r)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Row(
                          children: [
                            Expanded(
                                child: RadioListTile(
                              activeColor: cash
                                  ? HexColor(
                                      AppController.hexColorPrimary.value)
                                  : AppColors.grey,
                              title: AppTextStyle(
                                textAlign: TextAlign.center,
                                name: 'الدفع عند الاستلام',
                                isMarai: false,
                                fontWeight: FontWeight.w600,
                                color: AppColors.black,
                                fontSize: 10.sp,
                              ),
                              value: cash ? 1 : 0,
                              groupValue: 1,
                              onChanged: (value) {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(AppPreferences()
                                        .getUserDataAsMap()['uid'])
                                    .set({'paymentType': 'الدفع عند الاستلام'},
                                        SetOptions(merge: true)).then((value) {
                                  AppPreferences().setData(
                                      key: 'paymentType',
                                      value: 'الدفع عند الاستلام');
                                  print('الدفع عند الاستلام');
                                });
                              },
                            )),
                            CustomSvgImage(
                              imageName: 'cash',
                              height: 28.h,
                              width: 26.w,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 18.h,
                    ),
                    AppButton(
                        color: HexColor(AppController.hexColorPrimary.value),
                        title: 'تأكيد',
                        onPressed: () {
                          // Get.to(const ConfirmOrder());
                          Get.to(ProfileScreen());
                          // Get.to(ResetPasswordThree());
                        }),
                  ],
                );
              } else {
                return Text("No data");
              }
            },
          ),
        ),
      );
    });
  }
}
