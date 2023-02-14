// ignore_for_file: deprecated_member_use

import 'package:email_validator/email_validator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart' as gecoding;
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:location/location.dart';
import 'package:otlob/screens/Auth/otp.dart';
import 'package:otlob/screens/Auth/sing_in.dart';
import 'package:otlob/screens/map_picker/map_picker.dart';
import 'package:otlob/screens/reset/verfication.dart';
import 'package:otlob/server/firebase_store.dart';
import 'package:otlob/server/model/user_model.dart';
import 'package:otlob/services/network/network_controller.dart';
import 'package:otlob/services/preferences/app_preferences.dart';
import 'package:otlob/value/colors.dart';
import 'package:otlob/value/constant.dart';
import 'package:otlob/widget/app_style_text.dart';

import '../../server/controller/app_controller.dart';
import '../../widget/app_button.dart';
import '../../widget/card_template_not.dart';
import '../../widget/card_template_phone_two.dart';
import '../../widget/custom_image.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final TapGestureRecognizer _recognizer = TapGestureRecognizer()
    ..onTap = () => onTapRecognizer();
  AppController appController = Get.find();

  void onTapRecognizer() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SignIn()));
  }

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  LocationData? _userLocation;
  late TextEditingController _email;
  late TextEditingController _password;
  late TextEditingController _name;
  late TextEditingController _phone;

  late TextEditingController _adderss;
  late TextEditingController _city;
  String imageUrl =
      'https://firebasestorage.googleapis.com/v0/b/carproject-flutter.appspot.com/o/image.gif?alt=media&token=09ff484d-8c5f-4180-a233-048a6d612248';
  String fcm = '';
  NetworkController networkController = Get.find();
  IconData? suffix;
  @override
  void initState() {
    _getUserLocation();
    getToken();

    // TODO: implement initState

    _email = TextEditingController(
        text: AppPreferences().getData(key: 'emailRegister'));
    _name = TextEditingController(
        text: AppPreferences().getData(key: 'nameRegister'));
    _password = TextEditingController();
    _phone = TextEditingController();
    _city = TextEditingController();
    _adderss = TextEditingController();
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
    _email.dispose();
    _name.dispose();
    _password.dispose();
    _phone.dispose();
    _city.dispose();
    _adderss.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        body: ListView(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
          children: [
            Align(
              alignment: Alignment.center,
              child: AppTextStyle(
                textAlign: TextAlign.center,
                name: '''من فضلك أدخل بياناتك
لانشاء حساب جديد''',
                fontSize: 14.sp,
                color: AppColors.black,
                // fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Align(
              alignment: AlignmentDirectional.topStart,
              child: AppTextStyle(
                textAlign: TextAlign.center,
                name: 'البريد الالكتروني',
                fontSize: 12.sp,
                color: AppColors.black,
                // fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: 7.h,
            ),
            CardTemplateTransparent(
                readOnly:
                    AppPreferences().getData(key: 'emailRegister').isNotEmpty
                        ? true
                        : false,
                prefix: 'mail',
                title: 'البريد الإلكتروني',
                controller: _email),
            SizedBox(
              height: 14.h,
            ),
            Align(
              alignment: AlignmentDirectional.topStart,
              child: AppTextStyle(
                textAlign: TextAlign.center,
                name: 'الإسم',
                fontSize: 12.sp,
                color: AppColors.black,
                // fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: 7.h,
            ),
            CardTemplateTransparent(
                readOnly:
                    AppPreferences().getData(key: 'nameRegister').isNotEmpty
                        ? true
                        : false,
                prefix: 'person_black',
                title: 'الإسم',
                controller: _name),
            SizedBox(
              height: 14.h,
            ),
            Align(
              alignment: AlignmentDirectional.topStart,
              child: AppTextStyle(
                textAlign: TextAlign.center,
                name: 'كلمة السر',
                fontSize: 12.sp,
                color: AppColors.black,
                // fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: 7.h,
            ),
            CardTemplateTransparent(
                prefix: 'password', title: 'كلمة السر', controller: _password),
            SizedBox(
              height: 14.h,
            ),
            Align(
              alignment: AlignmentDirectional.topStart,
              child: AppTextStyle(
                textAlign: TextAlign.center,
                name: 'رقم الهاتف',
                fontSize: 12.sp,
                color: AppColors.black,
                // fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: 7.h,
            ),
            SizedBox(
              height: 53.h,
              child: Card(
                clipBehavior: Clip.antiAlias,
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: AppColors.grey,
                    ),
                    borderRadius: BorderRadius.circular(8.r)),
                // elevation: 5.r,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          keyboardType: TextInputType.number,
                          controller: _phone,
                          onChanged: (s) async {
                            List<gecoding.Placemark> placemarks =
                                await gecoding.placemarkFromCoordinates(
                              double.parse(
                                  AppPreferences().getData(key: 'lat')),
                              double.parse(
                                  AppPreferences().getData(key: 'long')),
                            );

                            // update the ui with the address
                            _adderss.text = '${placemarks.first.street}';
                            _city.text = '${placemarks.first.subLocality}';
                          },
                          cursorColor:
                              HexColor(AppController.hexColorPrimary.value),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            suffix: Icon(
                              suffix,
                              color: AppColors.grey,
                            ),
                            prefixIconConstraints:
                                BoxConstraints.tight(Size(40.w, 16.h)),
                            prefixIcon: CustomSvgImage(
                              imageName: 'call',
                              color: AppColors.grey,
                            ),
                            border: InputBorder.none,
                            labelStyle: const TextStyle(color: Colors.white),
                            fillColor: Colors.white,
                            label: AppTextStyle(
                              name: 'رقم الهاتف',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.grey,
                            ),
                          ),
                        ),
                      ),
                      VerticalDivider(
                        thickness: 1.r,
                        color: AppColors.black,
                      ),
                      AppTextStyle(
                        name: '+970',
                        color: AppColors.black,
                        fontSize: 12.sp,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 14.h,
            ),
            Align(
              alignment: AlignmentDirectional.topStart,
              child: AppTextStyle(
                textAlign: TextAlign.center,
                name: 'العنوان',
                fontSize: 12.sp,
                color: AppColors.black,
                // fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: 7.h,
            ),
            CardTemplateTransparent(
                prefix: 'map',
                title: 'رقم الشارع والبناية',
                controller: _adderss),
            SizedBox(
              height: 14.h,
            ),
            CardTemplateTransparent(
                prefix: 'map',
                title: 'المدينة',
                visible: false,
                controller: _city),
            SizedBox(
              height: 5.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomSvgImage(
                  imageName: 'maps',
                  // color: AppColors.grey,
                  height: 12.h,
                  width: 7.w,
                ),
                SizedBox(
                  width: 3.w,
                ),
                InkWell(
                  onTap: () async {
                    Get.to(MapPickerScreen(
                      latLng: LatLng(
                          _userLocation!.latitude!, _userLocation!.longitude!),
                    ));
                  },
                  child: AppTextStyle(
                    textAlign: TextAlign.center,
                    name: 'تحديد العنوان على الخريطة',
                    fontSize: 10.sp,
                    color: AppColors.black,
                    // fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  width: 3.w,
                ),
              ],
            ),
            SizedBox(
              height: 60.h,
            ),
            AppButton(
                color: HexColor(AppController.hexColorPrimary.value),
                title: 'انشاء حساب جديد',
                onPressed: () async {
                  SVProgressHUD.show();

                  if (await checkData()) {
                    saveData();
                  }
                  SVProgressHUD.dismiss();
                }),
            SizedBox(
              height: 12.h,
            ),
            Center(
              child: RichText(
                text: TextSpan(
                  text: 'لديك حساب بالفعل؟',
                  style: GoogleFonts.almarai(
                      fontWeight: FontWeight.w900,
                      color: AppColors.black,
                      fontSize: 13.sp,
                      height: 1.5),
                  children: <TextSpan>[
                    const TextSpan(text: '  '),
                    TextSpan(
                        recognizer: _recognizer,
                        text: 'أدخل من هنا ',
                        style: GoogleFonts.almarai(
                            color:
                                HexColor(AppController.hexColorPrimary.value),
                            fontWeight: FontWeight.w900,
                            fontSize: 13.sp,
                            height: 1.5)),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  //ToDo:get current location user
  Future<void> _getUserLocation() async {
    Location location = Location();

    // Check if location service is enable
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // Check if permission is granted
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    final locationData = await location.getLocation();
    if (mounted) {
      setState(() {
        _userLocation = locationData;
      });
    }
  }

  //ToDo:checkData
  Future<bool> checkData() async {
    ///اعمل فحص رقم الجوال اذا موجود قبل هيك او لا اوعك تنسىى
    if (_name.text.trim().isNotEmpty &&
        _phone.text.trim().isNotEmpty &&
        _city.text.trim().isNotEmpty &&
        _password.text.trim().isNotEmpty &&
        _adderss.text.trim().isNotEmpty) {
      if (_phone.text.length == 10) {
        if (EmailValidator.validate(_email.text.trim())) {
          bool checkInternet = await networkController.initConnectivity();
          if (checkInternet) {
            return true;
          }
        } else {
          getSheetError('يرجى التاكد من صيغة البريد الاكتروني');

          return false;
        }
      } else {
        getSheetError(
            'يجب ان يكون رقم الهاتف يحتوي على 10 ارقام دون كتابة الصفر في البداية');
        return false;
      }
    }
    getSheetError('يرجى تعبئة البيانات');
    return false;
  }

  void saveData() {
    UserModel user = UserModel.addUser(
        phoneAuthUid: '',
        emailAuthUid: '',
        name: _name.text,
        phone: _phone.text,
        adderss: _adderss.text,
        city: _city.text,
        email: _email.text,
        provider: AppPreferences().getData(key: 'provider').isNotEmpty
            ? AppPreferences().getData(key: 'provider')
            : 'email',
        fcm: fcm,
        image: AppPreferences().getData(key: 'image').isNotEmpty
            ? AppPreferences().getData(key: 'image')
            : imageUrl,
        password: _password.text,
        isVerifyPhone: false);
    SVProgressHUD.dismiss();
    Get.to(OTPScreen(_phone.text, user));

    // Get.to(VerificationScreen(
    //   userModel: user,
    // ));
  }

  //ToDo:get fcm
  Future<void> getToken() async {
    fcm = await FirebaseMessaging.instance.getToken() ?? 'No Token';
    debugPrint('here login token $fcm');
  }

  Future<bool> checkPhoneFromFirestore() async {
    Map<String, dynamic>? data = await FirebaseFirestoreController()
        .getUserUid(phone: '+1${_phone.text}');
    if (data.isNull) {
      return true;
    }
    SVProgressHUD.dismiss();

    getSheetError('رقم الهاتف موجود مسبقا !');

    return false;
  }

  Future<void> perform() async {
    if (await checkData()) {
      SVProgressHUD.show();

      if (await checkPhoneFromFirestore()) {
        saveData();
      }
    }
  }
}
