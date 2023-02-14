import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

import '../server/controller/app_controller.dart';
import '../value/colors.dart';
import 'app_style_text.dart';

class Box extends StatelessWidget {
  const Box({
    Key? key,
    required this.price,
    this.visible = true,
    this.fontSize = 15,
    this.height = 60,
    this.width = 65,
  }) : super(key: key);

  final String price;
  final bool visible;
  final double fontSize;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: height.h,
            width: width.w,
            child: Card(
              color: HexColor(AppController.hexColorPrimary.value),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppTextStyle(
                    textAlign: TextAlign.center,
                    name: price,
                    fontSize: fontSize.sp,
                    isMarai: false,

                    height: 1,

                    color: AppColors.white,
                    // fontWeight: FontWeight.w400,
                  ),
                  Visibility(
                    visible: visible,
                    child: AppTextStyle(
                      textAlign: TextAlign.center,
                      name: '${AppController.appData.value.currency}',
                      height: 1,
                      isMarai: false,

                      fontSize: 15.sp,
                      color: AppColors.white,
                      // fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 7.w,
          ),
        ],
      ),
    );
  }
}
