import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otlob/value/colors.dart';
import 'package:otlob/widget/custom_image.dart';

import '../server/controller/app_controller.dart';
import 'app_style_text.dart';

class CardTemplatePhone extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final IconData? suffix;
  final String? prefix;

  const CardTemplatePhone(
      {Key? key,
      required this.title,
      required this.controller,
      this.suffix,
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
            side: const BorderSide(
              color: AppColors.grey,
            ),
            borderRadius: BorderRadius.circular(8.r)),
        // elevation: 5.r,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  keyboardType: TextInputType.number,
                  controller: controller,
                  cursorColor: HexColor(AppController.hexColorPrimary.value),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                    suffix: Icon(
                      suffix,
                      color: AppColors.grey,
                    ),

                    prefixIconConstraints:
                        BoxConstraints.tight(Size(40.w, 16.h)),
                    prefixIcon: CustomSvgImage(
                      imageName: prefix,
                      color: AppColors.grey,
                    ),
                    border: InputBorder.none,
                    // enabledBorder: OutlineInputBorder(
                    //     // borderSide: BorderSide(
                    //     //   color: AppColors.grey,
                    //     // ),
                    //     // borderRadius: BorderRadius.circular(8.r)
                    // ),
                    // focusedBorder: OutlineInputBorder(
                    //     // borderSide: BorderSide(
                    //     //   color: AppColors.grey,
                    //     // ),
                    //     // borderRadius: BorderRadius.circular(8.r)
                    //
                    // ),
                    labelStyle: const TextStyle(color: Colors.white),
                    fillColor: Colors.white,
                    label: AppTextStyle(
                      name: title,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey,
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
