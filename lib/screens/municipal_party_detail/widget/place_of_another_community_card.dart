import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/text_styles.dart';

class PlaceOfAnotherCommunityCard extends ConsumerStatefulWidget {
  String text;
  String imageUrl;
  bool isFav;
  void Function()? onTap;

   PlaceOfAnotherCommunityCard({super.key,
    required this.onTap,
    required this.imageUrl,
    required this.text,
    required this.isFav});

  @override
  ConsumerState<PlaceOfAnotherCommunityCard> createState() =>
      _PlaceOfAnotherCommunityCardState();
}

class _PlaceOfAnotherCommunityCardState
    extends ConsumerState<PlaceOfAnotherCommunityCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap:widget.onTap, child: Container(
      padding: EdgeInsets.symmetric(vertical: 8.h,horizontal: 10.w),
      height: 70.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CachedNetworkImage(
                imageUrl:
                widget.imageUrl,
                errorWidget: (context, val, _) {
                  return Icon(Icons.error);
                },
                progressIndicatorBuilder: (context, val, _) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
              16.horizontalSpace,
              textRegularMontserrat(text: widget.text,
                  fontSize: 16),

            ],
          ),
          Padding(
            padding:  EdgeInsets.only(right: 10.w),
            child: Icon(
              widget.isFav
                  ? Icons.favorite_sharp
                  : Icons.favorite_border_sharp,
              color:
              widget.isFav ? Colors.red : Colors.black,
              size: 25,
            ),
          )
        ],
      ),
    ));
  }
}
