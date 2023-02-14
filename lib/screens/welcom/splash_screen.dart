import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:otlob/screens/Auth/sing_in.dart';
import 'package:otlob/screens/main/main_screens/home.dart';
import 'package:otlob/screens/menu/Drawer.dart';
import 'package:otlob/server/controller/app_controller.dart';
import 'package:otlob/services/preferences/app_preferences.dart';
import 'package:otlob/value/colors.dart';
import 'package:otlob/value/constant.dart';
import 'package:otlob/widget/custom_image.dart';

import '../map_picker/map_picker.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  LocationData? _userLocation;
  AppController appController = Get.find();

  @override
  void dispose() {
    // // TODO: implement dispose
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
  void initState() {
    SVProgressHUD.dismiss();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ));
    // TODO: implement initState
    _getUserLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: AppColors.black.withOpacity(.5),
        body: Stack(
          children: [
            // CustomSvgImage(imageName: 'splash_backgroud',height: 50.h,),
            const CustomPngImage(
              imageName: 'img',
              height: double.infinity,
              width: double.infinity,
              boxFit: BoxFit.cover,
            ),
            Container(
              color: AppColors.black.withOpacity(.5),
              height: double.infinity,
              width: double.infinity,
            ),
            Center(
              child: CustomImageNetwork(
                // iconSize: 40.r,
                imageUrl: '${AppController.appData.value.appLogo}',
                height: 84.h,
                width: 99.w,
                // color: HexColor(AppController.hexColorPrimary.value),
              ),
            ),
          ],
        ),
      );
    });
  }

  Future<void> _getUserLocation() async {
    Location location = Location();
    // Check if location service is enable
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    String uid = AppPreferences().getUserDataAsMap()['uid'] == null
        ? ''
        : AppPreferences().getUserDataAsMap()['uid'];
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        final locationData = await location.getLocation();
        if (mounted) {
          setState(() {
            _userLocation = locationData;
            // AppPreferences().logOutUser();
            Future.delayed(const Duration(seconds: 1), () {
              if (uid.isNotEmpty) {
                Get.offAll(menu(currentItem: MenuItems.Home));
              } else {
                Get.offAll(() => MapPickerScreen(
                      isFromLaunch: true,
                      latLng: LatLng(
                          _userLocation!.latitude!, _userLocation!.longitude!),
                    ));
              }
            });
          });
        }
        return;
      }
    }

    final locationData = await location.getLocation();
    if (mounted) {
      setState(() {
        _userLocation = locationData;
        // AppPreferences().logOutUser();
        Future.delayed(const Duration(seconds: 1), () {
          if (uid.isNotEmpty) {
            Get.offAll(menu(currentItem: MenuItems.Home));
          } else {
            Get.offAll(() => MapPickerScreen(
                  isFromLaunch: true,
                  latLng: LatLng(
                      _userLocation!.latitude!, _userLocation!.longitude!),
                ));
          }
        });
      });
    }
  }
}
