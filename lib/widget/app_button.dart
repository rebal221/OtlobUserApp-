// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:otlob/server/controller/app_controller.dart';

import 'app_style_text.dart';

@immutable
class AppButton extends StatefulWidget {
  final String title;
  final double height;
  final double fontSize;
  final Color color;
  final void Function() onPressed;
  AppController appController = Get.find();

  AppButton(
      {Key? key,
      required this.color,
      this.height = 50,
      this.fontSize = 16,
      required this.title,
      required this.onPressed})
      : super(key: key);

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, widget.height.h),
          backgroundColor: widget.color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          )),
      child: AppTextStyle(
        name: widget.title,
        fontSize: widget.fontSize.sp,
        color: Colors.white,
      ),
    );
  }
}
