import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otlob/screens/allResturant/resturant_page/resutrant_page_p.dart';
import 'package:otlob/widget/continer_grid_favorite.dart';

import '../../../value/colors.dart';
import '../../../widget/app_style_text.dart';
import '../../server/controller/app_controller.dart';
import '../../widget/row_all.dart';
import '../../widget/waiting.dart';

class AllResurantScreen extends StatefulWidget {
  const AllResurantScreen({Key? key}) : super(key: key);

  @override
  State<AllResurantScreen> createState() => _AllResurantScreenState();
}

class _AllResurantScreenState extends State<AllResurantScreen> {
  AppController controller = Get.find();

  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('restaurant');

  getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    return allData;
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
    //     statusBarColor: AppColors.appColor
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
          child: ListView(
            shrinkWrap: true,
            // padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
            children: [
              RowAll(
                mainTitle: 'قائمة المطاعم',
                subTitle: 'تصفية حسب',
                onPressed: () {},
              ),
              SizedBox(
                height: 10.h,
              ),
              FutureBuilder(
                future: getData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    var data1 = snapshot.data as List;
                    var data = [];
                    for (var i = 0; i < data1.length; i++) {
                      if (data1[i]['images'].toString() != '[]') {
                        data += [data1[i]];
                      }
                    }
                    return GridView.builder(
                        gridDelegate:
                            (SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10.w,
                                crossAxisSpacing: 8.h)),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          bool visible1 = false;
                          var sum = int.parse(data[index]['pricingFrom']) +
                              int.parse(data[index]['pricingTo']);
                          var average = sum / 2;
                          return ContainerGridFavorite(
                            image: data[index]['images'][0],
                            mainTitle: data[index]['name'],
                            time: ' ' +
                                data[index]['workTimeFrom'] +
                                ' صباحاً الى ' +
                                data[index]['workTimeTo'] +
                                ' مساً',
                            rate: '5.0',
                            space: '5',
                            visible: visible1,
                            isFav: false,
                            price: average.toString(),
                            onPressed: () {
                              if (mounted) {
                                setState(() {});
                              }
                            },
                            onPressed2: () {
                              Get.to(ResturantPage(id: data[index]['uid']));
                            },
                          );
                        },
                        itemCount: data.length);
                  } else {
                    return Waiting();
                  }
                },
              ),
              SizedBox(
                height: 23.h,
              ),
            ],
          ),
        ),
      );
    });
  }
}

// class RowAll extends StatelessWidget {
//   String mainTitle;
//   String subTitle;
//
//   RowAll({required this.mainTitle, required this.subTitle});
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         AppTextStyle(
//           name: mainTitle,
//           color: AppColors.black,
//           fontSize: 9.sp,
//           isMarai: false,
//           fontWeight: FontWeight.w500,
//         ),
//         Spacer(),
//         Row(
//           children: [
//             AppTextStyle(
//               name: subTitle,
//               color: AppColors.black,
//               fontSize: 7.sp,
//               isMarai: false,
//               fontWeight: FontWeight.w500,
//             ),
//             SizedBox(
//               width: 5.w,
//             ),
//             CustomSvgImage(
//               imageName: 'Filter',
//               height: 14.h,
//               width: 13.w,
//             )
//           ],
//         ),
//       ],
//     );
//   }
// }
