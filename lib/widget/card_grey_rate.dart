import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otlob/widget/box.dart';
import 'package:rate/rate.dart';

import '../server/controller/app_controller.dart';
import '../value/colors.dart';
import 'app_text_field.dart';

class CardGreyRate extends StatelessWidget {
  const CardGreyRate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70.h,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        color: AppColors.whiteEB,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 2.h,
                        ),
                        SizedBox(
                          height: 20.h,
                          child: AppTextField(
                            controller: TextEditingController(),
                            hint: 'اضف تقييمك. مثلا (الطلب وصل بالوقت المناسب)',
                            hintFont: 9,
                          ),
                        ),
                        // SizedBox(
                        //   height: 2.h,
                        // ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Rate(
                            iconSize: 13.r,
                            color:
                                HexColor(AppController.hexColorPrimary.value),
                            allowHalf: true,
                            allowClear: true,
                            initialValue: 3.5,
                            readOnly: true,
                            onChange: (value) => log(value.toString()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Box(
                  price: 'تقييم',
                  visible: false,
                  fontSize: 10.sp,
                  width: 54.w,
                  height: 42.h,
                ),
                // Spacer(),
              ],
            )),
      ),
    );
  }
}
