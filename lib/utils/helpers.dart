import 'package:flutter/material.dart';
import 'package:otlob/value/constant.dart';

mixin Helpers {
  void showSnackBar(
      {required BuildContext context,
      required String content,
      bool error = false}) {
    if (!error) {
      getSheetSucsses(content);
    } else {
      getSheetError(content);
    }
  }
}
