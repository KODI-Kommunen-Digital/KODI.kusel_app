import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common_widgets/text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../digifit_exercise_details_controller.dart';
import 'digifit_card_exercise_details_controller.dart';

class InfoCardWidget extends ConsumerStatefulWidget {
  const InfoCardWidget({super.key});

  @override
  ConsumerState<InfoCardWidget> createState() => _InfoCardWidgetState();
}

class _InfoCardWidgetState extends ConsumerState<InfoCardWidget> {
  @override
  Widget build(BuildContext context) {
    final digifitExerciseUserProgress = ref
        .watch(digifitExerciseDetailsControllerProvider)
        .digifitExerciseEquipmentModel
        ?.userProgress;

    final iconBackgroundVisibility = ref
        .watch(digifitCardExerciseDetailsControllerProvider)
        .isIconBackgroundVisible;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 16.h,
        right: 24.w,
        bottom: 8.h,
        left: 24.w,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    textBoldPoppins(
                      text: AppLocalizations.of(context).digifit_exercise_set,
                      fontSize: 16.sp,
                      color: Colors.black87,
                    ),
                    SizedBox(height: 6.h),
                    textRegularMontserrat(
                      text:
                          '${digifitExerciseUserProgress?.currentSet} / ${digifitExerciseUserProgress?.totalSets}',
                      color: Colors.black,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    textBoldPoppins(
                      text: AppLocalizations.of(context).digifit_exercise_reps,
                      fontSize: 16.sp,
                      color: Colors.black87,
                    ),
                    SizedBox(height: 6.h),
                    textRegularMontserrat(
                      text: '${digifitExerciseUserProgress?.repetitionsPerSet}',
                      color: Colors.black,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 18.h, bottom: 6.h, left: 40.h),
            child: GestureDetector(
              onTap: () {
                final isVisible = ref
                    .read(digifitCardExerciseDetailsControllerProvider)
                    .isCheckIconVisible;
                ref
                    .read(digifitCardExerciseDetailsControllerProvider.notifier)
                    .updateCheckIconVisibility(!isVisible);

                ref
                    .read(digifitCardExerciseDetailsControllerProvider.notifier)
                    .updateIconBackgroundVisibility(false);
              },
              child: Container(
                width: 52.w,
                height: 52.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).disabledColor,
                    width: 1.5,
                  ),
                ),
                child: CircleAvatar(
                  radius: 24.r,
                  backgroundColor: iconBackgroundVisibility
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                  child: Icon(
                    Icons.check,
                    color: iconBackgroundVisibility
                        ? Colors.white
                        : Theme.of(context).disabledColor,
                    size: 28.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
