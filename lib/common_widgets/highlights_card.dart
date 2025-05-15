import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:kusel/common_widgets/custom_shimmer_widget.dart';
import 'package:kusel/common_widgets/image_utility.dart';
import 'package:kusel/common_widgets/text_styles.dart';

import '../screens/utility/image_loader_utility.dart';

class HighlightsCard extends ConsumerStatefulWidget {
  final String imageUrl;
  final String? date;
  final String heading;
  final String description;
  final bool isFavourite;
  final VoidCallback onPress;
  final VoidCallback onFavouriteIconClick;
  final bool isVisible;
  final String? errorImagePath;
  final int sourceId;
  final double? imageWidth;
  final double? imageHeight;
  final BoxFit? imageFit;
  final double? cardWidth;
  final double? cardHeight;

  const HighlightsCard(
      {super.key,
      required this.sourceId,
      required this.imageUrl,
      this.date,
      required this.heading,
      required this.description,
      required this.isFavourite,
      required this.onPress,
      required this.onFavouriteIconClick,
      required this.isVisible,
      this.errorImagePath,
      this.imageFit,
      this.imageHeight,
      this.imageWidth,
      this.cardWidth,
      this.cardHeight});

  @override
  ConsumerState<HighlightsCard> createState() => _HighlightsCardState();
}

class _HighlightsCardState extends ConsumerState<HighlightsCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPress,
      borderRadius: BorderRadius.circular(25.r),
      child: Container(
        width: widget.cardWidth,
        height: widget.cardHeight,
        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.r),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.12),
              offset: const Offset(0, 4),
              blurRadius: 24,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: widget.imageHeight ?? 200.h,
              child: Stack(
                fit: StackFit.loose,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18.r),
                    child: SizedBox(
                      height: widget.imageHeight ?? 200.h,
                      width: widget.imageWidth ?? double.infinity,

                      child: ImageUtil.loadNetworkImage(
                          imageUrl: widget.imageUrl,
                          fit: widget.imageFit ?? BoxFit.cover,

                          sourceId: widget.sourceId,
                          svgErrorImagePath: widget.errorImagePath,
                          context: context),
                    ),
                  ),
                  if (widget.isVisible)
                    Positioned(
                      top: 8.h,
                      right: 8.w,
                      child: InkWell(
                        onTap: widget.onFavouriteIconClick,
                        borderRadius: BorderRadius.circular(50.r),
                        child: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            widget.isFavourite
                                ? Icons.favorite_sharp
                                : Icons.favorite_border_sharp,
                            color:
                                widget.isFavourite ? Colors.red : Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            10.verticalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (widget.date != null)
                    ? textSemiBoldMontserrat(
                        text: formatDate(widget.date ?? ""), fontSize: 14)
                    : SizedBox.shrink(),
                (widget.date != null) ? 4.verticalSpace : SizedBox.shrink(),
                textSemiBoldMontserrat(
                    text: widget.heading,
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyLarge?.color),
                4.verticalSpace,
                textSemiBoldMontserrat(
                    text: widget.description,
                    fontSize: 12,
                    textAlign: TextAlign.start,
                    color: Theme.of(context).textTheme.labelMedium?.color,
                    maxLines: 2),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String formatDate(String inputDate) {
    try {
      final DateTime parsedDate = DateTime.parse(inputDate);
      final DateFormat formatter = DateFormat('dd.MM.yyyy');
      return formatter.format(parsedDate);
    } catch (e) {
      return inputDate;
    }
  }
}

Widget highlightCardShimmerEffect() {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 14.w),
    child: Column(
      children: [
        CustomShimmerWidget.circular(
          height: 350.h,
          width: double.infinity,
          shapeBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        ),
        10.verticalSpace,
        CustomShimmerWidget.rectangular(
            height: 15.h,
            shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r))),
        10.verticalSpace,
        CustomShimmerWidget.rectangular(
            height: 15.h,
            shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r))),
        10.verticalSpace,
        CustomShimmerWidget.rectangular(
            height: 15.h,
            shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r))),
        10.verticalSpace,
        CustomShimmerWidget.rectangular(
            height: 15.h,
            shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r))),
      ],
    ),
  );
}
