// ignore_for_file: constant_identifier_names, camel_case_types, must_be_immutable, file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otlob/screens/favorite/favorite.dart';
import 'package:otlob/screens/main/home_screen.dart';
import 'package:otlob/screens/main/main_screens/myOrder.dart';
import 'package:otlob/screens/main/main_screens/order.dart';
import 'package:otlob/screens/main/main_screens/profile.dart';
import 'package:otlob/screens/menu/privacy.dart';
import 'package:otlob/server/firebase_auth.dart';
import 'package:otlob/server/model/user_model.dart';
import 'package:otlob/services/preferences/app_preferences.dart';
// import 'package:otlob/screens/sing_in.dart';
import 'package:otlob/value/colors.dart';
import 'package:otlob/value/constant.dart';
import 'package:otlob/widget/custom_image.dart';
import 'package:otlob/widget/waiting.dart';

import '../../server/controller/app_controller.dart';
import '../../utils/helpers.dart';
import '../../widget/app_style_text.dart';
import '../../widget/component.dart';
import '../Auth/sing_in.dart';

class MenuItem {
  final String title;
  final String icon;

  const MenuItem(this.title, this.icon);
}

class menu extends StatefulWidget {
  MenuItem currentItem = MenuItems.Home;

  menu({super.key, required this.currentItem});

  @override
  menuState createState() => menuState();
}

class menuState extends State<menu> with Helpers {
  MenuItem currentItem = MenuItems.Home;

  @override
  void initState() {
    // TODO: implement initState
    //  currentItem = MenuItems.Home;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: ZoomDrawer(
          isRtl: true,

          borderRadius: 24.0,
          showShadow: true,
          angle: 0.0,
          style: DrawerStyle.defaultStyle,
          slideWidth: MediaQuery.of(context).size.width * .6,
          openCurve: Curves.fastOutSlowIn,
          closeCurve: Curves.bounceIn,
          menuBackgroundColor: HexColor(AppController.hexColorPrimary.value),
          // style: DrawerStyle.style1,
          mainScreen: getScreen(),
          menuScreen: Builder(
            builder: (context) => MenuScreen(
                currentItem: widget.currentItem,
                onSelectedItem: (item) {
                  if (mounted) {
                    setState(() => widget.currentItem = item);
                    ZoomDrawer.of(context)!.close();
                  }
                }),
          ),
        ),
      );
    });
  }

  Widget getScreen() {
    switch (widget.currentItem) {
      case MenuItems.Home:
        return const HomePage();
      case MenuItems.Profile:
        return const ProfileScreen();
      case MenuItems.Order:
        return const myOrderScreen();
      case MenuItems.Fav:
        return const FavoriteScreen();
      case MenuItems.Privacy:
        return const PrivacyScreen();
      case MenuItems.Logout:
        AppPreferences().clearKey('userData');
        // FirebaseAuthController().signOut();
        // getSheetSucsses('تم تسجيل الخروج');
        return const SignIn();

      // case MenuItems.Setting:

      // case MenuItems.About:
      //   return About();
      default:
        return HomePage();
    }
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> with Helpers {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(''),
          leading: const MenuWidget(),
        ));
  }
}

class MenuItems {
  static const Home = MenuItem('الرئيسية', 'home');
  static const Profile = MenuItem('حسابي', 'person');
  static const Order = MenuItem('طلباتي', 'order');
  static const Fav = MenuItem('مفضلتي', 'fav');
  // static const Rating = MenuItem('تقييم التطبيق', 'rate');
  static const Privacy = MenuItem('سياسة الخصوصية', 'privacy');
  static const Logout = MenuItem('تسجيل خروج', 'logout');

  static const all = <MenuItem>[
    Home,
    Profile,
    Order,
    Fav,
    // Rating,
    Privacy,
    Logout
  ];
}

class MenuScreen extends StatefulWidget {
  final MenuItem currentItem;
  final ValueChanged<MenuItem> onSelectedItem;

  const MenuScreen(
      {Key? key, required this.currentItem, required this.onSelectedItem})
      : super(key: key);

  @override
  MenuScreenState createState() => MenuScreenState();
}

class MenuScreenState extends State<MenuScreen> with Helpers {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: HexColor(AppController.hexColorPrimary.value),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsetsDirectional.only(start: 15.w),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 80.h,
                          width: 80.w,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              shape: BoxShape.circle,
                              color: Colors.white),
                          padding: EdgeInsets.all(3.r),
                          child: SizedBox(
                            height: 80.h,
                            width: 80.w,
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration:
                                  const BoxDecoration(shape: BoxShape.circle),
                              child: CachedNetworkImage(
                                imageUrl: AppPreferences()
                                    .getUserDataAsMap()['image'],
                                // height: 72.h,
                                // width: 72.w,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    shimmerCarDes(context),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Divider(
                      height: 40.h,
                      color: AppColors.white,
                      // thickness: 1.r,
                    ),
                    // Spacer(),
                    ...MenuItems.all.map(buildMenuItem).toList(),
                    const Spacer(flex: 4),
                    // Icon(
                    //   Icons.logout,
                    //   size: 20,
                    //   color: Colors.white,
                    // ),
                    // TextButton(
                    //   onPressed: () async {
                    //
                    //   },
                    //   child: Text(
                    //     'Log out'.tr,
                    //     style: TextStyle(
                    //       color: Colors.white,
                    //       fontSize: 20,
                    //     ),
                    //   ),
                    // ),
                  ]),
            ),
          )),
    );
  }

  Widget buildMenuItem(MenuItem item) => ListTileTheme(
        selectedColor: HexColor(AppController.hexColorPrimary.value),
        child: ListTile(
          selectedTileColor: AppColors.white,
          selected: widget.currentItem == item,
          minLeadingWidth: 20,
          leading: CustomSvgImage(
            imageName: item.icon,
            height: 17.h,
            width: 14.w,
            color: widget.currentItem == item
                ? HexColor(AppController.hexColorPrimary.value)
                : AppColors.white,
          ),
          title: AppTextStyle(
            name: item.title,
            color: widget.currentItem == item
                ? HexColor(AppController.hexColorPrimary.value)
                : AppColors.white,
            fontSize: 11.sp,
          ),
          onTap: () => widget.onSelectedItem(item),
        ),
      );
}

class MenuWidget extends StatelessWidget {
  const MenuWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          ZoomDrawer.of(context)!.toggle();
        },
        icon: CustomSvgImage(
          imageName: 'menu',
          height: 17.h,
          width: 15.w,
        ));
  }
}
