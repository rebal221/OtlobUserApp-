// ignore_for_file: must_be_immutable
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otlob/screens/menu/Drawer.dart';
import 'package:otlob/screens/product/product_page.dart';
import 'package:otlob/services/preferences/app_preferences.dart';
import 'package:otlob/widget/component.dart';
import 'package:otlob/widget/row_svg.dart';
import 'package:otlob/widget/waiting.dart';
import '../../../value/colors.dart';
import '../../../widget/app_style_text.dart';
import '../../server/controller/app_controller.dart';
import '../allResturant/resturant_page/resutrant_page_p.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
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
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(AppPreferences().getUserDataAsMap()['uid'])
              .snapshots(),
          builder: (context, snapshot) {
            Map restaurants = {};
            Map meals = {};
            snapshot.data!.data()!['favorites'] != null
                ? snapshot.data!['favorites'] as Map
                : FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .set({
                    'favorites': {'restaurants': {}, 'meals': {}}
                  }, SetOptions(merge: true));
            Map data = snapshot.data!['favorites'] as Map;
            data.forEach((key, value) {
              key == 'restaurants'
                  ? (value != null ? restaurants = value : {})
                  : {};
              key == 'meals' ? (value != null ? meals = value : {}) : {};
            });
            if (snapshot.hasData) {
              List res = [];
              List mel = [];
              restaurants.forEach((key, value) {
                value ? res += [key] : [];
              });
              meals.forEach((key, value) {
                value ? mel += [key] : [];
              });
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    RowAll(mainTitle: 'المطاعم المفضلة', subTitle: 'تصفية حسب'),
                    SizedBox(
                      height: 10.h,
                    ),
                    res.isEmpty
                        ? const AppTextStyle(
                            name: 'قم بإضافة المطاعم الى المفضلة',
                            color: Colors.black54,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          )
                        : GridView.builder(
                            gridDelegate:
                                (SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 10.w,
                                    crossAxisSpacing: 13.h)),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return FavoriteWidght(
                                data: res,
                                isMeals: false,
                                index: index,
                              );
                            },
                            itemCount: res.length),
                    SizedBox(
                      height: 23.h,
                    ),
                    RowAll(mainTitle: 'الوجبات المفضلة', subTitle: 'تصفية حسب'),
                    SizedBox(
                      height: 10.h,
                    ),
                    mel.isEmpty
                        ? const AppTextStyle(
                            name: 'قم بإضافة الوجبات الى المفضلة',
                            color: Colors.black54,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          )
                        : GridView.builder(
                            gridDelegate:
                                (SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 10.w,
                                    crossAxisSpacing: 13.h)),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              bool visible1 = false;
                              return FavoriteWidght(
                                data: mel,
                                isMeals: true,
                                index: index,
                              );
                            },
                            itemCount: mel.length),
                    SizedBox(
                      height: 23.h,
                    )
                  ],
                ),
              );
            } else {
              return Text("No data");
            }
          },
        ),
      );
    });
  }
}

class RowAll extends StatelessWidget {
  String mainTitle;
  String subTitle;

  RowAll({super.key, required this.mainTitle, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppTextStyle(
          name: mainTitle,
          color: AppColors.black,
          fontSize: 9.sp,
          isMarai: false,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }
}

class FavoriteWidght extends StatefulWidget {
  const FavoriteWidght(
      {super.key,
      required this.data,
      required this.isMeals,
      required this.index});
  final List data;
  final bool isMeals;
  final int index;
  @override
  State<FavoriteWidght> createState() => _FavoriteWidghtState();
}

CollectionReference meals = FirebaseFirestore.instance.collection('meals');
CollectionReference restaurants =
    FirebaseFirestore.instance.collection('restaurant');

getRestaurants(String id) async {
  var querySnapshot = await FirebaseFirestore.instance
      .collection('restaurant')
      .where('uid', isEqualTo: '$id')
      .get();
  final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  return allData;
}

getMeals(String id) async {
  var querySnapshot = await FirebaseFirestore.instance
      .collection('meals')
      .where('uid', isEqualTo: '$id')
      .get();
  final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  return allData;
}

class _FavoriteWidghtState extends State<FavoriteWidght> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.isMeals
          ? getMeals(widget.data[widget.index])
          : getRestaurants(widget.data[widget.index]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var data = snapshot.data as List;

          String name = widget.isMeals ? data[0]['mealName'] : data[0]['name'];
          String image =
              widget.isMeals ? data[0]['mealImages'][0] : data[0]['images'][0];
          String des = widget.isMeals
              ? data[0]['mealType']
              : data[0]['category']['name'];
          String phone =
              widget.isMeals ? data[0]['mealDescription'] : data[0]['phone'];
          String _location = widget.isMeals
              ? data[0]['restaurantName']
              : data[0]['restaurantAdderss'];

          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              widget.isMeals
                  ? Get.to(ProductPage(id: widget.data[widget.index]))
                  : Get.to(ResturantPage(id: widget.data[widget.index]));
            },
            child: Container(
              height: 150,
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 231, 231, 231),
                  borderRadius: BorderRadius.circular(8.r)),
              child: Column(
                children: [
                  Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(8.r)),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: CachedNetworkImage(
                            imageUrl: image,
                            height: 110.h,
                            // width: 72.w,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (context, url) =>
                                shimmerCarDes(context),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        Visibility(
                          visible: true,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.w, vertical: 9.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 40.h,
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
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 10),
                                              child: AppTextStyle(
                                                textAlign: TextAlign.center,
                                                name: des,
                                                fontSize: 8.sp,
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  ListView(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    shrinkWrap: true,

                    physics: const NeverScrollableScrollPhysics(),
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextStyle(
                        textAlign: TextAlign.center,
                        name: name,
                        fontSize: 9.sp,
                        color: AppColors.black,
                        fontWeight: FontWeight.w500,
                        isMarai: false,
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              RowSvg(
                                title: phone,
                                image: 'Filter',
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              RowSvg(
                                title: _location,
                                image: 'maps',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        } else {
          return Waiting();
        }
      },
    );
  }
}
