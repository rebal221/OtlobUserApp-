import 'dart:ui';

import 'package:get/get.dart';
import 'package:otlob/services/preferences/app_preferences.dart';

class AppGet extends GetxController {
  Locale localeUse = const Locale('ar', 'AE');

  setUpdateLocale({required Locale locale}) {
    if (locale == const Locale('en', 'US')) {
      AppPreferences().saveLocale(languageCode: 'en', countryCode: 'US');
    } else if (locale == const Locale('ar', 'AE')) {
      AppPreferences().saveLocale(languageCode: 'ar', countryCode: 'AE');
    } else if (locale == const Locale('fr', 'FR')) {
      AppPreferences().saveLocale(languageCode: 'fr', countryCode: 'FR');
    } else if (locale == const Locale('ru', 'RU')) {
      AppPreferences().saveLocale(languageCode: 'ru', countryCode: 'RU');
    }
    Get.updateLocale(locale);
  }
}
