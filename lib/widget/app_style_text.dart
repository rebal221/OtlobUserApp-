import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyle extends StatelessWidget {
  final String name;
  final FontWeight fontWeight;
  final double fontSize;
  final double height;
  final Color color;
  final int count;
  final double letterSpacing;
  final double wordSpacing;
  final int maxLines;
  final TextOverflow overflow;
  final TextAlign textAlign;
  final TextDecoration decoration;
  final bool isMarai;

  const AppTextStyle({Key? key,
    this.color = Colors.white,
    required this.name,
     this.fontSize= 16,
    this.fontWeight = FontWeight.bold,
    this.decoration = TextDecoration.none,
    this.count = 20,
    this.letterSpacing = 1,
    this.wordSpacing = 1,
    this.maxLines = 1,
    this.isMarai = true,
    this.height = 1.5,
    this.overflow = TextOverflow.ellipsis,
    this.textAlign = TextAlign.start
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(


      name,
      maxLines: count,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
      style:isMarai?
      GoogleFonts.almarai(


          color: color,
          // letterSpacing: letterSpacing,
          // wordSpacing: wordSpacing,
          fontWeight: fontWeight,
          fontSize: fontSize.sp,
          decoration: decoration,
          height: height,

      ):
      GoogleFonts.cairo(

          color: color,
          // letterSpacing: letterSpacing,
          // wordSpacing: wordSpacing,
          fontWeight: fontWeight,
          fontSize: fontSize.sp,
          decoration: decoration,
          height: height

      ),

    );
  }
}
