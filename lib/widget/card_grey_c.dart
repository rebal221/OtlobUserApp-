import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otlob/widget/app_style_text.dart';
import 'package:otlob/widget/row_icon.dart';

import '../server/controller/app_controller.dart';
import '../value/colors.dart';

class CardGreyC extends StatelessWidget {
  const CardGreyC(
      {Key? key,
      required this.name,
      required this.rate,
      required this.time,
      required this.ratevalue})
      : super(key: key);
  final String name;
  final String rate;
  final String time;
  final String ratevalue;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70.h,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        color: AppColors.whiteEB,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 2.h,
                    ),
                    AppTextStyle(
                      name: name,
                      isMarai: false,
                      fontSize: 9.sp,
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    AppTextStyle(
                      name: rate,
                      isMarai: false,
                      fontSize: 8.sp,
                      color: AppColors.black,
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    AppTextStyle(
                      name: time,
                      fontSize: 6.sp,
                      color: AppColors.grey,
                    ),
                  ],
                ),
                const Spacer(),
                RowIcon(
                  title: ratevalue,
                  fontSize: 12.sp,
                  iconData: Icons.star_rate_rounded,
                  color: HexColor(AppController.hexColorPrimary.value),
                ),
              ],
            )),
      ),
    );
  }
}
