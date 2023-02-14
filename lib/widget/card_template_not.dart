import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otlob/value/colors.dart';
import 'package:otlob/widget/custom_image.dart';

import '../server/controller/app_controller.dart';

class CardTemplateTransparent extends StatelessWidget {
  final String title;
  final Color colorFont;
  final TextEditingController controller;
  final IconData? suffix;
  final String? prefix;
  final bool visible;
  final bool readOnly;

  const CardTemplateTransparent(
      {Key? key,
      required this.title,
      required this.controller,
      this.suffix,
      this.visible = true,
      this.readOnly = false,
      this.colorFont = AppColors.grey,
      this.prefix})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 53.h,
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
            // side: BorderSide(
            //   color: AppColors.grey,
            //
            // ),
            borderRadius: BorderRadius.circular(8.r)),
        // elevation: 5.r,
        child: TextField(
          showCursor: !readOnly,
          readOnly: readOnly,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          controller: controller,
          cursorColor: HexColor(AppController.hexColorPrimary.value),
          decoration: InputDecoration(
              suffixIcon: Icon(
                suffix,
                color: AppColors.greyCC,
                size: 18.r,
              ),
              prefixIconConstraints: BoxConstraints.tight(Size(40.w, 16.h)),
              prefixIcon: CustomSvgImage(
                imageName: prefix,
                color: visible ? AppColors.grey : AppColors.white,
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: AppColors.grey,
                  ),
                  borderRadius: BorderRadius.circular(8.r)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: AppColors.grey,
                  ),
                  borderRadius: BorderRadius.circular(8.r)),
              hintStyle: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: colorFont,
              ),
              fillColor: Colors.white,
              hintText: title),
        ),
      ),
    );
  }
}
