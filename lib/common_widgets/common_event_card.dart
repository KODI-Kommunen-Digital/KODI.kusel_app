import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:kusel/common_widgets/custom_shimmer_widget.dart';
import 'package:kusel/common_widgets/image_utility.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/screens/utility/image_loader_utility.dart';

class CommonEventCard extends ConsumerStatefulWidget {
  final String imageUrl;
  final String date;
  final String title;
  final String location;
  final bool isFavorite;
  final bool isFavouriteVisible;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final int sourceId;

  const CommonEventCard({
    Key? key,
    required this.imageUrl,
    required this.date,
    required this.title,
    required this.location,
    required this.isFavouriteVisible,
    required this.isFavorite,
    required this.sourceId,
    this.onTap,
    this.onFavorite,
  }) : super(key: key);

  @override
  ConsumerState<CommonEventCard> createState() => _CommonEventCardState();
}

class _CommonEventCardState extends ConsumerState<CommonEventCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ImageUtil.loadNetworkImage(
                    height: 75.h,
                    width: 80.w,
                    imageUrl: imageLoaderUtility(
                        image: widget.imageUrl, sourceId: widget.sourceId),
                    context: context),
              ),
              const SizedBox(width: 8),

              // Texts
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textRegularMontserrat(
                        text: formatDate(widget.date),
                        color: Theme.of(context).textTheme.labelMedium?.color),
                    const SizedBox(height: 4),
                    textSemiBoldMontserrat(text: widget.title),
                    const SizedBox(height: 2),
                    textRegularMontserrat(
                        text: widget.location,
                        color: Theme.of(context).textTheme.labelMedium?.color),
                  ],
                ),
              ),
              Visibility(
                visible: widget.isFavouriteVisible,
                child: InkWell(
                  onTap: widget.onFavorite,
                  child: Icon(
                    widget.isFavorite
                        ? Icons.favorite_sharp
                        : Icons.favorite_border,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
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

Widget eventCartShimmerEffect() {
  return ListTile(
    leading: CustomShimmerWidget.circular(height: 60.h, width: 60.w),
    title: CustomShimmerWidget.rectangular(
      height: 12.h,
    ),
    subtitle: CustomShimmerWidget.rectangular(
      height: 12.h,
    ),
  );
}
