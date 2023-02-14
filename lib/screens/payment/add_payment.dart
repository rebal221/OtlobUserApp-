import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otlob/value/colors.dart';
import 'package:otlob/widget/app_style_text.dart';
import 'package:otlob/widget/app_text_field.dart';
import 'package:otlob/widget/card_grey.dart';

import '../../../widget/app_button.dart';
import '../../server/controller/app_controller.dart';
import '../../widget/card_template_radio.dart';
import '../Auth/sing_in.dart';

class AddPayment extends StatefulWidget {
  const AddPayment({Key? key}) : super(key: key);

  @override
  State<AddPayment> createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {
  bool visa = false;
  bool master = false;
  bool cash = false;

  void onTapRecognizer() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SignIn()));
  }

  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ));
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //     statusBarColor: HexColor(AppController.hexColorPrimary.value)
    // ));
    return Obx(() {
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.r),
                  bottomRight: Radius.circular(10.r))),
          backgroundColor: HexColor(AppController.hexColorPrimary.value),
          leadingWidth: 100.w,
          leading: TextButton.icon(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.white,
                size: 25.r,
              ),
              label: AppTextStyle(
                name: 'رجوع',
                fontSize: 10.sp,
              )),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            // padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
            children: [
              AppTextStyle(
                name: 'وسيلة الدفع المفضلة',
                color: AppColors.black,
                fontSize: 10.sp,
                isMarai: false,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(
                height: 14.h,
              ),
              CardTemplateRadio(
                click: true,
                heigth: 20.h,
                widget: AppTextStyle(
                  textAlign: TextAlign.center,
                  name: 'الدفع عند التسليم',
                  isMarai: false,
                  color: AppColors.black,
                  fontSize: 10.sp,
                ),
                image: 'cash',
                onPressed: () {},
              ),
              SizedBox(
                height: 40.h,
              ),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: AppTextStyle(
                  name: 'اضافة وسيلة دفع جديدة',
                  color: AppColors.black,
                  fontSize: 9.sp,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  CardGrey(
                    click: true,
                    image: 'master',
                  ),
                  CardGrey(
                    click: false,
                    image: 'visa',
                    heigth: 12.h,
                  ),
                  CardGrey(
                    click: false,
                    image: 'master',
                  ),
                ],
              ),
              SizedBox(
                height: 36.h,
              ),
              AppTextStyle(
                name: 'الاسم على البطاقة',
                color: AppColors.black,
                isMarai: false,
                fontSize: 9.sp,
              ),
              SizedBox(
                height: 10.h,
              ),
              AppTextField(hint: '', controller: TextEditingController()),
              SizedBox(
                height: 14.h,
              ),
              AppTextStyle(
                name: 'رقم البطاقة',
                isMarai: false,
                color: AppColors.black,
                fontSize: 9.sp,
              ),
              SizedBox(
                height: 10.h,
              ),
              AppTextField(hint: '', controller: TextEditingController()),
              SizedBox(
                height: 14.h,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextStyle(
                          name: 'تاريخ الانتهاء',
                          color: AppColors.black,
                          isMarai: false,
                          fontSize: 9.sp,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        AppTextField(
                            hint: 'mm / yy',
                            controller: TextEditingController()),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 14.w,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextStyle(
                          name: 'الرقم السري',
                          color: AppColors.black,
                          fontSize: 9.sp,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        AppTextField(
                            hint: 'CCV', controller: TextEditingController()),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              AppButton(
                  color: HexColor(AppController.hexColorPrimary.value),
                  title: 'أضف البطاقة ',
                  onPressed: () {
                    Get.back();
                    // Get.to(ResetPasswordThree());
                  }),
              SizedBox(
                height: 10.h,
              ),
            ],
          ),
        ),
      );
    });
  }
}
