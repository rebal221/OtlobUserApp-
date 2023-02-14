// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../value/colors.dart';
import 'app_style_text.dart';

class RowAll extends StatelessWidget {
  String mainTitle;
  String subTitle;
  void Function() onPressed;

  RowAll(
      {super.key,
      required this.mainTitle,
      required this.subTitle,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppTextStyle(
          name: mainTitle,
          color: AppColors.black,
          fontSize: 9.sp,
          isMarai: false,
          fontWeight: FontWeight.w500,
        ),
        const Spacer(),
        InkWell(
          onTap: onPressed,
          child: AppTextStyle(
            name: subTitle,
            color: AppColors.black,
            fontSize: 7.sp,
            isMarai: false,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
