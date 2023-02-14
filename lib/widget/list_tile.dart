// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otlob/value/colors.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../server/controller/app_controller.dart';
import 'app_style_text.dart';

class ListTileClass extends StatelessWidget {
  late String title;
  late String subTitle;
  late String trailing;
  late bool isLast;
  late bool isFirst;
  late bool disable = false;

  ListTileClass(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.trailing,
      this.disable = false,
      this.isFirst = false,
      this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disable ? 0.3 : 1,
      child: TimelineTile(
        hasIndicator: true,
        alignment: TimelineAlign.manual,
        lineXY: 0.1,
        isLast: isLast,
        isFirst: isFirst,
        indicatorStyle: IndicatorStyle(
          height: 32.h,
          indicator: Container(
            decoration: BoxDecoration(
              color: !disable
                  ? HexColor(AppController.hexColorPrimary.value)
                  : AppColors.grey,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 20.r,
            ),
          ),
          width: 50.r,
          color: !disable
              ? HexColor(AppController.hexColorPrimary.value)
              : AppColors.grey,
          padding: EdgeInsets.all(6.r),
        ),
        endChild: ListTile(
          subtitle: AppTextStyle(
            name: subTitle,
            fontSize: 8.sp,
            color: AppColors.grey,
          ),
          title: AppTextStyle(
            name: title,
            fontSize: 12.sp,
            color: AppColors.black,
          ),
        ),
        beforeLineStyle: LineStyle(
          color: !disable
              ? HexColor(AppController.hexColorPrimary.value)
              : AppColors.grey,
        ),
      ),
    );
  }
}
