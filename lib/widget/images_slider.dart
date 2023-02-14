import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:otlob/widget/component.dart';

import '../server/controller/app_controller.dart';

class SliderImages extends StatefulWidget {
  SliderImages({super.key, required this.imageUrls});
  final List imageUrls;

  @override
  State<SliderImages> createState() => _SliderImagesState();
}

int _currentIndex = 0;

class _SliderImagesState extends State<SliderImages> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            // enlargeCenterPage: true,
            //scrollDirection: Axis.vertical,
            onPageChanged: (index, reason) {
              setState(
                () {
                  _currentIndex = index;
                },
              );
            },
          ),
          items: widget.imageUrls
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Card(
                    elevation: 3.0,
                    shadowColor: HexColor(AppController.hexColorPrimary.value),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: CachedNetworkImage(
                              imageUrl: item,
                              // height: 72.h,
                              // width: 72.w,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) =>
                                  shimmerCarDes(context),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.imageUrls.map((urlOfItem) {
            int index = widget.imageUrls.indexOf(urlOfItem);
            return Container(
              width: 10.0,
              height: 10.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index
                    ? HexColor(AppController.hexColorPrimary.value)
                    : Color.fromRGBO(0, 0, 0, 0.3),
              ),
            );
          }).toList(),
        )
      ],
    );
  }
}
