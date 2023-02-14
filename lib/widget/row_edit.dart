// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../value/colors.dart';
import 'app_style_text.dart';
import 'app_text_field_no_border.dart';
import 'custom_image.dart';

class RowEdit extends StatelessWidget {
  String title;

  String hint;
  bool visible;
  bool enable;
  double fontSize;
  TextEditingController controller;

  RowEdit(
      {super.key,
      this.enable = true,
      this.fontSize = 10,
      this.visible = true,
      required this.title,
      required this.controller,
      required this.hint});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
        Expanded(
          flex: 2,
          child: AppFieldNoBorder(
            enable: enable,
            hint: hint,
            controller: controller,
          ),
        ),
        Visibility(
          visible: visible,
          child: CustomSvgImage(
            imageName: 'edit',
            height: 11.h,
            width: 11.h,
          ),
        )
      ],
    );
  }
}
