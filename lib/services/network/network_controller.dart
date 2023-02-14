import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otlob/value/constant.dart';

import '../../lanugage/app_get.dart';

class NetworkController extends GetxController {
  late var connectionStatus = 3.obs;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  AppGet appGet = Get.find();

  @override
  void onInit() {
    super.onInit();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<bool> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      log(e.toString());
    }
    return _updateConnectionStatus(result);
  }

  bool _updateConnectionStatus(ConnectivityResult result) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    switch (result) {
      case ConnectivityResult.wifi:
        connectionStatus.value = 1;
        log(connectionStatus.toString());

        log('ConnectivityResult.wifi');

        return true;
      case ConnectivityResult.mobile:
        connectionStatus.value = 2;
        log(connectionStatus.toString());
        log('ConnectivityResult.mobile');
        return true;
      case ConnectivityResult.none:
        connectionStatus.value = 0;
        log(connectionStatus.toString());
        log('ConnectivityResult.none');
        getSheetError('يرجى التحقق من اتصال الانترنت !');

        return false;
      default:
        getSheetError('يرجى التحقق من اتصال الانترنت !');
        return false;
    }
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }
}
