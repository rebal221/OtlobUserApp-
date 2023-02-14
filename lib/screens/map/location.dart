// // ignore_for_file: depend_on_referenced_packages
//
// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:otlob/value/colors.dart';
// import 'package:otlob/widget/card_template_black.dart';
// import 'package:pinput/pinput.dart';
//
// import '../../widget/app_button.dart';
// import '../Auth/sing_in.dart';
//
// class Location extends StatefulWidget {
//   const Location({Key? key}) : super(key: key);
//
//   @override
//   State<Location> createState() => _LocationState();
// }
//
// class _LocationState extends State<Location> {
//   late StreamController<LocationMarkerPosition> positionStream;
//   late StreamSubscription<LocationMarkerPosition> streamSubscription;
//
//   void onTapRecognizer() {
//     Navigator.push(
//         context, MaterialPageRoute(builder: (context) => const SignIn()));
//   }
//
//   static const distanceFilters = [0, 5, 10, 30, 50];
//   int _selectedIndex = 0;
//
//   // Completer<GoogleMapController> _controller = Completer();
//
//   // static final CameraPosition _kGooglePlex = CameraPosition(
//   //   target: LatLng(37.42796133580664, -122.085749655962),
//   //   zoom: 14.4746,
//   // );
//
//   // Set<Circle> circles = Set.from([Circle(
//   //   circleId: CircleId('1'),
//   //     fillColor: AppColors.appColor,
//   //   center: LatLng(37.43296265331129, -122.08832357078792),
//   //   radius: 4000,
//   //
//   // )]);
//   LatLng latLng = LatLng(31.517788514377553, 34.449811004646946);
//
//   // static final CameraPosition _kLake = CameraPosition(
//   //     bearing: 192.8334901395799,
//   //     target: LatLng(37.43296265331129, -122.08832357078792),
//   //     tilt: 59.440717697143555,
//   //     zoom: 19.151926040649414);
//   final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
//   late String _verificationCode;
//   final TextEditingController _pinPutController = TextEditingController();
//   final FocusNode _pinPutFocusNode = FocusNode();
//   final defaultPinTheme = PinTheme(
//     width: 51.w,
//     height: 51.h,
//     textStyle: const TextStyle(
//         fontSize: 20, color: AppColors.greyF, fontWeight: FontWeight.w600),
//     decoration: BoxDecoration(
//       color: AppColors.greyF,
//       borderRadius: BorderRadius.circular(10.0),
//       border: Border.all(
//         color: AppColors.greyF,
//       ),
//     ),
//   );
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     SystemChrome.setSystemUIOverlayStyle(
//         const SystemUiOverlayStyle(statusBarColor: AppColors.appColor));
//     positionStream = StreamController();
//     // _subscriptPositionStream();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     positionStream.close();
//
//     // TODO: implement dispose
//     SystemChrome.setSystemUIOverlayStyle(
//         const SystemUiOverlayStyle(statusBarColor: AppColors.appColor));
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//     //     statusBarColor: AppColors.appColor
//     // ));
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       backgroundColor: AppColors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         // shape: RoundedRectangleBorder(
//         //     borderRadius: BorderRadius.only(
//         //         bottomLeft: Radius.circular(10.r),
//         //         bottomRight: Radius.circular(10.r))),
//         // backgroundColor: AppColors.appColor,
//         // leadingWidth: 100.w,
//         // leading: TextButton.icon(
//         //     onPressed: () {
//         //       Get.back();
//         //     },
//         //     icon: Icon(
//         //       Icons.keyboard_arrow_right,
//         //       color: Colors.white,
//         //       size: 25.r,
//         //     ),
//         //     label: AppTextStyle(
//         //       name: 'رجوع',
//         //       fontSize: 10.sp,
//         //     )),
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 0.w),
//         child: Stack(
//           // crossAxisAlignment: CrossAxisAlignment.start,
//           // padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
//           children: [
//             SizedBox(
//               child: FlutterMap(
//                 options: MapOptions(
//                   center: latLng,
//                   zoom: 18,
//                   maxZoom: 26,
//                   plugins: [
//                     const LocationMarkerPlugin(), // <-- add plugin here
//                   ],
//                 ),
//                 layers: [
//                   TileLayerOptions(
//                     urlTemplate:
//                         'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
//                     subdomains: ['a', 'b', 'c'],
//                     userAgentPackageName:
//                         'net.tlserver6y.flutter_map_location_marker.example',
//                   ),
//                   LocationMarkerLayerOptions(
//                     positionStream: positionStream.stream,
//                     marker: const DefaultLocationMarker(
//                       color: Colors.green,
//                       child: Icon(
//                         Icons.person,
//                         color: Colors.white,
//                       ),
//                     ),
//                     markerSize: const Size(40, 40),
//                     accuracyCircleColor: Colors.green.withOpacity(0.1),
//                     headingSectorColor: Colors.green.withOpacity(0.8),
//                     headingSectorRadius: 120,
//                     moveAnimationDuration: Duration.zero,
//                   ),
//                   // Align(
//                   //     alignment: Alignment.bottomCenter,
//                   //     child: Container(
//                   //       color: Theme.of(context).scaffoldBackgroundColor,
//                   //       padding: const EdgeInsets.all(8),
//                   //       child: Row(
//                   //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   //         children: [
//                   //           const Text("Distance Filter:"),
//                   //           ToggleButtons(
//                   //             isSelected: List.generate(
//                   //               distanceFilters.length,
//                   //               (index) => index == _selectedIndex,
//                   //               growable: false,
//                   //             ),
//                   //             onPressed: (index) {
//                   //               setState(() => _selectedIndex = index);
//                   //               streamSubscription.cancel();
//                   //               _subscriptPositionStream();
//                   //             },
//                   //             children: distanceFilters
//                   //                 .map(
//                   //                     (distance) => Text(distance.toString()))
//                   //                 .toList(growable: false),
//                   //           ),
//                   //         ],
//                   //       ),
//                   //     ))
//                 ],
//               ),
//               // children: [
//               //   TileLayerWidget(
//               //     options: TileLayerOptions(
//               //       urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
//               //       subdomains: ['a', 'b', 'c'],
//               //     ),
//               //   ),
//               //   LocationMarkerLayerWidget(), // <-- add layer widget here
//               // ],
//             ),
//
//             // SizedBox(
//             //   height: 20.h,
//             // ),
//             // RowEditSvg(
//             //     enable: false,
//             //     title: '25 شارع عبدالسلام النابلسي، الصفة الغربية',
//             //     hint: '25 شارع عبدالسلام النابلسي، الصفة الغربية'),
//             // Spacer(),
//             // SizedBox(
//             //   height: 20.h,
//             // ),
//             Positioned(
//               top: 20.h,
//               bottom: 20.h,
//               left: 24.w,
//               right: 24.w,
//               child: Column(
//                 children: [
//                   AppButton(
//                     title: 'من فضلك اختر مكان التوصيل',
//                     onPressed: () {},
//                     color: AppColors.black.withOpacity(.1),
//                     fontSize: 13.sp,
//                     height: 41.h,
//                   ),
//                   const Spacer(),
//                   CardTemplateBlack(
//                       prefix: 'maps',
//                       title: '25 شارع عبدالسلام النابلسي، الصفة الغربية',
//                       colorFont: AppColors.black,
//                       controller: TextEditingController()),
//                   SizedBox(
//                     height: 20.h,
//                   ),
//                   AppButton(
//                       title: ' التالي',
//                       onPressed: () {
//                         Get.to(const SignIn());
//                       }),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//   //
//   // void _subscriptPositionStream() {
//   //   streamSubscription = const LocationMarkerDataStreamFactory()
//   //       .geolocatorPositionStream(
//   //     stream: Geolocator.getPositionStream(
//   //       locationSettings: LocationSettings(
//   //         distanceFilter: distanceFilters[_selectedIndex],
//   //       ),
//   //     ),
//   //   )
//   //       .listen(
//   //     (position) {
//   //       positionStream.add(position);
//   //     },
//   //   );
//   // }
// }
