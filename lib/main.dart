import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:otlob/firebase_options.dart';
import 'package:otlob/screens/welcom/start_screen.dart';
import 'package:otlob/server/controller/app_controller.dart';
import 'package:otlob/services/network/network_controller.dart';
import 'package:otlob/services/preferences/app_preferences.dart';

import 'lanugage/app_get.dart';
import 'lanugage/localString.dart';

void main() async {
  await initApp();
}

Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPreferences().initPreferences();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await FbNotifications.initNotifications();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  Get.put(AppController(), permanent: true);
  Get.put(AppGet(), permanent: true);
  Get.put(NetworkController(), permanent: true);
  runApp(const MyApp());
  (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  };
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.light,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, widget) {
        return GetMaterialApp(
          scrollBehavior: MyCustomScrollBehavior(),
          builder: (context, widget) {
            return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: widget!);
          },
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textTheme: TextTheme(
                titleSmall: TextStyle(color: Colors.white, fontSize: 14.sp)),
            appBarTheme: AppBarTheme(
              color: Colors.transparent,
              elevation: 0,
              // brightness: Brightness.dark,
              iconTheme: const IconThemeData(color: Colors.black),
              centerTitle: false,
              titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.normal),
            ),
          ),
          translations: LocalString(),
          locale: Locale(AppPreferences().getLanguageCode,
              AppPreferences().getCountryCode),
          // home:menu()
          home: const StartScreen(),
          // home: menu(currentItem: MenuItems.Home,),
        );
      },
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
