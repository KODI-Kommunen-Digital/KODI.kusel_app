import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/image_utility.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/screens/utility/image_loader_utility.dart';

class PlaceOfAnotherCommunityCard extends ConsumerStatefulWidget {
  String text;
  String imageUrl;
  bool isFav;
  int sourceId;
  void Function()? onTap;

  PlaceOfAnotherCommunityCard(
      {super.key,
      required this.sourceId,
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
    return GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
          height: 70.h,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10.r)),
          child: Row(
            children: [
              ImageUtil.loadNetworkImage(
                  imageUrl: widget.imageUrl,
                  sourceId: widget.sourceId,
                  height: 40.h,
                  width: 40.w,
                  fit: BoxFit.contain,
                  context: context),
              25.horizontalSpace,
              Flexible(
                child: textRegularMontserrat(
                    textAlign: TextAlign.start,
                    text: widget.text,
                    textOverflow: TextOverflow.visible,
                    fontSize: 14),
              ),
            ],
          ),
        ));
  }
}
