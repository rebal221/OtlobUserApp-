// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otlob/widget/custom_image.dart';

import '../value/colors.dart';
import 'app_style_text.dart';

class RowSvg extends StatelessWidget {
  // const RowSvg({
  //   Key? key,
  // }) : super(key: key);
  String title;

  String image;

  Color color;
  double fontSize;

  RowSvg(
      {super.key,
      this.fontSize = 6,
      this.color = AppColors.black,
      required this.title,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomSvgImage(
          imageName: image,
          color: color,
          height: 12.h,
          width: 7.w,
        ),
        SizedBox(
          width: 4.w,
        ),
        AppTextStyle(
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          name: title,
          fontSize: fontSize.sp,
          isMarai: false,

          color: color,

          // fontWeight: FontWeight.w400,
        ),
        SizedBox(
          width: 3.w,
        ),
      ],
    );
  }
}
