import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otlob/value/colors.dart';

import '../server/controller/app_controller.dart';
import 'app_style_text.dart';

class CardTemplateReset extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final IconData? suffix;
  final String? prefix;

  const CardTemplateReset(
      {Key? key,
      required this.title,
      required this.controller,
      this.suffix,
      this.prefix})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.h,
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: AppColors.grey8,
        elevation: 0,
        shape: RoundedRectangleBorder(
            side: const BorderSide(
              color: AppColors.grey8,
            ),
            borderRadius: BorderRadius.circular(8.r)),
        // elevation: 5.r,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  maxLines: 1,
                  minLines: 1,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: controller,
                  cursorColor: HexColor(AppController.hexColorPrimary.value),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: title,
                    helperStyle: TextStyle(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey8,
                      // textAlign: TextAlign.end,
                    ),
                    labelStyle: const TextStyle(color: Colors.white),
                    fillColor: AppColors.grey8,
                    filled: true,
                    label: AppTextStyle(
                      // textAlign: TextAlign.end,
                      name: '',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey8,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
              ),
              VerticalDivider(
                thickness: 1.r,
                color: AppColors.black,
              ),
              AppTextStyle(
                name: '+970',
                color: AppColors.black,
                fontSize: 12.sp,
              ),
              SizedBox(
                width: 10.w,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
