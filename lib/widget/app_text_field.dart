import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otlob/value/colors.dart';

class AppTextField extends StatelessWidget {
  final TextInputType keyboardType;
  final String hint;
  final int hintFont;
  final int? maxLength;
  final TextEditingController controller;
  final bool obscureText;

  const AppTextField({
    Key? key,
    this.keyboardType = TextInputType.text,
    required this.hint,
    this.maxLength,
    this.hintFont = 10,
    this.obscureText = false,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLength: maxLength,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        // labelText: hint,
        counterText: '',
        enabledBorder: border,
        focusedBorder: border,
        hintText: hint,
        hintStyle: GoogleFonts.cairo(
          color: AppColors.grey,
          fontWeight: FontWeight.w400,
          fontSize: hintFont.sp,
        ),
      ),
    );
  }

  OutlineInputBorder get border => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          width: 1,
          color: AppColors.greyFF,
        ),
      );
}
