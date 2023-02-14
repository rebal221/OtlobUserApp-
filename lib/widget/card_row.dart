// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otlob/value/colors.dart';

import 'app_style_text.dart';

class CardRow extends StatelessWidget {
  String title;
  String title2;
  bool isBold;
  double fontSize;

  // void Function() onPressed;

  CardRow({
    Key? key,
    this.isBold = false,
    this.fontSize = 10,
    required this.title,
    required this.title2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: AppTextStyle(
          name: title,
          color: AppColors.black,
          fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
          isMarai: false,
          fontSize: fontSize.sp,
        )),
        const Spacer(),
        AppTextStyle(
          name: title2,
          color: AppColors.black,
          fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
          isMarai: false,
          fontSize: fontSize.sp,
        )
      ],
    );
  }
}
