import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otlob/value/colors.dart';
import 'package:otlob/widget/custom_image.dart';

import '../server/controller/app_controller.dart';

class CardTemplateBlack extends StatelessWidget {
  final String title;
  final Color colorFont;
  final TextEditingController controller;
  final IconData? suffix;
  final String? prefix;
  final bool enable;

  const CardTemplateBlack(
      {Key? key,
      required this.title,
      required this.controller,
      this.suffix,
      this.enable = true,
      this.colorFont = AppColors.grey,
      this.prefix})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      child: TextField(
        readOnly: enable,
        showCursor: !enable,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        controller: controller,
        cursorColor: HexColor(AppController.hexColorPrimary.value),
        decoration: InputDecoration(
            suffixIcon: Icon(
              suffix,
              color: AppColors.greyCC,
              size: 16.r,
            ),
            prefixIconConstraints: BoxConstraints.tight(Size(25.w, 16.h)),
            prefixIcon: CustomSvgImage(
              imageName: prefix,
              color: AppColors.black,
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: AppColors.black,
                ),
                borderRadius: BorderRadius.circular(8.r)),
            focusedBorder: OutlineInputBorder(
                // ignore: prefer_const_constructors
                borderSide: BorderSide(
                  color: AppColors.black,
                ),
                borderRadius: BorderRadius.circular(8.r)),
            hintStyle: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              color: colorFont,
            ),
            fillColor: Colors.white,
            hintText: title),
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
      ),
    );
  }
}
