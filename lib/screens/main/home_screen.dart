import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otlob/screens/main/main_screens/notifications.dart';
import 'package:otlob/screens/main/main_screens/offer_screen.dart';
import 'package:otlob/screens/main/main_screens/order.dart';
import 'package:otlob/screens/main/main_screens/profile.dart';
import 'package:otlob/screens/product/product_page.dart';
import 'package:otlob/value/colors.dart';
import 'package:otlob/widget/app_style_text.dart';
import 'package:otlob/widget/custom_image.dart';
import '../../server/controller/app_controller.dart';
import 'main_screens/home.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final ZoomDrawerController z = ZoomDrawerController();

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

  int pageIndex = 0;

  final pages = [
    const Home(),
    const OfferScreen(),
    const OrderScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: pages[pageIndex],
        bottomNavigationBar: buildMyNavBar(context),
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
                  if (mounted) {
                    setState(() {
                      pageIndex = 0;
                    });
                  }
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
                  if (mounted) {
                    setState(() {
                      pageIndex = 1;
                    });
                  }
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
                  if (mounted) {
                    setState(() {
                      pageIndex = 2;
                    });
                  }
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
                  if (mounted) {
                    setState(() {
                      pageIndex = 3;
                    });
                  }
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

class MyDrawerController extends GetxController {
  final zoomDrawerController = ZoomDrawerController();

  void toggleDrawer() {
    log("Toggle drawer");
    zoomDrawerController.toggle?.call();
    update();
  }
}
