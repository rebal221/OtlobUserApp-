// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otlob/screens/allResturant/resturant_page/resutrant_page_p.dart';
import 'package:otlob/screens/main/main_screens/offer_screen.dart';
import 'package:otlob/screens/product/product_page.dart';
import 'package:otlob/widget/button_column.dart';
import 'package:otlob/widget/row_icon.dart';
import 'package:otlob/widget/row_svg.dart';

import '../../../server/controller/app_controller.dart';
import '../../../value/colors.dart';
import '../../../widget/app_style_text.dart';
import '../../../widget/app_text_field_search.dart';
import '../../../widget/component.dart';
import '../../../widget/continer_grid.dart';
import '../../../widget/row_all.dart';
import '../../allResturant/all_resturant.dart';

class SearchResult extends StatefulWidget {
  const SearchResult({Key? key}) : super(key: key);

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
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
              Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: AppColors.white,
                    border: Border.all(color: AppColors.greyC),
                  ),
                  height: 33.h,
                  child: AppTextFieldSearch(
                      hint: 'نتيجة البحث عن وجبات سريعة',
                      controller: TextEditingController())),
              SizedBox(
                height: 10.h,
              ),
              RowAll(
                mainTitle: 'الوجبات السريعة',
                subTitle: 'شاهد الكل',
                onPressed: () {
                  Get.to(const OfferScreen());
                },
              ),
              SizedBox(
                height: 8.h,
              ),
              ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    bool visible = true;
                    if (index % 2 != 0) {
                      visible = false;
                    } else {
                      visible = true;
                    }

                    return ContainerList(
                      visible: visible,
                      mainImage:
                          'https://cdn.alweb.com/thumbs/daleelalmata3em/article/fit710x532/%D9%85%D8%B7%D8%A7%D8%B9%D9%85-%D8%B4%D8%A7%D9%88%D8%B1%D9%85%D8%A7-%D9%81%D9%8A-%D8%B9%D8%A8%D8%AF%D9%88%D9%86.jpg',
                      secondImage:
                          'https://cdn.mos.cms.futurecdn.net/6bxva8DmZvNj8kaVrQZZMP-970-80.jpg.webp',
                      mainTitle: 'أبو مازن السوري',
                      space: '25 - 30',
                      time: '5',
                      rate: '5',
                      mainGreen: 'التوصيل مجانا',
                      subGreen: 'لفترة محدودة',
                      mainYellow: '45',
                      subYellow: 'خصم على كل الطلبات',
                      onPressed: () {
                        // Get.to(const ProductPage());
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: 28.h,
                    );
                  },
                  itemCount: 3),
              SizedBox(
                height: 10.h,
              ),
              RowAll(
                mainTitle: 'المطاعم ',
                subTitle: 'شاهد الكل',
                onPressed: () {
                  Get.to(const AllResurantScreen());
                },
              ),
              SizedBox(
                height: 10.h,
              ),
              GridView.builder(
                  gridDelegate: (SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 5.w,
                      crossAxisSpacing: 7.h)),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    // bool visible = true;
                    // if (index % 2 != 0) {
                    //   visible = false;
                    // } else {
                    //   visible = true;
                    // }
                    return ContainerGrid(
                      image:
                          'https://www.tailorbrands.com/wp-content/uploads/2020/07/mcdonalds-logo.jpg',
                      mainTitle: 'تامبا كريب',
                      time: '25 - 30',
                      rate: '5.0',
                      space: '5 ',
                      onPressed: () {
                        // Get.to(const ResturantPage());
                      },
                    );
                  },
                  itemCount: 4),
            ],
          ),
        ),
      );
    });
  }
}

class ContainerList extends StatelessWidget {
  // 'https://cdn.alweb.com/thumbs/daleelalmata3em/article/fit710x532/%D9%85%D8%B7%D8%A7%D8%B9%D9%85-%D8%B4%D8%A7%D9%88%D8%B1%D9%85%D8%A7-%D9%81%D9%8A-%D8%B9%D8%A8%D8%AF%D9%88%D9%86.jpg',
  // 'https://cdn.mos.cms.futurecdn.net/6bxva8DmZvNj8kaVrQZZMP-970-80.jpg.webp',

  final bool visible;
  String mainImage;
  String secondImage;

  String mainTitle;
  String space;
  String time;
  String rate;
  String mainGreen;
  String subGreen;
  String mainYellow;
  String subYellow;
  void Function() onPressed;

  ContainerList({
    super.key,
    required this.visible,
    required this.mainImage,
    required this.secondImage,
    required this.mainTitle,
    required this.space,
    required this.time,
    required this.rate,
    required this.mainGreen,
    required this.subGreen,
    required this.mainYellow,
    required this.subYellow,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AbsorbPointer(
        child: Container(
          height: 170.h,
          decoration: BoxDecoration(
              color: AppColors.greyF8,
              borderRadius: BorderRadius.circular(8.r)),
          child: Column(
            children: [
              Container(
                height: 122.h,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8.r)),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: CachedNetworkImage(
                        imageUrl: mainImage,
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
                        placeholder: (context, url) => shimmerCarDes(context),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 9.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Visibility(
                            visible: visible,
                            replacement: ButtonColumn(
                              mainTitle: '$mainYellow ليرة',
                              subTitle: subYellow,
                              color:
                                  HexColor(AppController.hexColorPrimary.value),
                            ),
                            child: ButtonColumn(
                                mainTitle: mainGreen, subTitle: subGreen),
                          ),
                          Container(
                            alignment: Alignment.center,
                            // padding: EdgeInsets.all(5.r),
                            height: 15.h,
                            width: 15.w,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: AppColors.white),
                            child: Icon(
                              Icons.favorite_border,
                              color: AppColors.black.withOpacity(0.4),
                              size: 10.r,
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
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 35.h,
                        width: 35.w,
                        padding: EdgeInsets.all(3.r),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
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
                              imageUrl: secondImage,
                              // height: 72.h,
                              // width: 72.w,
                              imageBuilder: (context, imageProvider) =>
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
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 7.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTextStyle(
                            name: mainTitle,
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
                              RowIcon(
                                  title: rate,
                                  iconData: Icons.star_rate_rounded,
                                  color: HexColor(
                                      AppController.hexColorPrimary.value)),
                              SizedBox(
                                width: 17.w,
                              ),
                              RowIcon(
                                  title: '$time دقيقة',
                                  iconData: Icons.access_time_filled_rounded,
                                  color: AppColors.black),
                              SizedBox(
                                width: 17.w,
                              ),
                              RowSvg(
                                title: 'يبعد $space كلم',
                                image: 'maps',
                              ),
                            ],
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
//         AppTextStyle(
//           name: subTitle,
//           color: AppColors.black,
//           fontSize: 7.sp,
//           isMarai: false,
//           fontWeight: FontWeight.w500,
//         ),
//       ],
//     );
//   }
// }
