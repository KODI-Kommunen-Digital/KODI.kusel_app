import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/screens/digifit_screens/digifit_exercise_detail/digifit_exercise_details_controller.dart';


class PauseCardWidget extends ConsumerStatefulWidget {
  const PauseCardWidget({super.key});

  @override
  ConsumerState<PauseCardWidget> createState() => _PauseCardWidgetState();
}

class _PauseCardWidgetState extends ConsumerState<PauseCardWidget> {
  @override
  Widget build(BuildContext context) {
    final cardState = ref.watch(digifitExerciseDetailsControllerProvider);

    if (!cardState.isCheckIconVisible) {
      return SizedBox(height: 48.h);
    }

    return Material(
      elevation: 2,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(16.r),
        bottomRight: Radius.circular(16.r),
      ),
      child: Container(
        width: double.infinity,
        height: 102.h,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16.r),
            bottomRight: Radius.circular(16.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 16.h, left: 25.h),
              child: Text(
                'Pause',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF151846),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16.h, left: 30.h),
              child: Text(
                '00:00 Min',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 18.h, bottom: 6.h, left: 40.h),
              child: CircleAvatar(
                radius: 24.r,
                backgroundColor: const Color(0xFF233B8C),
                child: Icon(
                  Icons.skip_next_outlined,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
