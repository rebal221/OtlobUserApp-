// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otlob/value/colors.dart';

import '../server/controller/app_controller.dart';
import 'app_style_text.dart';

class CardTemplateCheck extends StatelessWidget {
  String image;
  String price;
  String title;
  double heigth;
  bool click;

  void Function() onPressed;

  CardTemplateCheck({
    Key? key,
    this.heigth = 10,
    required this.click,
    required this.onPressed,
    required this.title,
    required this.image,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 53.h,
      child: Card(
        clipBehavior: Clip.antiAlias,
        // color: click ? HexColor(AppController.hexColorPrimary.value).withOpacity(.2) : AppColors.white,
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Row(
            children: [
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: InkWell(
                    onTap: onPressed,
                    child: CheckboxListTile(
                      // checkColor:HexColor(AppController.hexColorPrimary.value)  ,
                      checkboxShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.r),
                        // side: BorderSide(
                        //   color: HexColor(AppController.hexColorPrimary.value)
                        // ),
                      ),
                      contentPadding: EdgeInsets.zero,
                      activeColor:
                          HexColor(AppController.hexColorPrimary.value),

                      title: AppTextStyle(
                        name: title,
                        color: AppColors.black,
                        fontWeight: FontWeight.w400,
                        isMarai: false,
                        fontSize: 11.sp,
                      ),
                      value: click,
                      onChanged: (value) {},
                    ),
                  ),
                ),
              ),
              const Spacer(),
              AppTextStyle(
                name: '$price ${AppController.appData.value.currency}',
                color: AppColors.black,
                fontWeight: FontWeight.w400,
                isMarai: false,
                fontSize: 10.sp,
              )
            ],
          ),
        ),
        // shape: RoundedRectangleBorder(
        //     side: BorderSide(
        //       color: click ? HexColor(AppController.hexColorPrimary.value) : AppColors.grey,
        //     ),
        //     borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }
}
