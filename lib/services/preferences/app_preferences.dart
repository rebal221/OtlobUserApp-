import 'dart:convert';
import 'dart:developer';

import 'package:otlob/utils/helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../server/firebase_auth.dart';

class AppPreferences with Helpers {
  static final AppPreferences _instance = AppPreferences._internal();
  late SharedPreferences _sharedPreferences;
  static final Map<String, dynamic> userData =
      AppPreferences().getUserDataAsMap();

  factory AppPreferences() {
    return _instance;
  }

  AppPreferences._internal();

  Future<void> initPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> clear() async {
    await _sharedPreferences.clear();
  }

  Future<void> setFCM(String fcm) async {
    await _sharedPreferences.setString(AppPrefKey.fcm, fcm);
  }

  String getFCM() {
    return _sharedPreferences.getString(AppPrefKey.fcm) ?? '';
  }

  //
  Future<void> saveTokenUser({required String token}) async {
    await _sharedPreferences.setString('tokenUser', token);
  }

  Future<void> saveLocale(
      {required String languageCode, required String countryCode}) async {
    await _sharedPreferences.setString('languageCode', languageCode);
    await _sharedPreferences.setString('countryCode', countryCode);
  }

  String get getLanguageCode =>
      _sharedPreferences.getString('languageCode') ?? 'ar';

  String get getCountryCode =>
      _sharedPreferences.getString('countryCode') ?? 'AE';

  Future<void> logOutUser() async {
    await _sharedPreferences.clear();
    await FirebaseAuthController().signOut();

    // await Get.offAll(ChooseScreen());
  }

  Future<void> clearKey(key) async {
    await _sharedPreferences.remove(key);
  }

  Future<void> setLoggedIn() async {
    log('setLoggedIn done');
    await _sharedPreferences.setBool('logged_in', true);
  }

  bool get loggedIn => _sharedPreferences.getBool('logged_in') ?? false;

  Future<void> setData({required String key, required String value}) async {
    await _sharedPreferences.setString(key, value);
  }

  String getData({required String key}) {
    return _sharedPreferences.getString(key) ?? '';
  }

  Future<void> setDataList(
      {required String key, required List<String> value}) async {
    await _sharedPreferences.setStringList(key, value);
  }

  List<String> getDataList({required String key}) {
    return _sharedPreferences.getStringList(key) ?? [];
  }

  Future<void> setDataBool({required String key, required bool value}) async {
    await _sharedPreferences.setBool(key, value);
  }

  bool getDataBool({required String key}) {
    return _sharedPreferences.getBool(key) ?? false;
  }

  Future<void> setDataDouble(
      {required String key, required double value}) async {
    await _sharedPreferences.setDouble(key, value);
  }

  double getDataDouble({required String key}) {
    return _sharedPreferences.getDouble(key) ?? 0.0;
  }

  Future<void> setDataInt({required String key, required int value}) async {
    await _sharedPreferences.setInt(key, value);
  }

  int getDataInt({required String key}) {
    return _sharedPreferences.getInt(key) ?? 0;
  }

  Future<void> setAccountType(String value) async {
    await _sharedPreferences.setString("type", value);
  }

  Future<void> saveUserData(userDataMap) async {
    String encodedMap = json.encode(userDataMap);
    log(' saver user data => $encodedMap');
    await setLoggedIn();
    await _sharedPreferences.setString('userData', encodedMap);
  }

  Map<String, dynamic> getUserDataAsMap() {
    Map<String, dynamic> w = {};
    String encodedMap = _sharedPreferences.getString('userData') ?? '';
    if (encodedMap.isNotEmpty) {
      log('user data => ${json.decode(encodedMap)}');
      return json.decode(encodedMap);
    } else {
      return w;
    }
  }

  String get accountType => _sharedPreferences.getString("type") ?? "";
}

class AppPrefKey {
  static const uid = "uid";
  static const name = "name";
  static const email = "email";
  static const isAdmin = "isAdmin";
  static const phone = "phone";
  static const password = "password";
  static const fcm = "fcm";
  static const area = "area";
  static const latitudeLogin = "latitudeLogin";
  static const latitudeLogout = "latitudeLogout";
  static const longitudeLogin = "longitudeLogin";
  static const longitudeLogout = "longitudeLogout";
  static const loginTime = "loginTime";

  static const logoutTime = "logoutTime";
  static const countLocalItem = "countLocalItem";
}
