import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otlob/screens/main/main_screens/home.dart';
import 'package:otlob/screens/main/main_screens/offer_screen.dart';
import 'package:otlob/screens/main/main_screens/order.dart';
import 'package:otlob/screens/payment/selectpayment.dart';
import 'package:otlob/services/preferences/app_preferences.dart';
import 'package:otlob/value/colors.dart';
import 'package:otlob/value/constant.dart';
import 'package:otlob/widget/app_style_text.dart';
import 'package:otlob/widget/row_edit.dart';
import 'package:rating_dialog/rating_dialog.dart';

import '../../../server/controller/app_controller.dart';
import '../../../widget/app_text_field_no_border.dart';
import '../../../widget/component.dart';
import '../../../widget/custom_image.dart';
import '../../Auth/sing_in.dart';
import '../../menu/Drawer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void onTapRecognizer() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SignIn()));
  }

  late TextEditingController _adderss;
  late TextEditingController _paymentType;

  @override
  void initState() {
    _adderss = TextEditingController(text: AppPreferences.userData['adderss']);
    _paymentType =
        TextEditingController(text: AppPreferences.userData['paymentType']);
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

  int pageIndex = 5;
  TextEditingController phonecon = TextEditingController();
  TextEditingController addresscon = TextEditingController();
  TextEditingController paymentcon = TextEditingController();
  final pages = [
    const Home(),
    const OfferScreen(),
    const OrderScreen(),
    const ProfileScreen(),
  ];

  @override
  void dispose() {
    _adderss.dispose();
    _paymentType.dispose();
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
    return Obx(() {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: HexColor(AppController.hexColorPrimary.value),
          leadingWidth: 100.w,
          leading: TextButton.icon(
              onPressed: () {
                Get.offAll(menu(currentItem: MenuItems.Home));
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
          // leading: MenuWidget(),
          actions: const [
            MenuWidget(),
          ],

          // leading: TextButton.icon(
          //     onPressed: () {
          //       Get.back();
          //     },
          //     icon: Icon(
          //       Icons.keyboard_arrow_right,
          //       color: Colors.white,
          //       size: 25.r,
          //     ),
          //     label: AppTextStyle(
          //       name: 'رجوع',
          //       fontSize: 10.sp,
          //     )),
        ),
        body: SingleChildScrollView(
          child: Column(
            // shrinkWrap: true,
            // padding: EdgeInsets.all(0),
            children: [
              Stack(
                fit: StackFit.loose,
                children: [
                  Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10.r),
                            bottomRight: Radius.circular(10.r)),
                        color: HexColor(AppController.hexColorPrimary.value)),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 70.h,
                      width: 70.w,
                      padding: EdgeInsets.all(3.r),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          shape: BoxShape.circle,
                          color: Colors.white
                          // shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.only(
                          //         bottomLeft: Radius.circular(10.r),
                          //         bottomRight: Radius.circular(10.r))),

                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(8.r),
                          ),
                      child: SizedBox(
                        height: 28.h,
                        width: 28.w,
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(shape: BoxShape.circle

                              // shape: RoundedRectangleBorder(
                              //   borderRadius: BorderRadius.circular(8.r),
                              ),
                          child: CachedNetworkImage(
                            imageUrl: AppPreferences.userData['image'],
                            // height: 72.h,
                            // width: 72.w,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (context, url) =>
                                shimmerCarDes(context),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 6.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  // shrinkWrap: true,
                  // physics: NeverScrollableScrollPhysics(),

                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppTextStyle(
                          name: AppPreferences.userData['name'],
                          fontSize: 11.sp,
                          color: AppColors.black,
                          isMarai: false,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 28.h,
                    ),
                    Divider(
                      height: 15.h,
                      color: AppColors.greyC,
                    ),
                    NewWidget(
                      hint: AppPreferences.userData['phone'],
                      title: 'رقم الهاتف',
                      phonecon: phonecon,
                    ),
                    Divider(
                      height: 5.h,
                      color: AppColors.greyC,
                    ),
                    NewWidget(
                      hint: AppPreferences.userData['adderss'],
                      title: 'العنوان',
                      phonecon: addresscon,
                    ),
                    Divider(
                      height: 5.h,
                      color: AppColors.greyC,
                    ),
                    RowEdit(
                      controller: TextEditingController(
                          text:
                              ' ${AppPreferences.userData['countOrder']} طلب '),
                      enable: false,
                      title: 'عدد الطلبات',
                      hint: ' ${AppPreferences.userData['countOrder']} طلب ',
                      visible: false,
                    ),
                    Divider(
                      height: 5.h,
                      color: AppColors.greyC,
                    ),
                    newWidghtPatment(
                        titl: 'طرق الدفع',
                        phoneco: paymentcon,
                        hin: AppPreferences().getData(key: 'paymentType')),
                    Divider(
                      height: 5.h,
                      color: AppColors.greyC,
                    ),
                    RowEdit(
                      controller: TextEditingController(
                          text: AppPreferences.userData['userRate']),
                      enable: false,
                      title: 'التقييم العام',
                      hint: AppPreferences.userData['userRate'],
                      visible: false,
                    ),
                    Divider(
                      height: 35.h,
                      color: AppColors.greyC,
                    ),
                    Container(
                      child: Center(
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          color: HexColor(AppController.hexColorPrimary.value),
                          padding: EdgeInsets.only(left: 30, right: 30),
                          child: Text(
                            'حفظ',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(AppPreferences().getUserDataAsMap()['uid'])
                                .set({
                              'adderss': addresscon.text
                            }, SetOptions(merge: true)).then((value) =>
                                    getSheetSucsses('تم حفظ البيانات'));
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showRatingAppDialog() {
    final _ratingDialog = RatingDialog(
      showCloseButton: true,
      force: true,
      starColor: HexColor(AppController.hexColorPrimary.value),
      commentHint: 'أخبرنا بتعليقاتك',
      image: Image.asset(
        "images/logo_app.png",
        height: 100,
      ),
      submitButtonText: 'تقييم',
      onCancelled: () => print('cancelled'),
      onSubmitted: (response) {
        print('rating: ${response.rating}, '
            'comment: ${response.comment}');

        if (response.rating < 3.0) {
          print('response.rating: ${response.rating}');
        } else {
          Container();
        }
      },
      title: Text(
        'قيم هذا التطبيق وأخبر الآخرين برأيك.',
        textAlign: TextAlign.center,
      ),
    );

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _ratingDialog,
    );
  }
}

class NewWidget extends StatefulWidget {
  final String title;

  final TextEditingController phonecon;
  final String hint;
  NewWidget({
    Key? key,
    required this.title,
    required this.phonecon,
    required this.hint,
  }) : super(key: key);

  @override
  State<NewWidget> createState() => _NewWidgetState();
}

bool enable = false;

class _NewWidgetState extends State<NewWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: AppTextStyle(
            name: widget.title,
            fontSize: 11.sp,
            color: AppColors.black,
            isMarai: false,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          flex: 2,
          child: AppFieldNoBorder(
            enable: enable,
            hint: widget.hint,
            controller: widget.phonecon,
          ),
        ),
        InkWell(
          onTap: () {
            enable = !enable;
            setState(() {});
          },
          child: Visibility(
            visible: true,
            child: CustomSvgImage(
              imageName: 'edit',
              height: 11.h,
              width: 11.h,
            ),
          ),
        )
      ],
    );
  }
}

class newWidghtPatment extends StatefulWidget {
  final String titl;

  final TextEditingController phoneco;
  final String hin;
  const newWidghtPatment(
      {super.key,
      required this.titl,
      required this.phoneco,
      required this.hin});

  @override
  State<newWidghtPatment> createState() => _newWidghtPatmentState();
}

bool enabl = false;

class _newWidghtPatmentState extends State<newWidghtPatment> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: AppTextStyle(
            name: widget.titl,
            fontSize: 11.sp,
            color: AppColors.black,
            isMarai: false,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          flex: 2,
          child: AppFieldNoBorder(
            enable: enabl,
            hint: widget.hin,
            controller: widget.phoneco,
          ),
        ),
        InkWell(
          onTap: () {
            Get.to(SelectPayment(
                type: AppPreferences().getUserDataAsMap()['paymentType']));
          },
          child: Visibility(
            visible: true,
            child: CustomSvgImage(
              imageName: 'edit',
              height: 11.h,
              width: 11.h,
            ),
          ),
        )
      ],
    );
  }
}
