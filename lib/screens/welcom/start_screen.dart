import 'dart:developer';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:otlob/screens/welcom/splash_screen.dart';
import 'package:otlob/server/controller/app_controller.dart';
import 'package:otlob/services/preferences/app_preferences.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  AppController controller = Get.find();

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log('start screen ====>>> build');
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ShowcaseCard(
          child: Image.asset(
            circularProgressIndicatorSmall,
            scale: 2,
            color: Colors.amber.shade600,
          ),
        ),
      ),
    );
  }

  Future<void> getData() async {
    bool status = await controller.getAppInfoStart();

    Future.delayed(const Duration(seconds: 1), () {
      log('status is $status');
      if (status) {
        Future.delayed(const Duration(seconds: 1), () {
          Get.offAll(const SplashScreen());
        });
      }
    });
  }
}

class ShowcaseCard extends StatelessWidget {
  final Widget child;
  final double width;
  final String? label;
  final String? caption;

  const ShowcaseCard({
    Key? key,
    required this.child,
    this.width = 200,
    this.label,
    this.caption,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (label != null)
          Container(
            width: width,
            margin: const EdgeInsets.only(bottom: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                label!,
                style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF3A3A3C),
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        Card(
          margin: const EdgeInsets.fromLTRB(12, 4, 12, 24),
          elevation: kIsWeb ? 0 : 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          shadowColor: Colors.transparent,
          child: SizedBox(
            width: width,
            height: width,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                child,
                if (caption != null)
                  Positioned(
                    left: 0,
                    bottom: 0,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(12)),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                        child: Container(
                          width: width,
                          height: 30,
                          color: Colors.white30,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              caption!,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF8E8E93),
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
