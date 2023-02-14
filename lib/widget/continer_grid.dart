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

class ContainerGrid extends StatelessWidget {
  //                    'https://www.tailorbrands.com/wp-content/uploads/2020/07/mcdonalds-logo.jpg',

  String image;
  String mainTitle;
  String time;
  String rate;
  String space;
  void Function() onPressed;

  ContainerGrid(
      {super.key,
      required this.image,
      required this.mainTitle,
      required this.onPressed,
      required this.time,
      required this.rate,
      required this.space});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AbsorbPointer(
        child: Container(
          padding: EdgeInsets.zero,
          height: 160.h,
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
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(8.r),
                      // ),
                      child: CachedNetworkImage(
                        imageUrl: image,
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
                  ],
                ),
              ),
              SizedBox(
                height: 5.h,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RowIcon(
                          title: rate,
                          iconData: Icons.star_rate_rounded,
                          color: HexColor(AppController.hexColorPrimary.value)),
                      RowIcon(
                          title: '$time دقيقة',
                          iconData: Icons.access_time_filled_rounded,
                          color: AppColors.black),
                      RowSvg(
                        title: 'يبعد $space كلم',
                        image: 'maps',
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
