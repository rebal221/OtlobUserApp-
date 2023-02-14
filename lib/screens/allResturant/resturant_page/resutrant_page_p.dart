// ignore_for_file: non_constant_identifier_names

import 'dart:developer';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otlob/screens/main/main_screens/home.dart';
import 'package:otlob/screens/main/main_screens/offer_screen.dart';
import 'package:otlob/screens/main/main_screens/order.dart';
import 'package:otlob/screens/main/main_screens/profile.dart';
import 'package:otlob/screens/menu/Drawer.dart';
import 'package:otlob/screens/product/product_page.dart';
import 'package:otlob/server/controller/app_controller.dart';
import 'package:otlob/value/colors.dart';
import 'package:otlob/value/constant.dart';
import 'package:otlob/widget/app_style_text.dart';
import 'package:otlob/widget/app_text_field.dart';
import 'package:otlob/widget/box.dart';
import 'package:otlob/widget/card_grey_c.dart';
import 'package:otlob/widget/cash_network.dart';
import 'package:otlob/widget/component.dart';
import 'package:otlob/widget/images_slider.dart';
import 'package:otlob/widget/row_icon.dart';
import 'package:otlob/widget/row_icon_visa.dart';
import 'package:otlob/widget/row_svg.dart';
import 'package:otlob/widget/waiting.dart';
import 'package:rate/rate.dart';

import '../../../services/preferences/app_preferences.dart';
import '../../../widget/card_grey_rate.dart';
import '../../../widget/custom_image.dart';
import '../../../widget/resturant_information.dart';
import '../../../widget/row_edit.dart';
import '../../../widget/row_price.dart';

class ResturantPage extends StatefulWidget {
  ResturantPage({
    Key? key,
    required this.id,
  }) : super(key: key);
  final String id;
  @override
  State<ResturantPage> createState() => _ResturantPageState();
}

class _ResturantPageState extends State<ResturantPage> {
  AppController controller = Get.find();

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

  static const _chars = '1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

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

  TextEditingController clientRate = TextEditingController();
  double rate = 0.0;

  getResutrant() async {
    var data = FirebaseFirestore.instance
        .collection('restaurant')
        .doc(widget.id)
        .get()
        .then((value) => value.data());
    return data;
  }

  int pageIndex = 5;

  final pages = [
    const Home(),
    const OfferScreen(),
    const OrderScreen(),
    const ProfileScreen(),
  ];

  CollectionReference meals = FirebaseFirestore.instance.collection('meals');
  CollectionReference offers = FirebaseFirestore.instance.collection('offers');
  CollectionReference restaurant =
      FirebaseFirestore.instance.collection('restaurant');

  getMeals() async {
    // Get docs from collection reference

    var querySnapshot =
        await meals.where('restaurantID', isEqualTo: widget.id).get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    return allData;
  }

  getRate() async {
    // Get docs from collection reference

    var querySnapshot =
        await restaurant.where('uid', isEqualTo: widget.id).get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    return allData;
  }

  getOffers() async {
    // Get docs from collection reference

    var querySnapshot =
        await offers.where('restaurantID', isEqualTo: widget.id).get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    return allData;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ));
    return Obx(() {
      return DefaultTabController(
        length: 3,
        child: Scaffold(
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
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('restaurant')
                .where('uid', isEqualTo: widget.id)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data1 = snapshot.data!.docs[0].data() == null
                    ? {}
                    : snapshot.data!.docs[0].data() as Map;
                var data = {};
                if (data1['images'].toString() != '[]' &&
                    data1['deliveryPricing'].toString() != '') {
                  data = data1;
                }
                List images = data['images'] as List;
                return Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
                      children: [
                        Column(
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
                                                  ? ((data['favorites'][
                                                                  'restaurants'])
                                                              .toString() !=
                                                          '[]'
                                                      ? (fav = data['favorites']
                                                                      [
                                                                      'restaurants']
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
                                                          .doc(FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid)
                                                          .set(
                                                              {
                                                              'favorites': {
                                                                'restaurants': {
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
                                                              'تم أزالة المطعم من المفضلة');
                                                        })
                                                      : FirebaseFirestore
                                                          .instance
                                                          .collection('users')
                                                          .doc(FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid)
                                                          .set(
                                                              {
                                                              'favorites': {
                                                                'restaurants': {
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
                                                              'تم اضافة المطعم الى المفضلة');
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
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppTextStyle(
                                        name: data['name'],
                                        fontSize: 12.sp,
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w700,
                                        isMarai: false,
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          RowSvg(
                                            title:
                                                '${(int.parse(data['deliveryPricing']) / 7).toStringAsFixed(0)} دقيقة',
                                            image: 'speed',
                                          ),
                                          RowIcon(
                                              title:
                                                  'متوسط الأسعار : ${(((int.parse(data['pricingFrom']) + int.parse(data['pricingTo'])) / 2).toStringAsFixed(0))} ${AppController.appData.value.currency}',
                                              iconData: Icons.monetization_on,
                                              color: AppColors.black),
                                          RowIcon(
                                              title: data['restaurantAdderss'],
                                              iconData: Icons.map,
                                              color: AppColors.black),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        const Divider(
                          color: AppColors.greyC,
                        ),
                        SizedBox(
                          height: 1000.h,
                          child: Column(
                            children: [
                              // construct the profile details widget here

                              // the tab bar with two items
                              SizedBox(
                                height: 50.h,
                                child: AppBar(
                                  leading: Container(
                                    width: 0,
                                    height: 0,
                                  ),
                                  bottom: TabBar(
                                    indicatorColor: HexColor(
                                        AppController.hexColorPrimary.value),

                                    // mouseCursor: MouseCursor.defer,

                                    labelStyle: GoogleFonts.cairo(
                                      color: AppColors.black,
                                      // letterSpacing: letterSpacing,
                                      // wordSpacing: wordSpacing,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 10.sp,
                                    ),

                                    labelColor: AppColors.black,

                                    tabs: const [
                                      Tab(
                                        text: 'قائمة المطعم',
                                      ),
                                      Tab(
                                        text: 'التقييمات',
                                      ),
                                      Tab(
                                        text: 'معلومات المطعم',
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // create widgets for each tab bar here
                              Expanded(
                                child: TabBarView(
                                  children: [
                                    // first tab bar view widget

                                    listRestaurant(),
                                    RatingResaurant(),
                                    InfoRetaurant(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Waiting();
              }
            },
          ),
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
                  Get.offAll(menu(currentItem: MenuItems.Order));
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

  Widget listRestaurant() {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Divider(
          height: 1.h,
          color: AppColors.greyC,
        ),
        SizedBox(
          height: 17.h,
        ),
        AppTextStyle(
          name: 'كافة الوجبات',
          fontSize: 10.sp,
          color: AppColors.black,
          isMarai: false,
        ),
        SizedBox(
          height: 8.h,
        ),
        FutureBuilder(
          future: getMeals(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var data = snapshot.data as List;
              return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Get.to(ProductPage(id: data[index]['uid']));
                      },
                      child: RowTextTwo(
                          titel: data[index]['mealName'],
                          subTitel: data[index]['mealDescription'],
                          price: data[index]['mealPrice'],
                          image: data[index]['mealImages'][0]),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: 28.h,
                    );
                  },
                  itemCount: data.length);
            } else {
              return Waiting();
            }
          },
        ),
        SizedBox(
          height: 10.h,
        ),
        AppTextStyle(
          name: 'العروض',
          fontSize: 10.sp,
          color: AppColors.black,
          isMarai: false,
        ),
        SizedBox(
          height: 8.h,
        ),
        FutureBuilder(
          future: getOffers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var data = snapshot.data as List;
              return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Get.to(ProductPage(id: data[index]['mealID']));
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 55.h,
                            width: 50.w,
                            child: Card(
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child:
                                  CachNetwork(image: data[index]['offerImage']),
                            ),
                          ),
                          SizedBox(
                            width: 7.w,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppTextStyle(
                                  name: data[index]['offerName'],
                                  fontSize: 9.sp,
                                  color: AppColors.black,
                                  isMarai: false,
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                AppTextStyle(
                                  textAlign: TextAlign.start,
                                  name: data[index]['offerType'],
                                  isMarai: false,
                                  fontSize: 8.sp,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w400,
                                ),
                                SizedBox(
                                  height: 12.h,
                                ),
                              ],
                            ),
                          ),
                          // Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 40.h,
                                width: 65.w,
                                child: Card(
                                  color: HexColor(
                                      AppController.hexColorPrimary.value),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AppTextStyle(
                                        textAlign: TextAlign.center,
                                        name: data[index]['offerValue'],
                                        fontSize: 12.sp,
                                        isMarai: false,

                                        height: 1,

                                        color: AppColors.white,
                                        // fontWeight: FontWeight.w400,
                                      ),
                                      Visibility(
                                        visible: false,
                                        child: AppTextStyle(
                                          textAlign: TextAlign.center,
                                          name:
                                              '${AppController.appData.value.currency}',
                                          height: 1,
                                          isMarai: false,

                                          fontSize: 15.sp,
                                          color: AppColors.white,
                                          // fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 7.w,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: 28.h,
                    );
                  },
                  itemCount: data.length);
            } else {
              return Waiting();
            }
          },
        ),
      ],
    );
  }

  Widget InfoRetaurant() {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('restaurant')
            .doc(widget.id)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Divider(
                height: 1.h,
                color: AppColors.greyC,
              ),
              SizedBox(
                height: 17.h,
              ),
              AppTextStyle(
                name: 'معلومات عن المطعم',
                fontSize: 10.sp,
                color: AppColors.black,
                isMarai: false,
              ),
              SizedBox(
                height: 10.h,
              ),
              Divider(
                height: 5.h,
                color: AppColors.greyC,
              ),
              RowEdit(
                controller: TextEditingController(),
                title: 'ساعات العمل',
                hint:
                    '${data['workTimeTo']} صباحا - ${data['workTimeFrom']} مساء',
                visible: false,
                enable: false,
                fontSize: 9.sp,
              ),
              Divider(
                height: 3.h,
                color: AppColors.greyC,
              ),
              RowEdit(
                controller: TextEditingController(),
                title: 'متوسط التوصيل',
                hint: '${(int.parse(data['deliveryPricing']) / 5)} دقيقة',
                visible: false,
                enable: false,
                fontSize: 9.sp,
              ),
              Divider(
                height: 3.h,
                color: AppColors.greyC,
              ),
              RowEdit(
                controller: TextEditingController(),
                title: 'رسوم التوصيل',
                hint:
                    '${data['deliveryPricing']} ${AppController.appData.value.currency}',
                visible: false,
                enable: false,
                fontSize: 9.sp,
              ),
              Divider(
                height: 3.h,
                color: AppColors.greyC,
              ),
              SizedBox(
                height: 10.h,
              ),
              RowIconVisa(
                title: 'طرق الدفع',
                hint: '',
                type: data['paymentTypes'][0],
                visible: false,
                enable: false,
                fontSize: 9.sp,
              ),
              SizedBox(
                height: 10.h,
              ),
              Divider(
                height: 3.h,
                color: AppColors.greyC,
              ),
              RowEdit(
                controller: TextEditingController(),
                title: 'التقييم العام',
                hint: 'جيد جدا',
                visible: false,
                enable: false,
                fontSize: 9.sp,
              ),
              Divider(
                height: 3.h,
                color: AppColors.greyC,
              ),
              RowEdit(
                controller: TextEditingController(),
                title: 'تصنيف المطعم',
                hint: data['restaurantDescription'],
                visible: false,
                enable: false,
                fontSize: 9.sp,
              ),
              Divider(
                height: 3.h,
                color: AppColors.greyC,
              ),
            ],
          );
        });
  }

  Widget RatingResaurant() {
    return FutureBuilder(
      future: getRate(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var data = snapshot.data as List;
          return ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Divider(
                height: 1.h,
                color: AppColors.greyC,
              ),
              SizedBox(
                height: 17.h,
              ),
              AppTextStyle(
                name: 'تقييمات العملاء',
                fontSize: 10.sp,
                color: AppColors.black,
                isMarai: false,
              ),
              SizedBox(
                height: 10.h,
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('restaurant')
                      .doc(data[0]['uid'])
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Loading");
                    }

                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    Map rates =
                        (data['clientRate'] == null) ? {} : data['clientRate'];
                    List ratesDate = [];
                    rates.forEach((k, v) {
                      ratesDate += (v['rateStatus'] == 'waiting' ? [] : [v]);
                    });

                    return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          Timestamp t = ratesDate[index]['rateTime'];
                          DateTime d = t.toDate();
                          return CardGreyC(
                            name: ratesDate[index]['clientName'],
                            rate: ratesDate[index]['clientRate'],
                            ratevalue:
                                (ratesDate[index]['rateValue']).toString(),
                            time: d.toString(),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 9.h);
                        },
                        itemCount: ratesDate.length);
                  }),
              SizedBox(
                height: 17.h,
              ),
              AppTextStyle(
                name: 'أضف تقييم',
                fontSize: 10.sp,
                color: AppColors.black,
                isMarai: false,
              ),
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                height: 70.h,
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r)),
                  color: AppColors.whiteEB,
                  child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                    child: AppTextField(
                                      controller: clientRate,
                                      hint: 'اضف تقييمك',
                                      hintFont: 9,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5.w),
                                    child: Rate(
                                        iconSize: 25.r,
                                        color: HexColor(AppController
                                            .hexColorPrimary.value),
                                        allowHalf: false,
                                        allowClear: true,
                                        initialValue: rate,
                                        onChange: (value) => rate = value),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              if (rate == 0.0 || clientRate.text == '') {
                                getSheetError('يرجى إضافة تقييم');
                              } else {
                                var _rate = {
                                  'clientName': AppPreferences()
                                      .getUserDataAsMap()['name'],
                                  'clientRate': clientRate.text,
                                  'rateTime': DateTime.now(),
                                  'rateValue': rate,
                                  'rateStatus': 'waiting'
                                };
                                FirebaseFirestore.instance
                                    .collection('restaurant')
                                    .doc(data[0]['uid'])
                                    .set({
                                  'clientRate': {getRandomString(16): _rate}
                                }, SetOptions(merge: true)).then((value) {
                                  getSheetSucsses(
                                      'تم اضافة التقييم, بانتظار الموافقة');

                                  rate = 0.0;
                                  FirebaseFirestore.instance
                                      .collection('notifications')
                                      .doc('rateing')
                                      .set({
                                    'NO-' + getRandomString(12): {
                                      'restaurantID': data[0]['uid'],
                                      'clientRate': clientRate.text,
                                      'rateValue': rate,
                                      'rateStatus': 'new',
                                      'time': DateTime.now(),
                                    }
                                  }, SetOptions(merge: true)).then((value) {
                                    clientRate.text = '';
                                  });
                                });
                              }
                            },
                            child: Box(
                              price: 'تقييم',
                              visible: false,
                              fontSize: 10.sp,
                              width: 54.w,
                              height: 42.h,
                            ),
                          ),
                          // Spacer(),
                        ],
                      )),
                ),
              ),
            ],
          );
        } else {
          return Waiting();
        }
      },
    );
  }
}
