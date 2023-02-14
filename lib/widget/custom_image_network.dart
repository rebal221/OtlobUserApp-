import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class CustomImageNetworkCached extends StatelessWidget {
  final String? imageUrl;
  final double? height;
  final double? width;
  final BoxFit? boxFit;
  final Color? color;
  final double? iconSize;

  const CustomImageNetworkCached(
      {Key? key,
      this.imageUrl,
      this.height,
      this.iconSize,
      this.width,
      this.boxFit,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: imageUrl ?? '',
      color: color,
      height: height ?? 30.h,
      width: width ?? 30.w,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: boxFit ?? BoxFit.contain,
            isAntiAlias: true,
          ),
        ),
      ),
      placeholder: (context, url) =>
          shimmerImage(context: context, height: 300.h),
      errorWidget: (context, url, error) => Card(
          color: Colors.white,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 6,
          child: Icon(
            Icons.error,
            color: Colors.red,
            size: iconSize ?? 20.r,
          )),
    );
  }

  Widget shimmerImage({required BuildContext context, required double height}) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF63CCFF),
      highlightColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Container(
          decoration: BoxDecoration(
              color: const Color(0xFF63CCFF),
              borderRadius: BorderRadius.circular(20.r)),
          width: MediaQuery.of(context).size.width,
          height: height,
        ),
      ),
    );
  }
}
