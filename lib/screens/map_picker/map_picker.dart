// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:geocoding/geocoding.dart' as gecoding;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:location/location.dart';
import 'package:map_picker/map_picker.dart';
import 'package:otlob/screens/menu/Drawer.dart';
import 'package:otlob/server/firebase_store.dart';
import 'package:otlob/services/preferences/app_preferences.dart';
import 'package:otlob/value/colors.dart';
import 'package:otlob/value/constant.dart';
import 'package:otlob/widget/card_template_black.dart';

import '../../server/controller/app_controller.dart';
import '../../widget/app_button.dart';
import '../Auth/sing_in.dart';

class MapPickerScreen extends StatefulWidget {
  LatLng latLng;
  bool isFromLaunch;

  MapPickerScreen({super.key, required this.latLng, this.isFromLaunch = false});

  @override
  MapPickerScreenState createState() => MapPickerScreenState();
}

class MapPickerScreenState extends State<MapPickerScreen> {
  final _controller = Completer<GoogleMapController>();
  MapPickerController mapPickerController = MapPickerController();
  late LatLng currentPostion;

  late CameraPosition cameraPosition;

  var textController = TextEditingController();
  AppController appController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    cameraPosition = CameraPosition(
      target: LatLng(widget.latLng.latitude, widget.latLng.longitude),
      zoom: 14.4746,
    );
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            MapPicker(
              // pass icon widget
              iconWidget: SvgPicture.asset(
                "images/location_icon.svg",
                height: 60,
              ),
              //add map picker controller
              mapPickerController: mapPickerController,
              child: GoogleMap(
                myLocationEnabled: true,
                zoomControlsEnabled: false,
                // hide location button
                myLocationButtonEnabled: false,
                mapType: MapType.normal,
                //  camera position
                initialCameraPosition: cameraPosition,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                onCameraMoveStarted: () {
                  // notify map is moving
                  mapPickerController.mapMoving!();
                  textController.text = "جاري تحديث الموقع ...";
                },
                onCameraMove: (cameraPosition) {
                  this.cameraPosition = cameraPosition;
                },
                onCameraIdle: () async {
                  // notify map stopped moving
                  mapPickerController.mapFinishedMoving!();
                  //get address name from camera position
                  List<gecoding.Placemark> placemarks =
                      await gecoding.placemarkFromCoordinates(
                    cameraPosition.target.latitude,
                    cameraPosition.target.longitude,
                  );

                  // update the ui with the address
                  textController.text =
                      '${placemarks.first.name}, ${placemarks.first.administrativeArea}, ${placemarks.first.country}';
                },
              ),
            ),
            Positioned(
              top: 35.h,
              bottom: 20.h,
              left: 24.w,
              right: 24.w,
              child: Column(
                children: [
                  AppButton(
                    title: 'من فضلك اختر مكان التوصيل',
                    onPressed: () {},
                    color: AppColors.black.withOpacity(.1),
                    fontSize: 13.sp,
                    height: 41.h,
                  ),
                  const Spacer(),
                  CardTemplateBlack(
                      prefix: 'maps',
                      enable: true,
                      title: 'العنوان',
                      colorFont: AppColors.black,
                      controller: textController),
                  SizedBox(
                    height: 20.h,
                  ),
                  AppButton(
                    color: HexColor(AppController.hexColorPrimary.value),
                    title: ' التالي',
                    onPressed: () async {
                      // AppPreferences().clearKey('logged_in');
                      await nextStep();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Future<void> nextStep() async {
    log("Location ${cameraPosition.target.latitude} ${cameraPosition.target.longitude}");
    log("Address: ${textController.text}");
    AppPreferences()
        .setData(key: 'lat', value: cameraPosition.target.latitude.toString());
    AppPreferences().setData(
        key: 'long', value: cameraPosition.target.longitude.toString());
    log('loggedIn ==>>  ${AppPreferences().loggedIn}');
    if (widget.isFromLaunch) {
      if (AppPreferences().loggedIn) {
        SVProgressHUD.show();

        //ToDo:here update last seen and current user location;
        String uid = AppPreferences().getUserDataAsMap()['uid'] == null
            ? ''
            : AppPreferences().getUserDataAsMap()['uid'];
        await uid == ''
            ? ''
            : FirebaseFirestoreController().getUserDataFromFirestore(uid: uid);
        //ToDo:update current location
        bool activeAccount = uid == ''
            ? false
            : AppPreferences().getUserDataAsMap()['isActiveAccount'];
        if (activeAccount) {
          await FirebaseFirestoreController().updateFirestore(
              doc: uid,
              key: 'currentLocation',
              value: GeoPoint(
                  double.parse(AppPreferences().getData(key: 'lat')),
                  double.parse(AppPreferences().getData(key: 'long'))),
              collectionName: 'users');
          //ToDo: update last seen ;
          await FirebaseFirestoreController().updateFirestore(
              doc: uid,
              key: 'lastSeen',
              value: DateTime.now(),
              collectionName: 'users');
          SVProgressHUD.dismiss();

          Get.offAll(menu(currentItem: MenuItems.Home));
        } else {
          SVProgressHUD.dismiss();
          Get.to(const SignIn());
          AppPreferences().logOutUser();
        }
      } else {
        Get.to(const SignIn());
      }
    } else {
      Get.back();
    }
  }

// Future<void> _getUserLocation() async {
//   LocationPermission permission;
//   Position position;
//   permission = await Geolocator.requestPermission();
//   debugPrint(permission.toString());
//   if (await Geolocator.isLocationServiceEnabled()) {
//     position = await Geolocator.getCurrentPosition();
//     if (!position.longitude.isNaN) {
//       if (mounted) {
//         setState(() {
//           currentPostion = LatLng(position.latitude, position.longitude);
//         });
//       }
//     }
//   } else {
//     position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//     if (!position.longitude.isNaN) {
//       if (mounted) {
//         setState(() {
//           currentPostion = LatLng(position.latitude, position.longitude);
//         });
//       }
//     }
//   }
//   cameraPosition = CameraPosition(
//     target: currentPostion,
//     zoom: 14.4746,
//   );
// }

}
