import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:location/location.dart';
import 'package:otlob/screens/map/confirm_address.dart';
import 'package:otlob/screens/product/product_page.dart';
import 'package:otlob/server/model/user_model.dart';
import 'package:otlob/services/preferences/app_preferences.dart';
import 'package:otlob/value/colors.dart';
import 'package:otlob/value/constant.dart';
import 'package:otlob/widget/app_style_text.dart';
import 'package:otlob/widget/waiting.dart';
import '../../../server/controller/app_controller.dart';
import '../../../widget/app_button.dart';
import '../../../widget/component.dart';
import '../../../widget/custom_image.dart';
import '../../Auth/sing_in.dart';
import '../../menu/Drawer.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

Random _rnd = Random();
const _chars = '1234567890';

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

class _OrderScreenState extends State<OrderScreen> {
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

  LocationData? _userLocation;
  CollectionReference myOrders = FirebaseFirestore.instance.collection('cart');

  getMYOrders() async {
    var allData =
        await myOrders.doc(AppPreferences().getUserDataAsMap()['uid']).get();
    return allData.data() == null ? {} : allData.data();
  }

  String note = '';
  int number = 0;
  List mealNum = [];
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
          // leading: TextButton.icon(
          //     onPressed: () {
          //       Get.back();
          //     },
          //     icon: Icon(
          //       Icons.keyboard_arrow_right,
          //       color: Colors.white,
          //       size: 25.r,
          //     ),
          //     label: AppTextStyle(
          //       name: 'رجوع',
          //       fontSize: 10.sp,
          //     )),

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
          actions: const [
            MenuWidget(),
          ],
        ),
        body: FutureBuilder(
          future: getMYOrders(),
          builder: (context, snapshot) {
            // print();
            int total = 0;
            if (snapshot.connectionState == ConnectionState.done) {
              Map data = snapshot.data == null ? {} : snapshot.data as Map;
              List iDs = [];
              List det = [];
              List restIDs = [];
              List exte = [];
              List meals = [];
              List x = [];
              data.forEach(
                (k, v) {
                  String s = v.toString();

                  s == '{}' ? [] : iDs += [k];
                  s == '{}' ? [] : det += [v];
                  if (v['extensions'].toString() != '[]') {
                    exte += [true];
                  } else {
                    exte += [false];
                  }
                  s == '{}'
                      ? []
                      : total += int.parse(v['totalOrder'].toString());
                  s == '{}'
                      ? []
                      : meals += [
                          {v['mealName']: v['extensions']}
                        ];
                  s == '{}'
                      ? []
                      : restIDs += restIDs.contains(v['restaurantID'])
                          ? []
                          : [v['restaurantID']];
                },
              );

              return meals.isNotEmpty
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 20.h, horizontal: 16.w),
                      child: Column(
                        // padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height - 400,
                            child: ListView.separated(
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  note = det[index]['userNote'];
                                  number = det[index]['count'];
                                  mealNum += [
                                    '${det[index]['mealName']} : عدد ${det[index]['count']}'
                                  ];
                                  return Row(
                                    children: [
                                      SizedBox(
                                        height: 72.h,
                                        width: 73.w,
                                        child: Card(
                                          clipBehavior: Clip.antiAlias,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: det[index]['image'],
                                            // height: 72.h,
                                            // width: 72.w,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            placeholder: (context, url) =>
                                                shimmerCarDes(context),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 7.w,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AppTextStyle(
                                            name: det[index]['mealName'],
                                            fontSize: 12.sp,
                                            color: AppColors.black,
                                            isMarai: false,
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          exte[index]
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Icon(
                                                      Icons.extension_outlined,
                                                      size: 15,
                                                    ),
                                                    SizedBox(
                                                      width: 3.w,
                                                    ),
                                                    AppTextStyle(
                                                      textAlign:
                                                          TextAlign.center,
                                                      name: 'الإضافات :',
                                                      isMarai: false,

                                                      fontSize: 7.sp,
                                                      color: AppColors.black,
                                                      // fontWeight: FontWeight.w400,
                                                    ),
                                                    SizedBox(
                                                      width: 3.w,
                                                    ),
                                                  ],
                                                )
                                              : Row(),
                                          SizedBox(
                                            height: exte[index] ? 12.h : 0,
                                          ),
                                          exte[index] &&
                                                  det[index]['extensions'][0] !=
                                                      ''
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    SizedBox(
                                                      width: 25.w,
                                                    ),
                                                    const Text(
                                                      ' - ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontSize: 13),
                                                    ),
                                                    SizedBox(
                                                      width: 3.w,
                                                    ),
                                                    AppTextStyle(
                                                      textAlign:
                                                          TextAlign.center,
                                                      name: det[index]
                                                                  ['extensions']
                                                              [0] +
                                                          ' ${AppController.appData.value.currency}',
                                                      isMarai: false,

                                                      fontSize: 7.sp,
                                                      color: AppColors.black,
                                                      // fontWeight: FontWeight.w400,
                                                    ),
                                                    SizedBox(
                                                      width: 3.w,
                                                    ),
                                                  ],
                                                )
                                              : Row(),
                                          SizedBox(
                                            height: exte[index] &&
                                                    det[index]['extensions']
                                                            [0] !=
                                                        ''
                                                ? 12.h
                                                : 0,
                                          ),
                                          exte[index] &&
                                                  det[index]['extensions'][1] !=
                                                      ''
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    SizedBox(
                                                      width: 25.w,
                                                    ),
                                                    const Text(
                                                      ' - ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontSize: 13),
                                                    ),
                                                    SizedBox(
                                                      width: 3.w,
                                                    ),
                                                    AppTextStyle(
                                                      textAlign:
                                                          TextAlign.center,
                                                      name: det[index]
                                                                  ['extensions']
                                                              [1] +
                                                          ' ${AppController.appData.value.currency}',
                                                      isMarai: false,

                                                      fontSize: 7.sp,
                                                      color: AppColors.black,
                                                      // fontWeight: FontWeight.w400,
                                                    ),
                                                    SizedBox(
                                                      width: 3.w,
                                                    ),
                                                  ],
                                                )
                                              : Row(),
                                          SizedBox(
                                            height: exte[index] &&
                                                    det[index]['extensions']
                                                            [1] !=
                                                        ''
                                                ? 12.h
                                                : 0,
                                          ),
                                          exte[index] &&
                                                  det[index]['extensions'][2] !=
                                                      ''
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    SizedBox(
                                                      width: 25.w,
                                                    ),
                                                    const Text(
                                                      ' - ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontSize: 13),
                                                    ),
                                                    SizedBox(
                                                      width: 3.w,
                                                    ),
                                                    AppTextStyle(
                                                      textAlign:
                                                          TextAlign.center,
                                                      name: det[index]
                                                                  ['extensions']
                                                              [2] +
                                                          ' ${AppController.appData.value.currency}',
                                                      isMarai: false,

                                                      fontSize: 7.sp,
                                                      color: AppColors.black,
                                                      // fontWeight: FontWeight.w400,
                                                    ),
                                                    SizedBox(
                                                      width: 3.w,
                                                    ),
                                                  ],
                                                )
                                              : Row(),
                                          SizedBox(
                                            height: exte[index] &&
                                                    det[index]['extensions']
                                                            [1] !=
                                                        ''
                                                ? 12.h
                                                : 0,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Icon(Icons.home_filled, size: 15),
                                              SizedBox(
                                                width: 3.w,
                                              ),
                                              AppTextStyle(
                                                textAlign: TextAlign.center,
                                                name: det[index]
                                                    ['restaurantName'],
                                                isMarai: false,

                                                fontSize: 7.sp,
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
                                              CustomSvgImage(
                                                imageName: 'maps',
                                                // color: AppColors.grey,
                                                height: 12.h,
                                                width: 7.w,
                                              ),
                                              SizedBox(
                                                width: 3.w,
                                              ),
                                              AppTextStyle(
                                                textAlign: TextAlign.center,
                                                name: det[index]['postionName'],
                                                isMarai: false,

                                                fontSize: 7.sp,
                                                color: AppColors.black,
                                                // fontWeight: FontWeight.w400,
                                              ),
                                              SizedBox(
                                                width: 3.w,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: note != '' ? 12.h : 0.h,
                                          ),
                                          note != ''
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.note,
                                                          size: 12.r,
                                                          color:
                                                              AppColors.black,
                                                        ),
                                                        SizedBox(
                                                          width: 3.w,
                                                        ),
                                                        AppTextStyle(
                                                          textAlign:
                                                              TextAlign.center,
                                                          name: note,
                                                          fontSize: 6.sp,
                                                          isMarai: false,

                                                          color:
                                                              AppColors.black,
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
                                                )
                                              : Text(''),
                                          SizedBox(
                                            height: note != '' ? 12.h : 0.h,
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
                                                    Icons.food_bank,
                                                    size: 12.r,
                                                    color: AppColors.black,
                                                  ),
                                                  SizedBox(
                                                    width: 3.w,
                                                  ),
                                                  AppTextStyle(
                                                    textAlign: TextAlign.center,
                                                    name: number.toString(),
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
                                          )
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
                                                    name: det[index]
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
                                          GestureDetector(
                                            onTap: () {
                                              FirebaseFirestore.instance
                                                  .collection('cart')
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser!.uid)
                                                  .update({
                                                '${iDs[index]}':
                                                    FieldValue.delete()
                                              }).whenComplete(() {
                                                getSheetSucsses(
                                                    'تم حذف الوجبة');
                                                setState(() {});
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
                                                  name: 'حذف الوجبة',
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
                                itemCount: iDs.length),
                          ),
                          const Spacer(),
                          meals.isNotEmpty
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        AppTextStyle(
                                          textAlign: TextAlign.center,
                                          name: 'الإجمالي ',
                                          fontSize: 14.sp,
                                          isMarai: false,
                                          color: AppColors.black,
                                          // fontWeight: FontWeight.w400,
                                        ),
                                        SizedBox(
                                          height: 7.w,
                                        ),
                                        AppTextStyle(
                                          textAlign: TextAlign.center,
                                          name:
                                              '${total} ${AppController.appData.value.currency}',
                                          fontSize: 12.sp,
                                          isMarai: false,

                                          color: AppColors.black,
                                          // fontWeight: FontWeight.w400,
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : Text(''),
                          SizedBox(
                            height: 18.h,
                          ),
                          meals.isNotEmpty
                              ? AppButton(
                                  color: HexColor(
                                      AppController.hexColorPrimary.value),
                                  title: 'تأكيد الطلب ',
                                  onPressed: () async {
                                    // SVProgressHUD.show();
                                    // // Get.to(const ConfirmAddress());
                                    Location location = Location();
                                    var _order = {
                                      'clientName': det[0]['clientName'],
                                      'clientID': FirebaseAuth
                                          .instance.currentUser!.uid,
                                      'clientNote': note,
                                      'clientCount': mealNum,
                                      'clientPhone': det[0]['clientPhone'],
                                      'restaurantName': det[0]
                                          ['restaurantName'],
                                      'restaurantID': restIDs,
                                      'postionName': det[0]['postionName'],
                                      'postionCoordinates': [
                                        AppPreferences().getData(key: 'lat'),
                                        AppPreferences().getData(key: 'long')
                                      ],
                                      'mealsName': meals,
                                      'totalOrder': total,
                                      'orderTime': DateTime.now(),
                                      'orderTimeLastUpdate': DateTime.now(),
                                      'orderStatus': 'waiting'
                                    };
                                    String id = 'AAFC' + getRandomString(20);
                                    FirebaseFirestore.instance
                                        .collection('orders')
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .set({
                                      id: _order
                                    }, SetOptions(merge: true)).then((value) {
                                      FirebaseFirestore.instance
                                          .collection('cart')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .delete();

                                      FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .set({
                                        'myOrders': {id: _order}
                                      }, SetOptions(merge: true)).then(
                                              (value) => Get.to(
                                                  ConfirmAddress(id: id)));
                                      SVProgressHUD.showSuccess();
                                    });
                                    Get.to(ConfirmAddress(id: id));
                                  })
                              : Text(''),
                        ],
                      ),
                    )
                  : Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      child: AppTextStyle(
                        name: 'السلة فارغة',
                        color: Colors.black87,
                        fontSize: 15.sp,
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
