// ignore_for_file: invalid_use_of_protected_member

import 'dart:developer';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otlob/server/model/app_model.dart';

import '../firebase_store.dart';

class AppController extends GetxController {
  static RxString hexColorPrimary = ''.obs;
  static RxString hexColorSecond = ''.obs;
  static RxString logoApp = ''.obs;

  // static RxMap<dynamic, dynamic> data = {}.obs;

  RxList<AppModel> appModelList = <AppModel>[].obs;
  static Rx<AppModel> appData = AppModel().obs;

  // Rx<AppModel> model = AppModel().obs;

  ///data
  //primaryColor
  //secondColor
  //appLogo
  //appName
  //appPhone
  //appPrivacy
  //appOnGooglePlay
  //appOnAppstore
  //appFacebook
  //appTwitter
  //appYoutube
  //appActive
  //appVersionGoogle
  //appVersionAppStore
  @override
  void onReady() {
    // TODO: implement onReady
    getAppInfoStart();
    appError();

    super.onReady();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    getAppInfoStart();
    appError();
    super.onInit();
  }

  // Future<void> getAppInfo() async {
  //   appModelList.bindStream(FirebaseFirestoreController().appDataList());
  //   getAppColor();
  //   log('message**********');
  //   log('data . value = >> ${appModelList.first}');
  //   log('color is hexColorPrimary ${AppController.hexColorPrimary.value}');
  //   log('color is hexColorSecond ${AppController.hexColorSecond.value}');
  // }

  Future<bool> getAppInfoStart() async {
    appModelList.bindStream(FirebaseFirestoreController().appDataList());

    Future.delayed(const Duration(seconds: 1), () {
      if (appModelList.value.isNotEmpty) {
        log('message********** true');
        return true;
      } else {
        log('message********** false');

        return false;
      }
    });
    return true;
  }

  static void getAppData(AppModel appModel) {
    AppController.hexColorPrimary.value = appModel.primaryColor;
    AppController.hexColorSecond.value = appModel.secondColor;
    AppController.logoApp.value = appModel.appLogo;
    appData.value = appModel;
    log('from app data =>> ${appData.value.appLogo}');
  }

  void appError() async {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  }
}
