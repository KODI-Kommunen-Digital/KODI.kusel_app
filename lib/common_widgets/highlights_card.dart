import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/theme_manager/colors.dart';

class HighlightsCard extends ConsumerStatefulWidget {
  String imageUrl;
  String date;
  String heading;
  String description;
  bool isFavourite;
  Function() onPress;
  Function() onFavouriteIconClick;

  HighlightsCard(
      {super.key,
      required this.imageUrl,
      required this.date,
      required this.heading,
      required this.description,
      required this.isFavourite,
      required this.onPress,
      required this.onFavouriteIconClick});

  @override
  ConsumerState<HighlightsCard> createState() => _HighlightsCardState();
}

class _HighlightsCardState extends ConsumerState<HighlightsCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.h,horizontal: 9.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: lightThemeHighlightDotColor.withValues(alpha: 0.46),
            offset: Offset(0, 4),
            blurRadius: 24,
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18.r),
                child: SizedBox(
                  height: 250.h,
                  child: Image.asset(fit: BoxFit.cover, widget.imageUrl),
                ),
              ),
              Positioned(
                top: 5.h,
                left: 215.w,
                child: Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: lightThemeHighlightDotColor,
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  child: Icon(
                    Icons.favorite_border_sharp,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          6.verticalSpace,
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.all(8.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.date,
                    style: TextStyle(color: lightThemeTransportCardTextColor, fontSize: 12.sp),
                  ),
                  4.verticalSpace,
                  Text(widget.heading,
                      style: TextStyle(color: lightThemeSecondaryColor, fontSize: 13.sp)),
                  4.verticalSpace,
                  Text(widget.description,
                      style: TextStyle(color: lightThemeTransportCardTextColor, fontSize: 12.sp))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
