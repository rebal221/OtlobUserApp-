// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otlob/value/colors.dart';
import 'package:otlob/widget/custom_image.dart';

import '../server/controller/app_controller.dart';

class CardTemplateRadio extends StatefulWidget {
  String image;

  Widget widget;
  double heigth;
  bool click;

  void Function() onPressed;

  CardTemplateRadio({
    Key? key,
    this.heigth = 10,
    required this.click,
    required this.onPressed,
    required this.widget,
    required this.image,
  }) : super(key: key);

  @override
  State<CardTemplateRadio> createState() => _CardTemplateRadioState();
}

class _CardTemplateRadioState extends State<CardTemplateRadio> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: SizedBox(
        height: 53.h,
        child: Card(
          clipBehavior: Clip.antiAlias,
          color: widget.click
              ? HexColor(AppController.hexColorPrimary.value).withOpacity(.2)
              : AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
              side: BorderSide(
                color: widget.click
                    ? HexColor(AppController.hexColorPrimary.value)
                    : AppColors.grey,
              ),
              borderRadius: BorderRadius.circular(8.r)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              children: [
                Expanded(
                    child: RadioListTile(
                  activeColor: widget.click
                      ? HexColor(AppController.hexColorPrimary.value)
                      : AppColors.grey,
                  title: widget.widget,
                  value: widget.click ? 1 : 0,
                  groupValue: 1,
                  onChanged: (value) {},
                )),
                CustomSvgImage(
                  imageName: widget.image,
                  height: widget.heigth,
                  width: 26.w,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
