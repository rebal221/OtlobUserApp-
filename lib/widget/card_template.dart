import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otlob/value/colors.dart';
import 'package:otlob/widget/custom_image.dart';

import '../server/controller/app_controller.dart';

class CardTemplate extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final IconData? suffix;
  final String? prefix;
  final TextInputType inputType;
  bool isPassword;

  CardTemplate(
      {Key? key,
      required this.title,
      required this.controller,
      this.suffix,
      this.inputType = TextInputType.text,
      required this.isPassword,
      this.prefix})
      : super(key: key);

  @override
  State<CardTemplate> createState() => _CardTemplateState();
}

class _CardTemplateState extends State<CardTemplate> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55.h,
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: Colors.white,
        elevation: 5.r,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        child: TextField(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          keyboardType: widget.inputType,
          controller: widget.controller,
          obscureText: widget.isPassword,
          cursorColor: HexColor(AppController.hexColorPrimary.value),
          decoration: InputDecoration(
              suffix: InkWell(
                onTap: () {
                  widget.isPassword = !widget.isPassword;
                  setState(() {});
                },
                child: Container(
                  width: 45.w,
                  alignment: Alignment.center,
                  child: Icon(
                    widget.prefix == 'password'
                        ? (widget.isPassword
                            ? Icons.remove_red_eye
                            : Icons.remove_red_eye_outlined)
                        : widget.suffix,
                    color: AppColors.greyC,
                    size: 25,
                  ),
                ),
              ),
              prefixIconConstraints: BoxConstraints.tight(Size(40.w, 16.h)),
              prefixIcon: CustomSvgImage(
                imageName: widget.prefix,
                color: AppColors.greyC,
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              hintStyle: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.greyC,
              ),
              fillColor: Colors.white,
              hintText: widget.title),
        ),
      ),
    );
  }
}
