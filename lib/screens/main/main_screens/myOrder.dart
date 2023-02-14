import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otlob/screens/main/main_screens/home.dart';
import 'package:otlob/screens/order/track_order.dart';
import 'package:otlob/screens/payment/payment.dart';
import 'package:otlob/services/preferences/app_preferences.dart';
import 'package:otlob/value/colors.dart';
import 'package:otlob/value/constant.dart';
import 'package:otlob/widget/app_style_text.dart';
import 'package:otlob/widget/waiting.dart';
import '../../../server/controller/app_controller.dart';
import '../../../widget/custom_image.dart';
import '../../menu/Drawer.dart';

class myOrderScreen extends StatefulWidget {
  const myOrderScreen({Key? key}) : super(key: key);

  @override
  State<myOrderScreen> createState() => _myOrderScreenState();
}

class _myOrderScreenState extends State<myOrderScreen> {
  void onTapRecognizer() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

  int t = 0;

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

  CollectionReference users = FirebaseFirestore.instance.collection('users');

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
                Get.offAll(menu(currentItem: MenuItems.Home));
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
          actions: const [
            MenuWidget(),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: users
              .where('uid',
                  isEqualTo: AppPreferences().getUserDataAsMap()['uid'])
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map r = snapshot.data!.docs[0].data() as Map;
              bool a = r['myOrders'].toString() == 'null' ? false : true;
              var t = [r['myOrders']];
              Map data = t[0].isEmpty ? {} : r['myOrders'] as Map;
              var keys = [];
              var values = [];
              // Map data = {};
              int total = 0;
              data.forEach((key, value) {
                keys += [key];
                values += [value];
                total += int.parse((value['totalOrder']).toString());
              });
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
                child: Column(
                  mainAxisAlignment:
                      !a ? MainAxisAlignment.center : MainAxisAlignment.start,
                  children: [
                    t[0].isNotEmpty
                        ? Container(
                            height: MediaQuery.of(context).size.height - 150,
                            child: ListView.separated(
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  Timestamp t = values[index]['orderTime'];
                                  var meals = [];
                                  int status = 0;
                                  DateTime d = t.toDate();
                                  List r = values[index]['mealsName'];
                                  for (var i = 0; i < r.length; i++) {
                                    int x = r[i].toString().indexOf(':');
                                    meals += [
                                      r[i]
                                          .toString()
                                          .substring(0, x)
                                          .replaceAll(
                                              RegExp(r"\p{P}", unicode: true),
                                              "")
                                    ];
                                  }
                                  status = values[index]['orderStatus'] ==
                                          'waiting'
                                      ? 1
                                      : (values[index]['orderStatus'] == 'paid'
                                          ? 2
                                          : (values[index]['orderStatus'] ==
                                                  'الدفع عند الاستلام'
                                              ? 3
                                              : 0));
                                  return Row(
                                    children: [
                                      SizedBox(
                                        width: 7.w,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AppTextStyle(
                                            name: keys[index],
                                            fontSize: 12.sp,
                                            color: AppColors.black,
                                            isMarai: false,
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Icon(
                                                Icons.person,
                                                size: 15,
                                              ),
                                              SizedBox(
                                                width: 3.w,
                                              ),
                                              AppTextStyle(
                                                textAlign: TextAlign.center,
                                                name: values[index]
                                                    ['clientName'],
                                                isMarai: false,

                                                fontSize: 8.sp,
                                                color: AppColors.black,
                                                // fontWeight: FontWeight.w400,
                                              ),
                                              SizedBox(
                                                width: 3.w,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 12.h,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Icon(
                                                Icons.home_filled,
                                                size: 15,
                                              ),
                                              SizedBox(
                                                width: 3.w,
                                              ),
                                              AppTextStyle(
                                                textAlign: TextAlign.center,
                                                name: values[index]
                                                    ['restaurantName'],
                                                isMarai: false,

                                                fontSize: 8.sp,
                                                color: AppColors.black,
                                                // fontWeight: FontWeight.w400,
                                              ),
                                              SizedBox(
                                                width: 3.w,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 12.h,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Icon(
                                                Icons.food_bank_outlined,
                                                size: 15,
                                              ),
                                              SizedBox(
                                                width: 3.w,
                                              ),
                                              AppTextStyle(
                                                textAlign: TextAlign.center,
                                                name: meals.toString(),
                                                isMarai: false,

                                                fontSize: 8.sp,
                                                color: AppColors.black,
                                                // fontWeight: FontWeight.w400,
                                              ),
                                              SizedBox(
                                                width: 3.w,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 12.h,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Icon(
                                                Icons.location_on_outlined,
                                                size: 15,
                                              ),
                                              SizedBox(
                                                width: 3.w,
                                              ),
                                              AppTextStyle(
                                                textAlign: TextAlign.center,
                                                name: values[index]
                                                    ['postionName'],
                                                isMarai: false,

                                                fontSize: 8.sp,
                                                color: AppColors.black,
                                                // fontWeight: FontWeight.w400,
                                              ),
                                              SizedBox(
                                                width: 3.w,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 12.h,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Icon(
                                                Icons.date_range_outlined,
                                                size: 15,
                                              ),
                                              SizedBox(
                                                width: 3.w,
                                              ),
                                              AppTextStyle(
                                                textAlign: TextAlign.center,
                                                name: d.toString(),
                                                isMarai: false,

                                                fontSize: 8.sp,
                                                color: AppColors.black,
                                                // fontWeight: FontWeight.w400,
                                              ),
                                              SizedBox(
                                                width: 3.w,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 12.h,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.access_time_filled,
                                                    size: 12.r,
                                                    color: AppColors.black,
                                                  ),
                                                  SizedBox(
                                                    width: 3.w,
                                                  ),
                                                  AppTextStyle(
                                                    textAlign: TextAlign.center,
                                                    name: 'يصلك خلال 30 دقيقة',
                                                    fontSize: 6.sp,
                                                    isMarai: false,

                                                    color: AppColors.black,
                                                    // fontWeight: FontWeight.w400,
                                                  ),
                                                  SizedBox(
                                                    width: 3.w,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 3.w,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 12.h,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Icon(
                                                Icons.subtitles,
                                                size: 15,
                                              ),
                                              SizedBox(
                                                width: 3.w,
                                              ),
                                              AppTextStyle(
                                                textAlign: TextAlign.center,
                                                name:
                                                    'حالة الطلب : ${status == 1 ? 'انتظار الدفع' : (status == 2 ? 'تم الدفع' : (status == 3 ? 'الدفع عند الاستلام' : 'تم'))}',
                                                isMarai: false,

                                                fontSize: 8.sp,
                                                color: AppColors.black,
                                                // fontWeight: FontWeight.w400,
                                              ),
                                              SizedBox(
                                                width: 3.w,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 12.h,
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: 60.h,
                                            width: 60.w,
                                            child: Card(
                                              color: HexColor(AppController
                                                  .hexColorPrimary.value),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  AppTextStyle(
                                                    textAlign: TextAlign.center,
                                                    name: values[index]
                                                            ['totalOrder']
                                                        .toString(),
                                                    fontSize: 15.sp,
                                                    isMarai: false,

                                                    height: 1,

                                                    color: AppColors.white,
                                                    // fontWeight: FontWeight.w400,
                                                  ),
                                                  AppTextStyle(
                                                    textAlign: TextAlign.center,
                                                    name:
                                                        '${AppController.appData.value.currency}',
                                                    height: 1,
                                                    isMarai: false,

                                                    fontSize: 15.sp,
                                                    color: AppColors.white,
                                                    // fontWeight: FontWeight.w400,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 7.w,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              status == 1
                                                  ? FirebaseFirestore.instance
                                                      .collection('restaurant')
                                                      .where('uid',
                                                          isEqualTo: values[
                                                                  index][
                                                              'restaurantID'][0])
                                                      .get()
                                                      .then((value) {
                                                      value.docs[0].data()[
                                                                  'paymentSetting'] ==
                                                              null
                                                          ? getSheetError(
                                                              'عذراً المطعم لا يستفبل\n مدفوعات في الوقت الحالي')
                                                          : Get.to(Payment(
                                                              clientId: value
                                                                          .docs[0]
                                                                          .data()[
                                                                      'paymentSetting']
                                                                  ['clientID'],
                                                              secret: value.docs[
                                                                              0]
                                                                          .data()[
                                                                      'paymentSetting']
                                                                  ['secretKey'],
                                                              resCount: value
                                                                      .docs[0]
                                                                      .data()[
                                                                  'countOrder'],
                                                              resID: values[
                                                                      index][
                                                                  'restaurantID'][0],
                                                              count: snapshot
                                                                      .data!
                                                                      .docs[0][
                                                                  'countOrder'],
                                                              id: keys[index],
                                                              meal: meals
                                                                  .toString(),
                                                              price: (values[
                                                                          index]
                                                                      [
                                                                      'totalOrder'])
                                                                  .toString(),
                                                            ));
                                                    })
                                                  : (status == 2
                                                      ? Get.to(TrackOrder(
                                                          orderID: keys[index],
                                                        ))
                                                      : Get.to(TrackOrder(
                                                          orderID: keys[index],
                                                        )));
                                            },
                                            child: SizedBox(
                                              width: 60.w,
                                              child: Card(
                                                color: status == 1
                                                    ? Color.fromARGB(
                                                        255, 255, 7, 7)
                                                    : (status == 2
                                                        ? Colors.green
                                                        : (status == 3
                                                            ? Colors
                                                                .green.shade200
                                                            : HexColor(AppController
                                                                .hexColorPrimary
                                                                .value))),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: AppTextStyle(
                                                        textAlign:
                                                            TextAlign.center,
                                                        name: status == 1
                                                            ? 'دفع الطلب'
                                                            : (status == 2
                                                                ? 'تتبع الطلب'
                                                                : (status == 3
                                                                    ? ' دفع عند الاستلام'
                                                                    : '')),
                                                        fontSize: 9.sp,
                                                        isMarai: false,

                                                        height: 1,

                                                        color: AppColors.white,
                                                        // fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 7.w,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      scrollable: true,
                                                      title: const AppTextStyle(
                                                        name:
                                                            'هل انت متأكد من حذف الطلب ؟',
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 15,
                                                      ),
                                                      content: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'users')
                                                                      .doc(FirebaseAuth
                                                                          .instance
                                                                          .currentUser!
                                                                          .uid)
                                                                      .set({
                                                                    'myOrders':
                                                                        {
                                                                      keys[index]:
                                                                          FieldValue
                                                                              .delete()
                                                                    }
                                                                  }, SetOptions(merge: true)).whenComplete(
                                                                          () {
                                                                    getSheetSucsses(
                                                                        'تم حذف الطلب');
                                                                  });
                                                                },
                                                                child: SizedBox(
                                                                  width: 80.w,
                                                                  child: Card(
                                                                    color: HexColor(AppController
                                                                        .hexColorPrimary
                                                                        .value),
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.r),
                                                                    ),
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              AppTextStyle(
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            name:
                                                                                'حذف',
                                                                            fontSize:
                                                                                10.sp,
                                                                            isMarai:
                                                                                false,

                                                                            height:
                                                                                1,

                                                                            color:
                                                                                AppColors.white,
                                                                            // fontWeight: FontWeight.w400,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              InkWell(
                                                                onTap: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                                child: SizedBox(
                                                                  width: 80.w,
                                                                  child: Card(
                                                                    color: HexColor(AppController
                                                                        .hexColorSecond
                                                                        .value),
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.r),
                                                                    ),
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              AppTextStyle(
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            name:
                                                                                'ألغاء',
                                                                            fontSize:
                                                                                10.sp,
                                                                            isMarai:
                                                                                false,

                                                                            height:
                                                                                1,

                                                                            color:
                                                                                AppColors.white,
                                                                            // fontWeight: FontWeight.w400,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          )),
                                                    );
                                                  });
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                CustomSvgImage(
                                                  imageName: 'delete',
                                                  // color: AppColors.grey,
                                                  height: 18.h,
                                                  width: 14.w,
                                                ),
                                                SizedBox(
                                                  width: 3.w,
                                                ),
                                                AppTextStyle(
                                                  textAlign: TextAlign.center,
                                                  name: 'حذف الطلب',
                                                  fontSize: 8.sp,
                                                  isMarai: false,

                                                  color: AppColors.greyC,
                                                  // fontWeight: FontWeight.w400,
                                                ),
                                                SizedBox(
                                                  width: 3.w,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return Divider(
                                    height: 28.h,
                                  );
                                },
                                itemCount: keys.length),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppTextStyle(
                                name: 'لا يوجد طلبات الى الأن',
                                color: Colors.black45,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                  ],
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Waiting();
            } else {
              return Waiting();
            }
          },
        ),
      );
    });
  }
}
