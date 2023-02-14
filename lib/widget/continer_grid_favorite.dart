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

class ContainerGridFavorite extends StatelessWidget {
  //                    'https://www.tailorbrands.com/wp-content/uploads/2020/07/mcdonalds-logo.jpg',

  String image;
  String mainTitle;
  String time;
  String rate;
  String space;
  String price;
  bool visible;
  bool isFav;
  void Function() onPressed;
  void Function() onPressed2;

  ContainerGridFavorite(
      {super.key,
      required this.price,
      required this.image,
      required this.mainTitle,
      required this.visible,
      this.isFav = true,
      required this.time,
      required this.onPressed,
      required this.onPressed2,
      required this.rate,
      required this.space});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onPressed2,
      child: Container(
        height: 150,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 231, 231, 231),
            borderRadius: BorderRadius.circular(8.r)),
        child: Column(
          children: [
            Container(
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
                      imageUrl: image,
                      height: 110.h,
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
                  Visibility(
                    visible: isFav,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 9.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: 40.h,
                                width: 35.w,
                                child: Card(
                                  color: HexColor(
                                      AppController.hexColorPrimary.value),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AppTextStyle(
                                        textAlign: TextAlign.center,
                                        name: price,
                                        fontSize: 10.sp,
                                        isMarai: false,

                                        height: 1,

                                        color: AppColors.white,
                                        // fontWeight: FontWeight.w400,
                                      ),
                                      AppTextStyle(
                                        textAlign: TextAlign.center,
                                        name:
                                            '${AppController.appData.value.currency}',
                                        height: 1,
                                        isMarai: false,
                                        fontSize: 7.sp,
                                        color: AppColors.white,
                                        // fontWeight: FontWeight.w400,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Visibility(
                            visible: false,
                            child: InkWell(
                              onTap: onPressed,
                              child: Container(
                                alignment: Alignment.center,
                                // padding: EdgeInsets.all(5.r),
                                height: 25.h,
                                width: 25.w,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.white),
                                child: Icon(
                                  visible
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: visible
                                      ? AppColors.red
                                      : AppColors.black.withOpacity(0.4),
                                  size: 20.r,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 2,
            ),
            ListView(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              // crossAxisAlignment: CrossAxisAlignment.start,
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
                Column(
                  children: [
                    Row(
                      children: [
                        RowSvg(
                          title: '$time',
                          image: 'speed',
                        ),
                        // RowIcon(
                        //     title: '${time} دقيقة',
                        //     iconData: Icons.access_time_filled_rounded,
                        //     color: AppColors.black),
                      ],
                    ),
                    Row(
                      children: [
                        RowIcon(
                            title: rate,
                            iconData: Icons.star_rate_rounded,
                            color:
                                HexColor(AppController.hexColorPrimary.value)),
                        SizedBox(width: 6),
                        RowSvg(
                          title: 'يبعد $space م',
                          image: 'maps',
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
