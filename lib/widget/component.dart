import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget shimmerCarDes(BuildContext context) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[400]!,
    highlightColor: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(0)),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      ),
    ),
  );
}