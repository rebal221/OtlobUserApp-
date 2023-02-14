// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_text_field_no_border.dart';
import 'custom_image.dart';

class RowEditSvg extends StatelessWidget {
  String title;

  String hint;
  bool visible;
  bool enable;
  double fontSize;

  RowEditSvg(
      {super.key,
      this.enable = true,
      this.fontSize = 10,
      this.visible = true,
      required this.title,
      required this.hint});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomSvgImage(
          imageName: 'maps',
          height: 13.h,
          width: 10.h,
        ),
        SizedBox(
          width: 7.w,
        ),
        Expanded(
          flex: 2,
          child: AppFieldNoBorder(
            hintFont: 12.sp,
            enable: enable,
            hint: hint,
            controller: TextEditingController(),
          ),
        ),
        Visibility(
          visible: visible,
          child: CustomSvgImage(
            imageName: 'edit',
            height: 16.h,
            width: 17.h,
          ),
        )
      ],
    );
  }
}
