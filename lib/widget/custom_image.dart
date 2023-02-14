import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_network/image_network.dart';
import 'package:otlob/server/controller/app_controller.dart';

class CustomPngImage extends StatelessWidget {
  final String? imageName;
  final double? height;
  final double? width;
  final BoxFit? boxFit;
  final Color? color;

  const CustomPngImage(
      {Key? key,
      this.imageName,
      this.height,
      this.width,
      this.boxFit,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'images/$imageName.png',
      color: color,
      height: height ?? 30.h,
      width: width ?? 30.w,
      fit: boxFit ?? BoxFit.contain,
      isAntiAlias: true,
    );
  }
}

class CustomJpgImage extends StatelessWidget {
  final String? imageName;
  final double? height;
  final double? width;
  final BoxFit? boxFit;
  final Color? color;

  const CustomJpgImage(
      {super.key,
      this.imageName,
      this.height,
      this.width,
      this.boxFit,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/$imageName.jpg',
      color: color,
      height: height ?? 30.h,
      width: width ?? 30.w,
      fit: boxFit ?? BoxFit.contain,
      isAntiAlias: true,
    );
  }
}

class CustomImageNetwork extends StatelessWidget {
  final String? imageUrl;
  final double? height;
  final double? width;
  final BoxFit? boxFit;
  final Color? color;

  const CustomImageNetwork(
      {super.key,
      this.imageUrl,
      this.height,
      this.width,
      this.boxFit,
      this.color});

  @override
  Widget build(BuildContext context) {
    return ImageNetwork(
      image: imageUrl ?? '',
      imageCache: CachedNetworkImageProvider(
        imageUrl ?? '',
      ),
      height: height ?? 30.h,
      width: width ?? 30.w,
      duration: 1,
      onPointer: true,
      debugPrint: true,
      fullScreen: true,
      curve: Curves.bounceInOut,
      fitAndroidIos: boxFit ?? BoxFit.contain,
      onLoading: CircularProgressIndicator(
        color: HexColor(AppController.appData.value.primaryColor),
        strokeWidth: 2.r,
        backgroundColor: Colors.white,
      ),
      // onLoading: shimmerAdsHomWidget(
      //     context: context, width: width ?? 30.w, height: height ?? 30.h),
      onError: const Icon(
        Icons.error,
        color: Colors.red,
      ),
    );
  }
}

class CustomSvgImage extends StatelessWidget {
  final String? imageName;
  final double? height;
  final double? width;
  final Color? color;
  final BoxFit? boxFit;

  const CustomSvgImage(
      {super.key,
      this.imageName,
      this.height,
      this.width,
      this.color,
      this.boxFit});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'images/$imageName.svg',
      height: height ?? 30.h,
      width: width ?? 30.w,
      fit: boxFit ?? BoxFit.contain,
      color: color,
    );
  }
}

class CustomSvgImageNetwork extends StatelessWidget {
  final String? imageName;
  final double? height;
  final double? width;
  final Color? color;
  final BoxFit? boxFit;

  const CustomSvgImageNetwork(
      {super.key,
      this.imageName,
      this.height,
      this.width,
      this.color,
      this.boxFit});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.network(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      imageName.toString(),
      height: height ?? 30.h,
      width: width ?? 30.w,
      fit: boxFit ?? BoxFit.contain,
      color: color,
    );
  }
}
