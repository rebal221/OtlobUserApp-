import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otlob/screens/main/main_screens/home.dart';
import 'package:otlob/screens/main/main_screens/order.dart';
import 'package:otlob/screens/main/main_screens/profile.dart';
import 'package:otlob/widget/button_column.dart';
import 'package:otlob/widget/component.dart';
import 'package:otlob/widget/continer_list_details.dart';
import 'package:otlob/widget/custom_image.dart';
import 'package:otlob/widget/row_icon.dart';
import 'package:otlob/widget/row_svg.dart';

import '../../../server/controller/app_controller.dart';
import '../../../value/colors.dart';
import '../../../widget/app_style_text.dart';
import '../../menu/Drawer.dart';
import '../../product/product_page.dart';

class OfferScreen extends StatefulWidget {
  const OfferScreen({Key? key}) : super(key: key);

  @override
  State<OfferScreen> createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
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

  int pageIndex = 1;

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
          // leading: MenuWidget(),
          actions: const [
            MenuWidget(),
          ],
        ),
        body: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AppTextStyle(
                    name: 'قائمة العروض',
                    color: AppColors.black,
                    fontSize: 10.sp,
                    isMarai: false,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(
                    height: 14.h,
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('offers')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              bool visible = true;
                              if (index % 2 != 0) {
                                visible = false;
                              } else {
                                visible = true;
                              }
                              return GestureDetector(
                                onTap: () {
                                  Get.to(ProductPage(
                                      id: snapshot.data!.docs[index]
                                          ['mealID']));
                                },
                                child: AbsorbPointer(
                                  child: Container(
                                    height: 170.h,
                                    decoration: BoxDecoration(
                                        color: AppColors.greyF8,
                                        borderRadius:
                                            BorderRadius.circular(8.r)),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 112.h,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.r)),
                                          child: Stack(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                ),
                                                clipBehavior: Clip.antiAlias,
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      snapshot.data!.docs[index]
                                                          ['offerImage'],
                                                  // height: 72.h,snapshot
                                                  // .data!.docs[index]
                                                  // .data()['offerImage']
                                                  // width: 72.w,
                                                  imageBuilder: (context,
                                                          imageProvider) =>
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
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5.w,
                                                    vertical: 9.h),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 33.h,
                                                      width: 87.w,
                                                      child: Card(
                                                        color: HexColor(
                                                            AppController
                                                                .hexColorPrimary
                                                                .value),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.r),
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Flexible(
                                                              child:
                                                                  AppTextStyle(
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                name: snapshot
                                                                        .data!
                                                                        .docs[index]
                                                                    [
                                                                    'offerType'],
                                                                fontSize: 10.sp,
                                                                isMarai: false,

                                                                // height: 1,

                                                                color: AppColors
                                                                    .white,
                                                                // fontWeight: FontWeight.w400,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.w),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: 35.h,
                                                  width: 35.w,
                                                  padding: EdgeInsets.all(3.r),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.white),
                                                      shape: BoxShape.circle,
                                                      color: Colors.transparent

                                                      // shape: RoundedRectangleBorder(
                                                      //   borderRadius: BorderRadius.circular(8.r),
                                                      ),
                                                  child: SizedBox(
                                                    height: 48.h,
                                                    width: 28.w,
                                                    child: Container(
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      decoration: const BoxDecoration(
                                                          shape: BoxShape.circle

                                                          // shape: RoundedRectangleBorder(
                                                          //   borderRadius: BorderRadius.circular(8.r),
                                                          ),
                                                      child: CachedNetworkImage(
                                                        imageUrl: snapshot.data!
                                                                .docs[index]
                                                            ['offerImage'],
                                                        // height: 72.h,
                                                        // width: 72.w,
                                                        imageBuilder: (context,
                                                                imageProvider) =>
                                                            Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            image:
                                                                DecorationImage(
                                                              image:
                                                                  imageProvider,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        placeholder:
                                                            (context, url) =>
                                                                shimmerCarDes(
                                                                    context),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Icon(
                                                                Icons.error),
                                                      ),
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
                                                      name: snapshot
                                                              .data!.docs[index]
                                                          ['offerName'],
                                                      fontSize: 10.sp,
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      isMarai: false,
                                                    ),
                                                    AppTextStyle(
                                                      name: snapshot
                                                              .data!.docs[index]
                                                          ['restaurantName'],
                                                      fontSize: 6.sp,
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      isMarai: false,
                                                    ),
                                                    SizedBox(
                                                      height: 5.h,
                                                    ),
                                                    Row(
                                                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                                                      children: [
                                                        RowIcon(
                                                            title:
                                                                '30 دقيقة تقريباً',
                                                            iconData: Icons
                                                                .access_time_filled_rounded,
                                                            color: AppColors
                                                                .black),
                                                        SizedBox(
                                                          width: 10.w,
                                                        ),
                                                        SizedBox(
                                                          width: 10.w,
                                                        ),
                                                        RowSvg(
                                                          title: snapshot.data!
                                                                  .docs[index][
                                                              'restaurantAddress'],
                                                          image: 'maps',
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const Spacer(),
                                                Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 40.h,
                                                      child: Card(
                                                        color: HexColor(
                                                            AppController
                                                                .hexColorPrimary
                                                                .value),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.r),
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 8.0,
                                                                      right: 8),
                                                              child:
                                                                  AppTextStyle(
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                name: snapshot
                                                                        .data!
                                                                        .docs[index]
                                                                    [
                                                                    'offerValue'],
                                                                fontSize: 10.sp,
                                                                isMarai: false,

                                                                height: 1,

                                                                color: AppColors
                                                                    .white,
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
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return Divider(
                                height: 28.h,
                              );
                            },
                            itemCount: snapshot.data!.docs.length);
                      } else {
                        return Text("No data");
                      }
                    },
                  ),
                ],
              ),
            )),
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
}
