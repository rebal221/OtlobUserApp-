import 'package:otlob/utils/helpers.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class Launcher with Helpers {
  Launcher._();

  static final Launcher launcher = Launcher._();

  static launchPhone(String phone) {
    launchURL(url: 'tel:${phone.toString()}');
  }

  static launchWhatsapp(String phone) {
    launchURL(url: "https://wa.me/$phone?text=");
  }

  static launchEmail(String email) {
    launchURL(url: 'mailto:$email');
  }

  static launchURL({required String url, context}) async {
    // android , web
    if (await launchUrl(Uri.parse(url))) {
      // await launchUrl(Uri.parse(url));
    } else {
      showTopSnackBar(
        context,
        const CustomSnackBar.error(
          message: 'حدث خطأ',
        ),
      );
    }
  }
}
