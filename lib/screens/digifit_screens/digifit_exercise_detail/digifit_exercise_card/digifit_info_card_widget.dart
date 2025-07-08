import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common_widgets/text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../digifit_exercise_details_controller.dart';
import '../enum/digifit_exercise_session_status_enum.dart';

class InfoCardWidget extends ConsumerStatefulWidget {
  final VoidCallback startTimer;

  const InfoCardWidget({super.key, required this.startTimer});

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

    int currentSet =
        ref.watch(digifitExerciseDetailsControllerProvider).currentSetNumber;

    int totalSet =
        ref.watch(digifitExerciseDetailsControllerProvider).totalSetNumber;

    final isReadyToSubmitSet =
        ref.watch(digifitExerciseDetailsControllerProvider).isReadyToSubmitSet;

    final isScanButtonVisible =
        ref.watch(digifitExerciseDetailsControllerProvider).isScannerVisible;

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
                      text: '$currentSet / $totalSet',
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
              onTap: (isScanButtonVisible || !isReadyToSubmitSet)
                  ? null
                  : () {
                      bool? isComplete = ref
                          .read(digifitExerciseDetailsControllerProvider)
                          .digifitExerciseEquipmentModel
                          ?.userProgress
                          .isCompleted;

                      if (isComplete != null && !isComplete) {
                        int currentSet = ref
                            .read(digifitExerciseDetailsControllerProvider)
                            .currentSetNumber;
                        int totalSets = ref
                            .read(digifitExerciseDetailsControllerProvider)
                            .totalSetNumber;

                        final digifitExerciseDetailsControllerState =
                            ref.read(digifitExerciseDetailsControllerProvider);

                        int locationId = ref
                            .read(digifitExerciseDetailsControllerProvider)
                            .locationId;

                        ExerciseStageConstant stage;

                        if (currentSet == totalSets - 1) {
                          stage = ExerciseStageConstant.complete;
                        } else {
                          stage = ExerciseStageConstant.progress;
                        }

                        ref
                            .read(digifitExerciseDetailsControllerProvider
                                .notifier)
                            .trackExerciseDetails(
                                digifitExerciseDetailsControllerState
                                        .digifitExerciseEquipmentModel?.id ??
                                    0,
                                locationId,
                                currentSet,
                                digifitExerciseDetailsControllerState
                                        .digifitExerciseEquipmentModel
                                        ?.userProgress
                                        .repetitionsPerSet ??
                                    0,
                                stage, () {
                          ref
                              .read(digifitExerciseDetailsControllerProvider
                                  .notifier)
                              .updateIsReadyToSubmitSetVisibility(false);

                          widget.startTimer();
                        });
                      }
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
                  backgroundColor: (!isScanButtonVisible && isReadyToSubmitSet)
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                  child: Icon(
                    Icons.check,
                    color: (!isScanButtonVisible && isReadyToSubmitSet)
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
