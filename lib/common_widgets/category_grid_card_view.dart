import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/text_styles.dart';

class CategoryGridCardView extends ConsumerStatefulWidget {
  final String title;
  final String imageUrl;
  final VoidCallback? onTap;

  const CategoryGridCardView({
    Key? key,
    required this.imageUrl,
    required this.title,
    this.onTap,
  }) : super(key: key);

  @override
  ConsumerState<CategoryGridCardView> createState() => _CommonEventCardState();
}

class _CommonEventCardState extends ConsumerState<CategoryGridCardView> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      elevation: 4,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 6.h, left: 6.w, right: 6.w),
            height: 85.h,
            width: 180.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: CachedNetworkImage(
                progressIndicatorBuilder: (context, value, _) => Center(
                  child: CircularProgressIndicator(),
                ),
                imageUrl: widget.imageUrl,
                errorWidget: (context, error, stackTrace) =>
                    Icon(Icons.broken_image, size: 80.w.h),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              width: 175.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: textRegularMontserrat(
                        text: widget.title, fontSize: 12),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
