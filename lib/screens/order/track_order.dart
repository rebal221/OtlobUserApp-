import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otlob/value/colors.dart';
import 'package:otlob/widget/app_style_text.dart';

import '../../server/controller/app_controller.dart';
import '../../widget/list_tile.dart';
import '../Auth/sing_in.dart';

class TrackOrder extends StatefulWidget {
  TrackOrder({Key? key, required this.orderID}) : super(key: key);
  final String orderID;
  @override
  State<TrackOrder> createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {
  void onTapRecognizer() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SignIn()));
  }

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
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                bool doneActive = false;
                bool sentOrderActive = false;

                sentOrderActive = snapshot.data!.docs[0]['myOrders']
                            [widget.orderID]['orderStatus'] ==
                        'driver'
                    ? true
                    : false;
                doneActive = snapshot.data!.docs[0]['myOrders'][widget.orderID]
                            ['orderStatus'] ==
                        'done'
                    ? true
                    : false;
                Timestamp orderTime = snapshot.data!.docs[0]['myOrders']
                    [widget.orderID]['orderTime'];
                Timestamp orderTimeLastUpdate = snapshot.data!.docs[0]
                    ['myOrders'][widget.orderID]['orderTimeLastUpdate'];
                DateTime q = orderTime.toDate();
                DateTime p = orderTimeLastUpdate.toDate();
                return ListView(
                  shrinkWrap: true,
                  // mainAxisSize: MainAxisSize.min,

                  // mainAxisAlignment: MainAxisAlignment.center,
                  // padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
                  children: [
                    SizedBox(
                      height: 30.h,
                    ),
                    ListTileClass(
                        isFirst: snapshot.data!.docs[0]['myOrders']
                                    [widget.orderID]['orderStatus'] !=
                                'paid'
                            ? true
                            : false,
                        title: 'تم ارسال الطلب',
                        subTitle: q.toString(),
                        trailing: '5.00 صباحًا'),
                    ListTileClass(
                        title: 'تم دفع الطلب',
                        subTitle: p.toString(),
                        trailing: '5.00 صباحًا'),
                    ListTileClass(
                        title: 'تم استلام الطلب في المطعم',
                        subTitle: p.toString(),
                        trailing: '5.00 صباحًا'),
                    ListTileClass(
                        disable: snapshot.data!.docs[0]['myOrders']
                                    [widget.orderID]['orderStatus'] !=
                                'driver'
                            ? true
                            : false,
                        title: 'المندوب في الطريق إليك',
                        subTitle: p.toString(),
                        trailing: '5.00 صباحًا'),
                    ListTileClass(
                        disable: snapshot.data!.docs[0]['myOrders']
                                    [widget.orderID]['orderStatus'] !=
                                'done'
                            ? true
                            : false,
                        isLast: true,
                        title: 'تم التسليم',
                        subTitle: '',
                        trailing: '5.00 صباحًا'),
                  ],
                );
              } else {
                return Text("No data");
              }
            },
          ),
        ),
      );
    });
  }
}
