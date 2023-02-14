import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otlob/screens/product/product_page.dart';
import 'package:otlob/widget/continer_grid_favorite.dart';

import '../../../value/colors.dart';
import '../../../widget/app_style_text.dart';
import '../../server/controller/app_controller.dart';
import '../../widget/row_all.dart';

class AllCategories extends StatefulWidget {
  const AllCategories({Key? key}) : super(key: key);

  @override
  State<AllCategories> createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories> {
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
          child: ListView(
            shrinkWrap: true,
            // padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
            children: [
              RowAll(
                mainTitle: 'أكثر طلبات السندوتشات',
                subTitle: 'تصفية حسب',
                onPressed: () {},
              ),
              SizedBox(
                height: 10.h,
              ),
              GridView.builder(
                  gridDelegate: (SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10.w,
                      crossAxisSpacing: 13.h)),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    // bool visible = true;
                    // if (index % 2 != 0) {
                    //   visible = false;
                    // } else {
                    //   visible = true;
                    // }
                    return ContainerGridFavorite(
                      image:
                          'https://imageproxy.wolt.com/venue/61df2174fe36363051389253/b82ecff6-779c-11ec-94ff-8e18657bb6b1___burger_brothers_close_up_1.jpg',
                      mainTitle: 'تامبا كريب',
                      time: '25 - 30',
                      rate: '5.0',
                      space: '5 ',
                      price: '19',
                      onPressed: () {},
                      visible: false,
                      onPressed2: () {
                        // Get.to(const ProductPage());
                      },
                    );
                  },
                  itemCount: 10),
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
