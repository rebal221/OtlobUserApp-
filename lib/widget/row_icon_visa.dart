// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../value/colors.dart';
import 'app_style_text.dart';
import 'custom_image.dart';

class RowIconVisa extends StatelessWidget {
  String title;

  String hint;
  bool visible;
  bool enable;
  double fontSize;
  String type;

  RowIconVisa(
      {super.key,
      this.enable = true,
      this.fontSize = 10,
      this.visible = true,
      required this.title,
      required this.hint,
      required this.type});

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: AppTextStyle(
            name: title,
            fontSize: fontSize.sp,
            color: AppColors.black,
            isMarai: false,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          width: 30.w,
        ),
        AppTextStyle(
          name: type,
          color: Colors.black,
          fontWeight: FontWeight.w300,
          fontSize: 10.sp,
        ),
        SizedBox(
          width: 5.w,
        ),
        CustomSvgImage(
          imageName: (type == 'Cash' ? 'cash' : 'paypal'),
          height: 20.h,
          width: 20.w,
        ),

        // CustomSvgImage(
        //   imageName: 'master',
        //   height: 15.h,
        //   width: 14.w,
        // ),
        // SizedBox(
        //   width: 5.w,
        // ),
        // CustomSvgImage(
        //   imageName: 'cash',
        //   height: 15.h,
        //   width: 14.w,
        // ),
        const Spacer(
          flex: 2,
        ),
      ],
    );
  }
}
