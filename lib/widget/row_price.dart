// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../value/colors.dart';
import 'app_style_text.dart';
import 'box.dart';
import 'cash_network.dart';

class RowTextTwo extends StatelessWidget {
  String titel;
  String subTitel;
  String price;
  String image;

  RowTextTwo(
      {super.key,
      required this.titel,
      required this.subTitel,
      required this.price,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 55.h,
          width: 50.w,
          child: Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: CachNetwork(image: image),
          ),
        ),
        SizedBox(
          width: 7.w,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextStyle(
                name: titel,
                fontSize: 9.sp,
                color: AppColors.black,
                isMarai: false,
              ),
              SizedBox(
                height: 5.h,
              ),
              AppTextStyle(
                textAlign: TextAlign.start,
                name: subTitel,
                isMarai: false,
                fontSize: 8.sp,
                color: AppColors.black,
                fontWeight: FontWeight.w400,
              ),
              SizedBox(
                height: 12.h,
              ),
            ],
          ),
        ),
        // Spacer(),
        Box(price: price),
      ],
    );
  }
}
