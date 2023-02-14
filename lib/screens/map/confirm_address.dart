import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:map_picker/map_picker.dart';
import 'package:otlob/screens/menu/Drawer.dart';
import 'package:otlob/screens/payment/payment.dart';
import 'package:otlob/services/preferences/app_preferences.dart';
import 'package:otlob/value/colors.dart';
import 'package:otlob/value/constant.dart';
import 'package:otlob/widget/app_style_text.dart';
import 'package:otlob/widget/app_text_field_no_border.dart';
import 'package:otlob/widget/card_template.dart';
import 'package:otlob/widget/custom_image.dart';
import 'package:otlob/widget/waiting.dart';
import 'package:pinput/pinput.dart';
import '../../server/controller/app_controller.dart';
import '../../widget/app_button.dart';
import '../Auth/sing_in.dart';

class ConfirmAddress extends StatefulWidget {
  const ConfirmAddress({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<ConfirmAddress> createState() => _ConfirmAddressState();
}

Random _rnd = Random();
const _chars = '1234567890';

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

class _ConfirmAddressState extends State<ConfirmAddress> {
  void onTapRecognizer() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SignIn()));
  }

  final defaultPinTheme = PinTheme(
    width: 51.w,
    height: 51.h,
    textStyle: const TextStyle(
        fontSize: 20, color: AppColors.greyF, fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      color: AppColors.greyF,
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(
        color: AppColors.greyF,
      ),
    ),
  );

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
    Timer(Duration(milliseconds: 1000), () {
      setState(() {});
    });
  }

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  getUser() async {
    // final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    // return allData;
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
          child: SingleChildScrollView(
            child: FutureBuilder(
              future: users
                  .where('uid',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.data != null) {
                  var data = snapshot.data!.docs[0].data() as Map;
                  var r = data['myOrders'] as Map;
                  List values = [];
                  List keys = [];
                  r.forEach(
                    (key, value) {
                      if (key == widget.id) {
                        values += [value];
                        keys += [key];
                      }
                    },
                  );
                  TextEditingController text = TextEditingController();
                  text.text = values.isEmpty
                      ? {'ادخل العنوان'}
                      : values[0]['postionName'];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextStyle(
                        textAlign: TextAlign.center,
                        name: '''مكان التوصيل''',
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                        // fontWeight: FontWeight.w400,
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomSvgImage(
                            imageName: 'maps',
                            height: 13.h,
                            width: 10.h,
                          ),
                          SizedBox(
                            width: 7.w,
                          ),
                          Expanded(
                            flex: 2,
                            child: AppFieldNoBorder(
                              hintFont: 12.sp,
                              enable: false,
                              hint: values.isEmpty
                                  ? ''
                                  : values[0]['postionName'],
                              controller: text,
                            ),
                          ),
                        ],
                      ),
                      CardTemplate(
                          isPassword: false,
                          inputType: TextInputType.text,
                          prefix: 'map',
                          title: text.text,
                          controller: text),
                      SizedBox(
                        height: 20.h,
                      ),
                      AppButton(
                          color: HexColor(AppController.hexColorPrimary.value),
                          title: 'تأكيد العنوان',
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .set({
                              'myOrders': {
                                keys[0]: {
                                  'clientID':
                                      FirebaseAuth.instance.currentUser!.uid,
                                  'clientName': values[0]['clientName'],
                                  'mealsName': values[0]['mealsName'],
                                  'orderStatus': 'waiting',
                                  'orderTime': DateTime.now(),
                                  'restaurantID': values[0]['restaurantID'],
                                  'restaurantName': values[0]['restaurantName'],
                                  'postionCoordinates':
                                      '${values[0]['postionCoordinates'][0]},${values[0]['postionCoordinates'][1]}',
                                  'postionName': text.text
                                }
                              }
                            }, SetOptions(merge: true)).then((value) {
                              getSheetSucsses('تم تحديث موقع الطلب');
                              FirebaseFirestore.instance
                                  .collection('restaurant')
                                  .where('uid',
                                      isEqualTo: values[0]['restaurantID'][0])
                                  .get()
                                  .then((value) {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .where('uid',
                                        isEqualTo: AppPreferences()
                                            .getUserDataAsMap()['uid'])
                                    .get()
                                    .then((v) {
                                  if (v.docs[0]['paymentType'] == 'visa' ||
                                      v.docs[0]['paymentType'] == 'master') {
                                    getSheetError(
                                        'عذرا وسيلة الدفع خاصتك غير فعالة يرجى تغير الوسيلة');
                                  } else {
                                    if (v.docs[0]['paymentType'] == 'paypal') {
                                      Get.to(Payment(
                                        clientId: value.docs[0]
                                            ['paymentSetting']['clientID'],
                                        secret: value.docs[0]['paymentSetting']
                                            ['secretKey'],
                                        resCount: value.docs[0]['countOrder'],
                                        resID: values[0]['restaurantID'][0],
                                        count: v.docs[0].data()['countOrder'],
                                        id: keys[0],
                                        meal: values[0]['mealsName'].toString(),
                                        price: (values[0]['totalOrder'])
                                            .toString(),
                                      ));
                                    } else {
                                      FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .set({
                                        'myOrders': {
                                          keys[0]: {
                                            'orderStatus': 'الدفع عند الاستلام',
                                            'orderTimeLastUpdate':
                                                DateTime.now()
                                          }
                                        },
                                        'countOrder':
                                            (v.docs[0].data()['countOrder'] + 1)
                                      }, SetOptions(merge: true));
                                      FirebaseFirestore.instance
                                          .collection('orders')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .set({
                                        widget.id: {
                                          'orderStatus': 'الدفع عند الاستلام',
                                          'orderTimeLastUpdate': DateTime.now()
                                        },
                                      }, SetOptions(merge: true));
                                      FirebaseFirestore.instance
                                          .collection('restaurant')
                                          .doc(values[0]['restaurantID'][0])
                                          .set({
                                        'countOrder':
                                            (value.docs[0]['countOrder'] + 1)
                                      }, SetOptions(merge: true));

                                      FirebaseFirestore.instance
                                          .collection('notifications')
                                          .doc('orders')
                                          .set({
                                        'NO-' + getRandomString(12): {
                                          'restaurantID': values[0]
                                              ['restaurantID'][0],
                                          'time': DateTime.now(),
                                          'mealsName':
                                              values[0]['mealsName'].toString(),
                                          'total': (values[0]['totalOrder'])
                                              .toString(),
                                          'paymentType': 'الدفع عند الاستلام',
                                          'clientID': AppPreferences()
                                              .getUserDataAsMap()['uid'],
                                          'orderID': keys[0],
                                          'orderStatus': 'new',
                                        }
                                      }, SetOptions(merge: true)).then((value) {
                                        getSheetSucsses(
                                            'تم استلام الطلب بنجاح, شكراً لثقتكم\n يوماً سعيد');
                                        Get.offAll(
                                            menu(currentItem: MenuItems.Home));
                                      });
                                    }
                                  }
                                });
                              });
                            });
                          }),
                    ],
                  );
                } else {
                  return Waiting();
                }
              },
            ),
          ),
        ),
      );
    });
  }
}
