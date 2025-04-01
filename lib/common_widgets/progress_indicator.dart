import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension WidgetExtension on Widget {
  Widget loaderDialog(BuildContext context, bool isLoading) {
    if (isLoading) {
      return GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            this,
            Container(
              color: Colors.black.withValues(alpha: 0.5),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
              height: 100.h,
              width: 100.w,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      );
    }
    return this;
  }
}

