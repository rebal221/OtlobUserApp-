// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../value/colors.dart';
import 'app_style_text.dart';

class ButtonColumn extends StatelessWidget {
  String mainTitle;
  String subTitle;
  Color color;

  ButtonColumn({
    super.key,
    required this.mainTitle,
    required this.subTitle,
    this.color = AppColors.green,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 43.h,
      width: 87.w,
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: AppTextStyle(
                textAlign: TextAlign.center,
                name: mainTitle,
                fontSize: 10.sp,
                isMarai: false,

                // height: 1,

                color: AppColors.white,
                // fontWeight: FontWeight.w400,
              ),
            ),
            Flexible(
              child: AppTextStyle(
                textAlign: TextAlign.center,
                name: subTitle,
                // height: 1,
                fontWeight: FontWeight.w500,
                isMarai: false,

                fontSize: 8.sp,
                color: AppColors.white,
                // fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
