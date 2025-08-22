import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/device_helper.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/screens/digifit_screens/digifit_exercise_detail/enum/digifit_exercise_session_status_enum.dart';

import '../l10n/app_localizations.dart';

class CommonBottomNavCard extends ConsumerStatefulWidget {
  final void Function() onBackPress;
  final void Function()? onFavChange;
  bool isFavVisible;
  bool isFav;
  ExerciseStageConstant? sessionStage;
  final VoidCallback? onSessionTap;

  CommonBottomNavCard(
      {super.key,
      required this.onBackPress,
      required this.isFavVisible,
      this.onFavChange,
      required this.isFav,
      this.sessionStage,
      this.onSessionTap});

  @override
  ConsumerState<CommonBottomNavCard> createState() =>
      _CommonBottomNavCardState();
}

class _CommonBottomNavCardState extends ConsumerState<CommonBottomNavCard> {
  @override
  Widget build(BuildContext context) {

    String buttonText = '';
    IconData icon = Icons.close;

    final canAbortTap = widget.sessionStage == ExerciseStageConstant.start ||
        widget.sessionStage == ExerciseStageConstant.progress;

    switch (widget.sessionStage) {
      case ExerciseStageConstant.initial:
        buttonText =
            AppLocalizations.of(context).digifit_exercise_details_start_session;
        icon = Icons.flag_outlined;
        break;

      case ExerciseStageConstant.start:
        buttonText = AppLocalizations.of(context).digifit_abort;
        icon = Icons.close;
        break;

      case ExerciseStageConstant.progress:
        buttonText = AppLocalizations.of(context).digifit_abort;
        icon = Icons.close;
        break;

      case ExerciseStageConstant.complete:
        buttonText = AppLocalizations.of(context).complete;
        icon = Icons.verified_outlined;
        break;

      default:
        buttonText = 'Start';
        icon = Icons.play_arrow;
        break;
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      height: 50.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          color: Theme.of(context).colorScheme.secondary),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 48.h,
            width: 48.w,
            child: IconButton(
              onPressed: widget.onBackPress,
              icon: Icon(
                size: DeviceHelper.isMobile(context) ? null : 12.h.w,
                Icons.arrow_back,
                color: Theme.of(context).canvasColor,
              ),
            ),
          ),
          Row(
            children: [
              Visibility(
                visible: widget.isFavVisible,
                child: GestureDetector(
                  onTap: widget.onFavChange,
                  child: SizedBox(
                    height: 30.h,
                    width: 30.w,
                    child: Icon(
                      size: DeviceHelper.isMobile(context) ? null : 12.h.w,
                      widget.isFav
                          ? Icons.favorite_sharp
                          : Icons.favorite_border,
                      color: !widget.isFav
                          ? Theme.of(context).canvasColor
                          : Theme.of(context).colorScheme.onTertiaryFixed,
                    ),
                  ),
                ),
              ),
              10.horizontalSpace,
              GestureDetector(
                onTap: canAbortTap ? widget.onSessionTap : null,
                child: Card(
                  color: Theme.of(context).primaryColor,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                    child: Row(
                      children: [
                        Icon(
                          icon,
                          color: Colors.white,
                          size: 18.h.w,
                        ),
                        8.horizontalSpace,
                        textBoldMontserrat(
                          text: buttonText,
                          color: Colors.white,
                          textOverflow: TextOverflow.visible,
                          fontSize: 13,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
