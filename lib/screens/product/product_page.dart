import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otlob/screens/allResturant/resturant_page/resutrant_page_p.dart';
import 'package:otlob/screens/main/main_screens/offer_screen.dart';
import 'package:otlob/screens/main/main_screens/order.dart';
import 'package:otlob/screens/main/main_screens/profile.dart';
import 'package:otlob/screens/menu/Drawer.dart';
import 'package:otlob/server/controller/app_controller.dart';
import 'package:otlob/server/model/user_model.dart';
import 'package:otlob/services/preferences/app_preferences.dart';
import 'package:otlob/value/colors.dart';
import 'package:otlob/value/constant.dart';
import 'package:otlob/widget/app_style_text.dart';
import 'package:otlob/widget/app_text_field.dart';
import 'package:otlob/widget/card_row.dart';

import 'package:geocoding/geocoding.dart' as gecoding;
import 'package:otlob/widget/card_template_check.dart';
import 'package:otlob/widget/component.dart';
import 'package:otlob/widget/custom_image.dart';
import 'package:otlob/widget/images_slider.dart';
import 'package:otlob/widget/row_icon.dart';
import 'package:otlob/widget/waiting.dart';

import '../../widget/app_button.dart';
import '../../widget/continer_list_two.dart';
import '../../widget/row_svg.dart';
import '../Auth/sing_in.dart';
import '../main/main_screens/home.dart';

class ProductPage extends StatefulWidget {
  ProductPage({Key? key, required this.id}) : super(key: key);

  final String id;
  @override
  State<ProductPage> createState() => _ProductPageState();
}

Random _rnd = Random();
const _chars = '1234567890';

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

class _ProductPageState extends State<ProductPage> {
  void onTapRecognizer() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SignIn()));
  }

  int pageIndex = 5;

  final pages = [
    const Home(),
    const OfferScreen(),
    const OrderScreen(),
    const ProfileScreen(),
  ];

  var order;
  double randomNumber = (Random().nextDouble() * 5.0);

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

  CollectionReference meals = FirebaseFirestore.instance.collection('meals');

  getmeals() async {
    // Get docs from collection reference

    var querySnapshot = await meals.where('uid', isEqualTo: widget.id).get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    return allData;
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //     statusBarColor: HexColor(AppController.hexColorPrimary.value)
    // ));
    return Obx(() {
      return Scaffold(
        backgroundColor: AppColors.white,
        bottomNavigationBar: buildMyNavBar(context),
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
        body: FutureBuilder(
          future: getmeals(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var data = snapshot.data == null ? [] : snapshot.data as List;
              List images = data.isEmpty ? [] : data[0]['mealImages'] as List;
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
                    children: [
                      Container(
                        height: 300.h,
                        decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(8.r)),
                        child: Column(
                          children: [
                            Container(
                              height: 221.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r)),
                              child: Stack(
                                children: [
                                  SliderImages(imageUrls: images),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5.w, vertical: 9.h),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        StreamBuilder<
                                                DocumentSnapshot<
                                                    Map<String, dynamic>>>(
                                            stream: FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(AppPreferences()
                                                    .getUserDataAsMap()['uid'])
                                                .snapshots(),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<
                                                        DocumentSnapshot<
                                                            Map<String,
                                                                dynamic>>>
                                                    snapshot) {
                                              if (snapshot.hasError) {
                                                return const Text('');
                                              }

                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Text("");
                                              }
                                              Map<String, dynamic> data =
                                                  snapshot.data!.data()
                                                      as Map<String, dynamic>;
                                              bool fav = false;
                                              data['favorites'] != null
                                                  ? ((data['favorites']
                                                                  ['meals'])
                                                              .toString() !=
                                                          '[]'
                                                      ? (fav = data['favorites']
                                                                      ['meals']
                                                                  [widget.id] ==
                                                              true
                                                          ? true
                                                          : false)
                                                      : fav = false)
                                                  : fav = false;
                                              return InkWell(
                                                onTap: () async {
                                                  fav
                                                      ? FirebaseFirestore
                                                          .instance
                                                          .collection('users')
                                                          .doc(AppPreferences()
                                                                  .getUserDataAsMap()[
                                                              'uid'])
                                                          .set(
                                                              {
                                                              'favorites': {
                                                                'meals': {
                                                                  widget.id:
                                                                      false
                                                                }
                                                              }
                                                            },
                                                              SetOptions(
                                                                  merge:
                                                                      true)).then(
                                                              (value) {
                                                          getSheetError(
                                                              'تم أزالة الوجبة من المفضلة');
                                                        })
                                                      : FirebaseFirestore
                                                          .instance
                                                          .collection('users')
                                                          .doc(AppPreferences()
                                                                  .getUserDataAsMap()[
                                                              'uid'])
                                                          .set(
                                                              {
                                                              'favorites': {
                                                                'meals': {
                                                                  widget.id:
                                                                      true
                                                                }
                                                              }
                                                            },
                                                              SetOptions(
                                                                  merge:
                                                                      true)).then(
                                                              (value) {
                                                          getSheetSucsses(
                                                              'تم اضافة الوجبة الى المفضلة');
                                                        });
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  // padding: EdgeInsets.all(5.r),
                                                  height: 25.h,
                                                  width: 70.w,
                                                  decoration: BoxDecoration(
                                                      color: fav
                                                          ? HexColor(AppController
                                                              .hexColorPrimary
                                                              .value)
                                                          : AppColors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      AppTextStyle(
                                                        name: fav
                                                            ? 'أزالة'
                                                            : 'إضافة',
                                                        color: fav
                                                            ? AppColors.white
                                                            : AppColors.black
                                                                .withOpacity(
                                                                    0.4),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 10.sp,
                                                      ),
                                                      Icon(
                                                        fav
                                                            ? Icons
                                                                .favorite_outlined
                                                            : Icons
                                                                .favorite_border,
                                                        color: fav
                                                            ? AppColors.white
                                                            : AppColors.black
                                                                .withOpacity(
                                                                    0.4),
                                                        size: 15.r,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            })
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 11.h,
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 7.w,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppTextStyle(
                                          name: data[0]['mealName'],
                                          fontSize: 12.sp,
                                          color: AppColors.black,
                                          fontWeight: FontWeight.w500,
                                          isMarai: false,
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Row(
                                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                                          children: [
                                            RowIcon(
                                                title: '30 دقيقة تقريباً',
                                                iconData: Icons
                                                    .access_time_filled_rounded,
                                                color: AppColors.black),
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                            RowSvg(
                                              title: data[0]['restaurantName'],
                                              image: 'maps',
                                            ),
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                            RowSvg(
                                              title:
                                                  '${(randomNumber < 3.5 ? 3.7 : randomNumber.toStringAsFixed(1))}',
                                              image: 'rate',
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 50.h,
                                          width: 54.w,
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
                                                  name: data[0]['mealPrice'],
                                                  fontSize: 18.sp,
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
                                                  fontSize: 13.sp,
                                                  color: AppColors.white,
                                                  // fontWeight: FontWeight.w400,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ),
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r)),
                        child: Padding(
                          padding: EdgeInsets.only(right: 12.r),
                          child: AppTextStyle(
                            isMarai: false,
                            color: AppColors.black,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                            name: data[0]['mealDescription'],
                          ),
                        ),
                      ),
                      ProductBody(data: data)
                    ],
                  ),
                ),
              );
            } else {
              return Waiting();
            }
          },
        ),
      );
    });
  }

  Container buildMyNavBar(BuildContext context) {
    return Container(
      height: 65.h,
      padding: EdgeInsets.only(bottom: 5.h),
      decoration: BoxDecoration(
        color: AppColors.bottomNavigationColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12.r),
          topLeft: Radius.circular(12.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                padding: const EdgeInsets.all(0),
                enableFeedback: false,
                onPressed: () {
                  Get.offAll(menu(currentItem: MenuItems.Home));
                },
                icon: pageIndex == 0
                    ? CustomSvgImage(
                        height: 24.h,
                        width: 22.h,
                        imageName: 'home',
                        color: HexColor(AppController.hexColorPrimary.value),
                      )
                    : CustomSvgImage(
                        height: 24.h,
                        width: 22.h,
                        imageName: 'home',
                      ),
              ),
              pageIndex == 0
                  ? AppTextStyle(
                      name: 'الرئيسية',
                      height: 0.5,
                      fontSize: 8.sp,
                      color: HexColor(AppController.hexColorPrimary.value),
                    )
                  : AppTextStyle(
                      name: 'الرئيسية',
                      fontSize: 8.sp,
                      height: 0.5,
                      color: AppColors.white,
                    ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                padding: const EdgeInsets.all(0),
                enableFeedback: false,
                onPressed: () {
                  Get.offAll(OfferScreen());
                },
                icon: pageIndex == 1
                    ? CustomSvgImage(
                        height: 24.h,
                        width: 22.h,
                        imageName: 'offers',
                        color: HexColor(AppController.hexColorPrimary.value),
                      )
                    : CustomSvgImage(
                        height: 24.h,
                        width: 22.h,
                        imageName: 'offers',
                      ),
              ),
              pageIndex == 1
                  ? AppTextStyle(
                      name: 'العروض',
                      fontSize: 8.sp,
                      height: 0.5,
                      color: HexColor(AppController.hexColorPrimary.value),
                    )
                  : AppTextStyle(
                      name: 'العروض',
                      fontSize: 8.sp,
                      height: 0.5,
                      color: AppColors.white,
                    ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                padding: const EdgeInsets.all(0),
                enableFeedback: false,
                onPressed: () {
                  Get.offAll(OrderScreen());
                },
                icon: pageIndex == 2
                    ? CustomSvgImage(
                        height: 24.h,
                        width: 22.h,
                        imageName: 'order',
                        color: HexColor(AppController.hexColorPrimary.value),
                      )
                    : CustomSvgImage(
                        height: 24.h,
                        width: 22.h,
                        imageName: 'order',
                      ),
              ),
              pageIndex == 2
                  ? AppTextStyle(
                      name: 'السلة',
                      fontSize: 8.sp,
                      color: HexColor(AppController.hexColorPrimary.value),
                      height: 0.5,
                    )
                  : AppTextStyle(
                      name: 'السلة',
                      fontSize: 8.sp,
                      color: AppColors.white,
                      height: 0.5,
                    ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                padding: const EdgeInsets.all(0),
                enableFeedback: false,
                onPressed: () {
                  Get.offAll(menu(currentItem: MenuItems.Profile));
                },
                icon: pageIndex == 3
                    ? CustomSvgImage(
                        height: 24.h,
                        width: 22.h,
                        imageName: 'person',
                        color: HexColor(AppController.hexColorPrimary.value),
                      )
                    : CustomSvgImage(
                        height: 24.h,
                        width: 22.h,
                        imageName: 'person',
                      ),
              ),
              pageIndex == 3
                  ? AppTextStyle(
                      name: 'حسابي',
                      fontSize: 8.sp,
                      color: HexColor(AppController.hexColorPrimary.value),
                      height: 0.5,
                    )
                  : AppTextStyle(
                      name: 'حسابي',
                      fontSize: 8.sp,
                      color: AppColors.white,
                      height: 0.5,
                    ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProductBody extends StatefulWidget {
  const ProductBody({super.key, required this.data});
  final List data;

  @override
  State<ProductBody> createState() => _ProductBodyState();
}

bool ex1 = false;
bool ex2 = false;
bool ex3 = false;
int count = 1;
TextEditingController noteFood = TextEditingController();

class _ProductBodyState extends State<ProductBody> {
  @override
  Widget build(BuildContext context) {
    var m = widget.data[0]['extensions'] as Map;
    bool x1 = false;
    bool x2 = false;
    bool x3 = false;
    List r = [];

    m.forEach((key, value) {
      if (value[1] != '') {
        r += value;
      }
    });
    for (var i = 0; i < r.length; i++) {
      if (i == 0) {
        x1 = true;
      }
      if (i == 1) {
        x2 = true;
      }
      if (i == 3) {
        x3 = true;
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: x1 || x2 || x3 ? 12.h : 0,
        ),
        x1 || x2 || x3
            ? AppTextStyle(
                textAlign: TextAlign.start,
                isMarai: false,
                color: AppColors.black,
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                name: 'الاضافات',
              )
            : Text(''),
        SizedBox(
          height: x1 || x2 || x3 ? 5.h : 0,
        ),
        x1
            ? SizedBox(
                height: 53.h,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  // color: click ? HexColor(AppController.hexColorPrimary.value).withOpacity(.2) : AppColors.white,
                  elevation: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: CheckboxListTile(
                              checkboxShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              contentPadding: EdgeInsets.zero,
                              activeColor:
                                  HexColor(AppController.hexColorPrimary.value),
                              title: AppTextStyle(
                                name: widget.data[0]['extensions']
                                    ['extensions1'][0],
                                color: AppColors.black,
                                fontWeight: FontWeight.w400,
                                isMarai: false,
                                fontSize: 11.sp,
                              ),
                              value: ex1,
                              onChanged: (bool? value) {
                                setState(() {
                                  ex1 = value!;
                                });
                              },
                            ),
                          ),
                        ),
                        const Spacer(),
                        AppTextStyle(
                          name:
                              '${widget.data[0]['extensions']['extensions1'][1]} ${AppController.appData.value.currency}',
                          color: AppColors.black,
                          fontWeight: FontWeight.w400,
                          isMarai: false,
                          fontSize: 10.sp,
                        )
                      ],
                    ),
                  ),
                ),
              )
            : Text(''),
        x2
            ? SizedBox(
                height: 53.h,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  // color: click ? HexColor(AppController.hexColorPrimary.value).withOpacity(.2) : AppColors.white,
                  elevation: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: CheckboxListTile(
                              checkboxShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              contentPadding: EdgeInsets.zero,
                              activeColor:
                                  HexColor(AppController.hexColorPrimary.value),
                              title: AppTextStyle(
                                name: widget.data[0]['extensions']
                                    ['extensions2'][0],
                                color: AppColors.black,
                                fontWeight: FontWeight.w400,
                                isMarai: false,
                                fontSize: 11.sp,
                              ),
                              value: ex2,
                              onChanged: (bool? value) {
                                setState(() {
                                  ex2 = value!;
                                });
                              },
                            ),
                          ),
                        ),
                        const Spacer(),
                        AppTextStyle(
                          name:
                              '${widget.data[0]['extensions']['extensions2'][1]} ${AppController.appData.value.currency}',
                          color: AppColors.black,
                          fontWeight: FontWeight.w400,
                          isMarai: false,
                          fontSize: 10.sp,
                        )
                      ],
                    ),
                  ),
                ),
              )
            : Text(''),
        x3
            ? SizedBox(
                height: 53.h,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  // color: click ? HexColor(AppController.hexColorPrimary.value).withOpacity(.2) : AppColors.white,
                  elevation: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: CheckboxListTile(
                              checkboxShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              contentPadding: EdgeInsets.zero,
                              activeColor:
                                  HexColor(AppController.hexColorPrimary.value),
                              title: AppTextStyle(
                                name: widget.data[0]['extensions']
                                    ['extensions3'][0],
                                color: AppColors.black,
                                fontWeight: FontWeight.w400,
                                isMarai: false,
                                fontSize: 11.sp,
                              ),
                              value: ex3,
                              onChanged: (bool? value) {
                                setState(() {
                                  ex3 = value!;
                                });
                              },
                            ),
                          ),
                        ),
                        const Spacer(),
                        AppTextStyle(
                          name:
                              '${widget.data[0]['extensions']['extensions3'][1]} ${AppController.appData.value.currency}',
                          color: AppColors.black,
                          fontWeight: FontWeight.w400,
                          isMarai: false,
                          fontSize: 10.sp,
                        )
                      ],
                    ),
                  ),
                ),
              )
            : Text(''),
        SizedBox(
          height: x1 || x2 || x3 ? 11.h : 0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AppTextStyle(
              isMarai: false,
              color: AppColors.black,
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              name: '''ملحوظة''',
              textAlign: TextAlign.start,
            ),
          ],
        ),
        SizedBox(
          height: 5.h,
        ),
        Card(
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
          color: AppColors.whiteEB,
          child: Padding(
            padding: EdgeInsets.all(6.r),
            child: AppTextField(
              controller: noteFood,
              hint: 'أضف ملحوظة على طلبك. مثلا (بدون بصل أو توابل حارة)',
              hintFont: 9,
            ),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Row(
          children: [
            Spacer(),
            SizedBox(
              height: 35.h,
              width: 35.w,
              child: InkWell(
                onTap: () {
                  count -= 1;
                  setState(() {});
                },
                child: Card(
                  color: HexColor(AppController.hexColorPrimary.value),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: AppTextStyle(
                      textAlign: TextAlign.center,
                      name: '-',
                      fontSize: 20.sp,
                      isMarai: false,

                      height: 1,

                      color: AppColors.white,
                      // fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 5.w,
            ),
            AppTextStyle(
              isMarai: false,
              color: AppColors.black,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              name: '$count',
            ),
            SizedBox(
              width: 5.w,
            ),
            SizedBox(
              height: 35.h,
              width: 35.w,
              child: InkWell(
                onTap: () {
                  count += 1;
                  setState(() {});
                },
                child: Card(
                  color: HexColor(AppController.hexColorPrimary.value),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Center(
                    child: AppTextStyle(
                      textAlign: TextAlign.center,
                      name: '+',
                      fontSize: 22.sp,
                      isMarai: false,

                      height: 1,

                      color: AppColors.white,
                      // fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20.h,
        ),
        CardRow(
            title: 'السعر',
            title2:
                '${int.parse(widget.data[0]['mealPrice']) * count} ${AppController.appData.value.currency}'),
        SizedBox(
          height: 14.h,
        ),
        FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('restaurant')
              .where('uid', isEqualTo: widget.data[0]['restaurantID'])
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var datar = snapshot.data!.docs[0].data() as Map;

              return Column(
                children: [
                  CardRow(
                      title: 'التوصيل',
                      title2:
                          '${datar['deliveryPricing']} ${AppController.appData.value.currency}'),
                  SizedBox(
                    height: ex1 && x1 ? 14.h : 0,
                  ),
                  ex1 && x1
                      ? CardRow(
                          title: widget.data[0]['extensions']['extensions1'][0],
                          title2:
                              '${widget.data[0]['extensions']['extensions1'][1]} ${AppController.appData.value.currency}',
                        )
                      : SizedBox(height: 0),
                  SizedBox(
                    height: ex2 && x2 ? 14.h : 0,
                  ),
                  ex2 && x2
                      ? CardRow(
                          title: widget.data[0]['extensions']['extensions2'][0],
                          title2:
                              '${widget.data[0]['extensions']['extensions2'][1]} ${AppController.appData.value.currency}',
                        )
                      : SizedBox(height: 0),
                  SizedBox(
                    height: ex3 ? 14.h : 0,
                  ),
                  ex3 && x3
                      ? CardRow(
                          title: widget.data[0]['extensions']['extensions3'][0],
                          title2:
                              '${widget.data[0]['extensions']['extensions3'][1]} ${AppController.appData.value.currency}',
                        )
                      : SizedBox(height: 0),
                  SizedBox(
                    height: 14.h,
                  ),
                  CardRow(
                    title: 'الاجمالي',
                    title2:
                        '${(int.parse(widget.data[0]['mealPrice']) * count) + (int.parse(datar['deliveryPricing'])) + (ex1 && x1 ? int.parse(widget.data[0]['extensions']['extensions1'][1]) : 0) + (ex2 && x2 ? int.parse(widget.data[0]['extensions']['extensions2'][1]) : 0) + (ex3 && x3 ? int.parse(widget.data[0]['extensions']['extensions3'][1]) : 0)} ${AppController.appData.value.currency}',
                    fontSize: 12,
                    isBold: true,
                  ),
                  SizedBox(
                    height: 33.h,
                  ),
                  // Spacer(),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('cart')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        bool remove = false;
                        String id = '';
                        Map e = snapshot.data!.docs.isEmpty
                            ? {}
                            : snapshot.data!.docs[0].data() as Map;
                        e.forEach((key, value) {
                          if (value['mealID'] ==
                              (snapshot.data!.docs.isEmpty
                                  ? '!'
                                  : widget.data[0]['uid'])) {
                            remove = true;
                            id = key;
                          }
                        });
                        return AppButton(
                            color:
                                HexColor(AppController.hexColorPrimary.value),
                            title: remove ? 'ذهاب الى السلة' : 'اضف الى السلة',
                            onPressed: () async {
                              // Get.to(const OrderScreen());
                              List<gecoding.Placemark> placemarks =
                                  await gecoding.placemarkFromCoordinates(
                                double.parse(
                                    AppPreferences().getData(key: 'lat')),
                                double.parse(
                                    AppPreferences().getData(key: 'long')),
                              );
                              final String address =
                                  '${placemarks.first.street}';
                              var order = {
                                'image': widget.data[0]['mealImages'][0],
                                'mealName': widget.data[0]['mealName'],
                                'count': count,
                                'mealID': widget.data[0]['uid'],
                                'userNote': noteFood.text,
                                'extensions': x1 || x2 || x3
                                    ? [
                                        ex1
                                            ? (widget.data[0]['extensions']
                                                    ['extensions1'][0] +
                                                ' : ' +
                                                widget.data[0]['extensions']
                                                    ['extensions1'][1])
                                            : '',
                                        ex2
                                            ? (widget.data[0]['extensions']
                                                    ['extensions2'][0] +
                                                ' : ' +
                                                widget.data[0]['extensions']
                                                    ['extensions2'][1])
                                            : '',
                                        ex3
                                            ? (widget.data[0]['extensions']
                                                    ['extensions3'][0] +
                                                ' : ' +
                                                widget.data[0]['extensions']
                                                    ['extensions3'][1])
                                            : ''
                                      ]
                                    : [''],
                                'restaurantName': widget.data[0]
                                    ['restaurantName'],
                                'restaurantID': widget.data[0]['restaurantID'],
                                'postionName': address,
                                'postionCoordinates': [
                                  AppPreferences().getData(key: 'lat'),
                                  AppPreferences().getData(key: 'long')
                                ],
                                'clientName':
                                    AppPreferences().getUserDataAsMap()['name'],
                                'clientPhone': AppPreferences()
                                    .getUserDataAsMap()['phone'],
                                'totalOrder':
                                    ((int.parse(widget.data[0]['mealPrice']) * count) +
                                        (int.parse(datar['deliveryPricing'])) +
                                        (ex1 && x1
                                            ? int.parse(widget.data[0]
                                                    ['extensions']
                                                ['extensions1'][1])
                                            : 0) +
                                        (ex2 && x2
                                            ? int.parse(widget.data[0]
                                                    ['extensions']
                                                ['extensions2'][1])
                                            : 0) +
                                        (ex3 && x3
                                            ? int.parse(
                                                widget.data[0]['extensions']
                                                    ['extensions3'][1])
                                            : 0))
                              };

                              remove
                                  ? {Get.to(OrderScreen()), remove = false}
                                  : (FirebaseFirestore.instance
                                      .collection('cart')
                                      .doc(AppPreferences()
                                          .getUserDataAsMap()['uid'])
                                      .set({
                                      'Otlob22-' + getRandomString(16): order
                                    }, SetOptions(merge: true)).then((value) =>
                                          getSheetSucsses(
                                              'تمت الأضافة الى السلة')));
                            });
                      } else {
                        return Text("");
                      }
                    },
                  ),
                ],
              );
            } else {
              return Waiting();
            }
          },
        ),
      ],
    );
  }
}
