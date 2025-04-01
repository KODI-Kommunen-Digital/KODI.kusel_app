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
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      elevation: 4,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            // Adjust the radius as needed
            child: SizedBox(
              height: 120.h,
              width: 175.w,
              child: Image.network(
                widget.imageUrl,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.broken_image, size: 80.w.h),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            width: 175.w,
            height: 64.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 8.w),
                  child:
                      textRegularMontserrat(text: widget.title, fontSize: 16),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
