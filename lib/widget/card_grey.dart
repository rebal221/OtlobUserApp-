// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otlob/value/colors.dart';
import 'package:otlob/widget/custom_image.dart';

import '../server/controller/app_controller.dart';

class CardGrey extends StatelessWidget {
  String image;

  double heigth;
  bool click;

  // void Function() onPressed;

  CardGrey({
    Key? key,
    this.heigth = 17,
    required this.click,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      width: 60.w,
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: click
            ? HexColor(AppController.hexColorPrimary.value).withOpacity(.2)
            : AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
            side: BorderSide(
              color: click
                  ? HexColor(AppController.hexColorPrimary.value)
                  : AppColors.grey,
            ),
            borderRadius: BorderRadius.circular(8.r)),
        child: Center(
          child: CustomSvgImage(
            imageName: image,
            height: heigth,
            width: 26.w,
          ),
        ),
      ),
    );
  }
}
