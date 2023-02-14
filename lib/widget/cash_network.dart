// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'component.dart';

class CachNetwork extends StatelessWidget {
  // const CachNetwork({
  //   Key? key,
  // }) : super(key: key);

  String image;

  CachNetwork({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image,
      // height: 72.h,
      // width: 72.w,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => shimmerCarDes(context),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
