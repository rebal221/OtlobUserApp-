import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firestore_search/firestore_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otlob/screens/allResturant/all_resturant.dart';
import 'package:otlob/screens/allResturant/resturant_page/resutrant_page_p.dart';
import 'package:otlob/screens/categories/all_categories.dart';
import 'package:otlob/screens/main/main_screens/offer_screen.dart';
import 'package:otlob/screens/product/product_page.dart';
import 'package:otlob/services/preferences/app_preferences.dart';
import 'package:otlob/widget/continer_grid_favorite.dart';
import 'package:otlob/widget/row_svg.dart';
import 'package:shimmer/shimmer.dart';
import '../../../server/controller/app_controller.dart';
import '../../../value/colors.dart';
import '../../../widget/app_style_text.dart';
import '../../../widget/app_text_field_search.dart';
import '../../../widget/button_column.dart';
import '../../../widget/component.dart';
import '../../../widget/custom_image.dart';
import '../../../widget/row_all.dart';
import '../../../widget/row_icon.dart';
import '../../../widget/waiting.dart';
import '../../menu/Drawer.dart';
import 'resturant_category.dart';
// import '../../sing_in.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
    getCurrentLocation();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title!),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body!)],
                  ),
                ),
              );
            });
      }
    });
    Timer(Duration(milliseconds: 1000), () {
      setState(() {});
    });
  }

  int _counter = 0;
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

  CollectionReference _collection =
      FirebaseFirestore.instance.collection('restaurant');

  // ignore: prefer_final_fields
  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('meals');

  // ignore: prefer_final_fields
  CollectionReference _Offers = FirebaseFirestore.instance.collection('offers');

  getDatarestaurant() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collection.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    return allData;
  }

  final fcmToken = FirebaseMessaging.instance.getToken();
  var visible = false;

  getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    return allData;
  }

  getoffer() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _Offers.get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  String messageTitle = "Empty";
  String notificationAlert = "alert";

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  // Initial Selected Value
  String dropdownvalue = 'Item 1';

  // List of items in our dropdown menu
  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];
  final Completer<GoogleMapController> _controller = Completer();
  void getCurrentLocation() async {
    Location location = Location();
    location.getLocation().then(
      (location) {
        currentLocation = location;
      },
    );

    GoogleMapController googleMapController = await _controller.future;
    location.onLocationChanged.listen(
      (newLoc) {
        currentLocation = newLoc;
        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: 13.5,
              target: LatLng(
                newLoc.latitude!,
                newLoc.longitude!,
              ),
            ),
          ),
        );
        setState(() {});
      },
    );
  }

  // void showNotification(String title, String des) {
  //   setState(() {
  //     _counter++;showNotification('تم اضافة وجبة جديدة', '');
  //   });
  //   flutterLocalNotificationsPlugin.show(
  //       0,
  //       "$title",
  //       "$des",
  //       NotificationDetails(
  //           android: AndroidNotificationDetails(channel.id, channel.name,
  //               channelDescription: channel.description,
  //               importance: Importance.high,
  //               color: HexColor(AppController.hexColorPrimary.value),
  //               playSound: true,
  //               icon: '@mipmap/ic_launcher')));
  // }

  String? searchKey;
  Stream? streamQuery;
  GeoPoint? pos;
  LocationData? currentLocation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        toolbarHeight: 70,
        // leading: MenuWidget(),
        actions: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 20.w,
                    ),
                    Container(
                      height: 50.h,
                      width: 50.w,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          shape: BoxShape.circle,
                          color: Colors.white),
                      child: SizedBox(
                        height: 18.h,
                        width: 18.w,
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(shape: BoxShape.circle

                              // shape: RoundedRectangleBorder(
                              //   borderRadius: BorderRadius.circular(8.r),
                              ),
                          child: CachedNetworkImage(
                            imageUrl:
                                AppPreferences().getUserDataAsMap()['image'],
                            // height: 72.h,
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
                      ),
                    ),
                    SizedBox(
                      width: 6.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppTextStyle(
                          name:
                              'مرحباً، ${AppPreferences().getUserDataAsMap()['name']}',
                          fontWeight: FontWeight.w900,
                          fontSize: 10.sp,
                        ),
                        SizedBox(
                          height: 6.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomSvgImage(
                              imageName: 'maps',
                              color: AppColors.white,
                              height: 12.h,
                              width: 7.w,
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            Container(
                              width: 210.w,
                              height: 20,
                              child: AppTextStyle(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                                name:
                                    '${AppPreferences().getUserDataAsMap()['adderss']} ، ${AppPreferences().getUserDataAsMap()['city']}',
                                fontSize: 10.sp,
                                isMarai: false,

                                color: AppColors.white,

                                // fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(
                              width: 3.w,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: const [
                    MenuWidget(),
                  ],
                )
              ],
            ),
          ),
        ],
        backgroundColor: HexColor(AppController.hexColorPrimary.value),
        title: Text(''.tr),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(vertical: 0.h),
        children: [
          SearchBar(),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
            children: [
              SizedBox(
                height: 10.h,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('category')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SizedBox(
                      height: 150.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          bool visible = true;
                          if (index % 2 != 0) {
                            visible = false;
                          } else {
                            visible = true;
                          }
                          var data = snapshot.data!.docs[index].data() as Map;
                          return InkWell(
                            onTap: () {
                              Get.to(AllResurantScreen_Category(
                                cat_id: data['uid'],
                              ));
                            },
                            child: SizedBox(
                              height: 80.h,
                              child: Container(
                                height: 100.h,
                                width: 100.w,
                                decoration: BoxDecoration(
                                    color: HexColor(
                                        AppController.hexColorPrimary.value),
                                    borderRadius: BorderRadius.circular(10.r)),
                                child: Stack(
                                  children: [
                                    PositionedDirectional(
                                      top: 0,
                                      end: 0,
                                      start: 0,
                                      bottom: 0,
                                      child: Align(
                                        alignment: AlignmentDirectional.center,
                                        child: SizedBox(
                                          height: 149.h,
                                          width: 99.w,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(10),
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                                bottomLeft:
                                                    Radius.circular(10)),
                                            child: Image.network(
                                              data['image'],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: AlignmentDirectional.topEnd,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: SizedBox(
                                          height: 23.h,
                                          width: 100.w,
                                          child: Align(
                                            alignment:
                                                AlignmentDirectional.topCenter,
                                            child: AppTextStyle(
                                              name: data['name'],
                                              color: AppColors.white,
                                              fontSize: 15,
                                              isMarai: false,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: snapshot.data!.docs.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            width: 7.h,
                          );
                        },
                      ),
                    );
                  } else {
                    return Align(
                      alignment: Alignment.center,
                      child: SpinKitFadingCircle(
                        color: HexColor('#DBD6D6'),
                        size: 40.0,
                      ),
                    );
                  }
                },
              ),
              SizedBox(
                height: 23.h,
              ),
              RowAll(
                mainTitle: 'المطاعم القريبة منك',
                subTitle: 'شاهد الكل',
                onPressed: () {
                  Get.to(const AllResurantScreen());
                },
              ),
              SizedBox(
                height: 10.h,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('restaurant')
                    .snapshots(),
                builder: (context, snapshot) {
                  var data1 = (snapshot.data!.docs == null
                      ? []
                      : snapshot.data!.docs as List);
                  var data = [];
                  for (var i = 0; i < data1.length; i++) {
                    if (data1[i]['images'].toString() != '[]') {
                      data += [data1[i]];
                    }
                  }
                  if (snapshot.hasData) {
                    return GridView.builder(
                        gridDelegate:
                            (SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10.w,
                                crossAxisSpacing: 13.h)),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          pos = data[index]['latLong'] == null
                              ? ''
                              : data[index]['latLong'];
                          var distanc = calculateDistance(
                              currentLocation!.latitude!,
                              currentLocation!.longitude!,
                              pos!.latitude,
                              pos!.longitude);
                          var sum = int.parse(data[index]['pricingFrom']) +
                              int.parse(data[index]['pricingTo']);
                          var average = sum / 2;

                          return ContainerGridFavorite(
                            image: data[index]['images'][2],
                            mainTitle: data[index]['name'],
                            time: ' ' +
                                data[index]['workTimeFrom'] +
                                ' صباحاً الى ' +
                                data[index]['workTimeTo'] +
                                ' مساً',
                            rate: '5.0',
                            space: '${(distanc / 100).toStringAsFixed(1)}',
                            price: average.toStringAsFixed(0),
                            onPressed: () {},
                            visible: visible,
                            onPressed2: () {
                              Get.to(ResturantPage(id: data[index]['uid']));
                            },
                          );
                        },
                        itemCount: data.length < 4 ? data.length : 4);
                  } else {
                    return Waiting();
                  }
                },
              ),
              SizedBox(
                height: 23.h,
              ),
              RowAll(
                mainTitle: 'أخر العروض',
                subTitle: 'شاهد الكل',
                onPressed: () {
                  Get.to(const OfferScreen());
                },
              ),
              SizedBox(
                height: 8.h,
              ),
              StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('offers').snapshots(),
                builder: (context, snapshot) {
                  var data = (snapshot.data!.docs == null
                      ? []
                      : snapshot.data!.docs as List);
                  if (data.isNotEmpty) {
                    return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          bool visible = true;
                          return GestureDetector(
                            onTap: () {
                              Get.to(ProductPage(
                                id: data[index]['mealID'],
                              ));
                            },
                            child: Container(
                              height: 170.h,
                              decoration: BoxDecoration(
                                  color: AppColors.greyF8,
                                  borderRadius: BorderRadius.circular(8.r)),
                              child: Column(
                                children: [
                                  Container(
                                    height: 122.h,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.r)),
                                    child: Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                          ),
                                          clipBehavior: Clip.antiAlias,
                                          child: CachedNetworkImage(
                                            imageUrl: (data[index]
                                                        ['offerImage'] ==
                                                    null
                                                ? ''
                                                : data[index]['offerImage']),
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
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5.w, vertical: 9.h),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ButtonColumn(
                                                  mainTitle: (data[index]
                                                              ['offerType'] ==
                                                          null
                                                      ? ''
                                                      : data[index]
                                                          ['offerType']),
                                                  subTitle: 'لفترة محدودة'),
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
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.w),
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
                                              height: 28.h,
                                              width: 28.w,
                                              child: Container(
                                                clipBehavior: Clip.antiAlias,
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle

                                                    // shape: RoundedRectangleBorder(
                                                    //   borderRadius: BorderRadius.circular(8.r),
                                                    ),
                                                child: CachedNetworkImage(
                                                  imageUrl: (data[index]
                                                              ['offerImage'] ==
                                                          null
                                                      ? ''
                                                      : data[index]
                                                          ['offerImage']),
                                                  // height: 72.h,
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
                                                name: (data[index]
                                                                ['offerName'] ==
                                                            null
                                                        ? ''
                                                        : data[index]
                                                            ['offerName'])
                                                    .toString(),
                                                fontSize: 9.sp,
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
                                                  SizedBox(
                                                    width: 10.w,
                                                  ),
                                                  RowIcon(
                                                      title:
                                                          ' 30 تقريباً دقيقة',
                                                      iconData: Icons
                                                          .access_time_filled_rounded,
                                                      color: AppColors.black),
                                                  SizedBox(
                                                    width: 10.w,
                                                  ),
                                                  RowSvg(
                                                    title: (data[index][
                                                                    'restaurantAddress'] ==
                                                                null
                                                            ? ''
                                                            : data[index][
                                                                'restaurantAddress'])
                                                        .toString(),
                                                    image: 'maps',
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          SizedBox(
                                            height: 40.h,
                                            child: Card(
                                              color: HexColor(AppController
                                                  .hexColorPrimary.value),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                              ),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0, right: 8),
                                                  child: AppTextStyle(
                                                    textAlign: TextAlign.center,
                                                    name: data[index]
                                                        ['offerValue'],
                                                    fontSize: 10.sp,
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
                                      ))
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            height: 28.h,
                          );
                        },
                        itemCount: data.length < 3 ? data.length : 3);
                  } else {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 30.h,
                      alignment: Alignment.center,
                      child: AppTextStyle(
                        name: 'لا يوجد عروض ',
                        color: Colors.black87,
                        fontSize: 15.sp,
                      ),
                    );
                  }
                },
              ),
              SizedBox(
                height: 10.h,
              ),
            ],
          ),
        ],
      ),
    );
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}

class DataModel {
  final String? name;
  final String? developer;
  final String? framework;
  final String? tool;

  DataModel({this.name, this.developer, this.framework, this.tool});

  //Create a method to convert QuerySnapshot from Cloud Firestore to a list of objects of this DataModel
  //This function in essential to the working of FirestoreSearchScaffold

  List<DataModel> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> dataMap =
          snapshot.data() as Map<String, dynamic>;

      return DataModel(
          name: dataMap['name'],
          developer: dataMap['developer'],
          framework: dataMap['framework'],
          tool: dataMap['tool']);
    }).toList();
  }
}

Widget shimmerCarDesA(BuildContext context) {
  return Shimmer.fromColors(
    baseColor: HexColor(AppController.hexColorPrimary.value),
    highlightColor: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(0)),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      ),
    ),
  );
}

extension ColorExtension on String {
  toColor() {
    var hexColor = this.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

TextEditingController _search = TextEditingController();
var streamQuery;
var streamQuerytow;

class _SearchBarState extends State<SearchBar> {
  String searchValue = '';
  final List<String> _suggestions = [
    'Afeganistan',
    'Albania',
    'Algeria',
    'Australia',
    'Brazil',
    'German',
    'Madagascar',
    'Mozambique',
    'Portugal',
    'Zambia'
  ];

  Future<List<String>> _fetchSuggestions(String searchValue) async {
    await Future.delayed(const Duration(milliseconds: 750));

    return _suggestions.where((element) {
      return element.toLowerCase().contains(searchValue.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          height: 50.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12.r),
                  bottomRight: Radius.circular(12.r)),
              color: HexColor(AppController.hexColorPrimary.value)),
          child: Center(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(38.r),
                  color: AppColors.white,
                  border: Border.all(color: AppColors.white),
                ),
                height: 36.h,
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchValue = value;
                      streamQuery = FirebaseFirestore.instance
                          .collection('meals')
                          .where('mealName',
                              isGreaterThanOrEqualTo: searchValue)
                          .snapshots();
                      streamQuerytow = FirebaseFirestore.instance
                          .collection('restaurant')
                          .where('name', isGreaterThanOrEqualTo: searchValue)
                          .snapshots();
                    });
                  },
                  controller: _search,
                  cursorColor: HexColor(AppController.hexColorPrimary.value),
                  decoration: InputDecoration(
                    hintText: 'بحث ....',
                    suffixIcon: InkWell(
                      onTap: () {
                        // Get.to(const SearchResult());
                      },
                      child: InkWell(
                        onTap: () {
                          _search.text = '';
                          searchValue.isNotEmpty ? (searchValue = '') : ([]);
                          setState(() {});
                        },
                        child: Icon(
                          searchValue.isNotEmpty ? Icons.close : Icons.search,
                          color: HexColor(AppController.hexColorSecond.value),
                        ),
                      ),
                    ),
                    labelStyle: GoogleFonts.cairo(
                      color: AppColors.black,
                      // letterSpacing: letterSpacing,
                      // wordSpacing: wordSpacing,
                      fontWeight: FontWeight.w400,
                      fontSize: 10.sp,
                      // decoration: TextDeo,
                      // height: height
                    ),
                    counterText: '',
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintStyle: GoogleFonts.cairo(
                        color: AppColors.black,
                        // letterSpacing: letterSpacing,
                        // wordSpacing: wordSpacing,
                        fontWeight: FontWeight.w400,
                        fontSize: 10.sp,
                        height: 0.5
                        // decoration: TextDeo,
                        // height: height
                        ),
                  ),
                )),
          ),
        ),
        searchValue.isNotEmpty
            ? StreamBuilder<QuerySnapshot>(
                stream: streamQuery,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List e = snapshot.data!.docs.map((e) => e.data()).toList()
                        as List;
                    return e.isNotEmpty
                        ? Container(
                            width: MediaQuery.of(context).size.width - 40,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10))),
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      Get.to(ProductPage(id: e[index]['uid']));
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 90,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              40,
                                          child: Row(children: [
                                            SizedBox(
                                              height: 60.h,
                                              width: 60.w,
                                              child: Container(
                                                clipBehavior: Clip.antiAlias,
                                                decoration:
                                                    const BoxDecoration(),
                                                child: CachedNetworkImage(
                                                  imageUrl: e[index]
                                                      ['mealImages'][0],
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
                                            ),
                                            SizedBox(width: 10),
                                            Container(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  AppTextStyle(
                                                    name: e[index]['mealName'],
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14,
                                                  ),
                                                  SizedBox(height: 7),
                                                  Container(
                                                    child: AppTextStyle(
                                                      name: e[index]
                                                          ['mealDescription'],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      color: Colors.black45,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                  SizedBox(height: 7),
                                                  AppTextStyle(
                                                    name: e[index]
                                                        ['restaurantName'],
                                                    color: Colors.black45,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 8,
                                                  )
                                                ],
                                              ),
                                            )
                                          ]),
                                        ),
                                        Container(
                                          height: 0.5,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              60,
                                          color: Colors.black38,
                                        ),
                                        SizedBox(
                                          height: 6,
                                        )
                                      ],
                                    ),
                                  );
                                },
                                itemCount: e.length),
                          )
                        : Text('');
                  } else {
                    return Text("");
                  }
                },
              )
            : Container(),
        searchValue.isNotEmpty
            ? StreamBuilder<QuerySnapshot>(
                stream: streamQuerytow,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List e = snapshot.data!.docs.map((e) => e.data()).toList()
                        as List;
                    print(e);
                    return e.isNotEmpty
                        ? Container(
                            width: MediaQuery.of(context).size.width - 40,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10))),
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      Get.to(
                                          ResturantPage(id: e[index]['uid']));
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 90,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              40,
                                          child: Row(children: [
                                            SizedBox(
                                              height: 60.h,
                                              width: 60.w,
                                              child: Container(
                                                clipBehavior: Clip.antiAlias,
                                                decoration:
                                                    const BoxDecoration(),
                                                child: CachedNetworkImage(
                                                  imageUrl: e[index]['images']
                                                      [0],
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
                                            ),
                                            SizedBox(width: 10),
                                            Container(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  AppTextStyle(
                                                    name: e[index]['name'],
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14,
                                                  ),
                                                  SizedBox(height: 7),
                                                  Container(
                                                    width: 250,
                                                    height: 20,
                                                    child: AppTextStyle(
                                                      name: e[index][
                                                          'restaurantDescription'],
                                                      color: Colors.black45,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                  SizedBox(height: 7),
                                                ],
                                              ),
                                            )
                                          ]),
                                        ),
                                        Container(
                                          height: 0.5,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              60,
                                          color: Colors.black38,
                                        ),
                                        SizedBox(
                                          height: 6,
                                        )
                                      ],
                                    ),
                                  );
                                },
                                itemCount: e.length),
                          )
                        : Container();
                  } else {
                    return Text("");
                  }
                },
              )
            : Container(),
      ],
    );
  }
}
