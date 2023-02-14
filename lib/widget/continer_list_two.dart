// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otlob/widget/row_icon.dart';
import 'package:otlob/widget/row_svg.dart';

import '../server/controller/app_controller.dart';
import '../value/colors.dart';
import 'app_style_text.dart';
import 'component.dart';

class ContainerListDetailsTwo extends StatelessWidget {
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
  String map;
  String price;

  ContainerListDetailsTwo({
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
    required this.map,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.h,
      decoration: BoxDecoration(
          color: AppColors.white, borderRadius: BorderRadius.circular(8.r)),
      child: Column(
        children: [
          Container(
            height: 171.h,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r)),
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
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 9.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
            height: 11.h,
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 7.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextStyle(
                        name: mainTitle,
                        fontSize: 12.sp,
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
                            width: 10.w,
                          ),
                          RowIcon(
                              title: '$time دقيقة',
                              iconData: Icons.access_time_filled_rounded,
                              color: AppColors.black),
                          SizedBox(
                            width: 10.w,
                          ),
                          RowSvg(
                            title: map,
                            image: 'maps',
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      SizedBox(
                        height: 50.h,
                        width: 54.w,
                        child: Card(
                          color: HexColor(AppController.hexColorPrimary.value),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppTextStyle(
                                textAlign: TextAlign.center,
                                name: price,
                                fontSize: 18.sp,
                                isMarai: false,

                                height: 1,

                                color: AppColors.white,
                                // fontWeight: FontWeight.w400,
                              ),
                              AppTextStyle(
                                textAlign: TextAlign.center,
                                name: '${AppController.appData.value.currency}',
                                height: 1,
                                isMarai: false,
                                fontSize: 13.sp,
                                color: AppColors.white,
                                // fontWeight: FontWeight.w400,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
