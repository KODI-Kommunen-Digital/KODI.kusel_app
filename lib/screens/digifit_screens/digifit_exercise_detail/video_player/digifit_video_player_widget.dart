import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/screens/digifit_screens/digifit_exercise_detail/digifit_exercise_details_controller.dart';
import 'package:kusel/screens/digifit_screens/digifit_exercise_detail/video_player/video_player_controller.dart';
import 'package:video_player/video_player.dart';

import '../digifit_exercise_card/digifit_exercise_timer_widget.dart';
import '../digifit_exercise_card/digifit_info_card_widget.dart';
import '../digifit_exercise_card/digifit_success_card_widget.dart';

class DigifitVideoPlayerWidget extends ConsumerStatefulWidget {
  final String videoUrl;
  final VoidCallback startTimer;
  final VoidCallback pauseTimer;
  final int sourceId;
  final int equipmentId;

  const DigifitVideoPlayerWidget(
      {super.key,
      required this.videoUrl,
      required this.startTimer,
      required this.pauseTimer,
      required this.sourceId,
      required this.equipmentId});

  @override
  ConsumerState<DigifitVideoPlayerWidget> createState() =>
      _DigifitVideoPlayerWidgetState();
}

class _DigifitVideoPlayerWidgetState
    extends ConsumerState<DigifitVideoPlayerWidget> {
  @override
  void didUpdateWidget(covariant DigifitVideoPlayerWidget oldWidget) {
    if ((oldWidget.videoUrl != widget.videoUrl && widget.videoUrl.isNotEmpty) && (oldWidget.sourceId !=widget.sourceId && widget.sourceId!=0)) {
      debugPrint('print for this url is ${widget.sourceId} and ${widget.videoUrl}');
      ref
          .read(videoPlayerControllerProvider(widget.equipmentId).notifier)
          .initializeVideoController(widget.videoUrl, widget.sourceId);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildVideoPlayer(),
                SizedBox(height: 18.h),
                Visibility(
                    visible: (ref
                                .watch(digifitExerciseDetailsControllerProvider(widget.equipmentId))
                                .isScannerVisible ==
                            false &&
                        !ref
                            .watch(digifitExerciseDetailsControllerProvider(widget.equipmentId))
                            .isReadyToSubmitSet &&
                        (ref
                                    .watch(digifitExerciseDetailsControllerProvider(widget.equipmentId))
                                    .digifitExerciseEquipmentModel
                                    ?.userProgress
                                    .isCompleted !=
                                null &&
                            !ref
                                .watch(digifitExerciseDetailsControllerProvider(widget.equipmentId))
                                .digifitExerciseEquipmentModel!
                                .userProgress
                                .isCompleted)),
                    child: PauseCardWidget(
                      startTimer: widget.startTimer,
                      pauseTimer: widget.pauseTimer,
                      equipmentId: widget.equipmentId,
                    )),
              ],
            ),
            Positioned(
              top: 285.h,
              left: 0.w,
              right: 0.w,
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(20.r),
                child: InfoCardWidget(
                  startTimer: widget.startTimer,
                  equipmentId: widget.equipmentId,
                ),
              ),
            ),
          ],
        ),
        Visibility(
          visible: ref
                      .watch(digifitExerciseDetailsControllerProvider(widget.equipmentId))
                      .isScannerVisible ==
                  false &&
              !ref
                  .watch(digifitExerciseDetailsControllerProvider(widget.equipmentId))
                  .isReadyToSubmitSet &&
              ref
                      .watch(digifitExerciseDetailsControllerProvider(widget.equipmentId))
                      .digifitExerciseEquipmentModel
                      ?.userProgress
                      .isCompleted ==
                  true,
          child: Column(
            children: [
              SizedBox(height: 38.h),
              const SuccessCardWidget(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVideoPlayer() {
    final videoControllerState = ref.watch(videoPlayerControllerProvider(widget.equipmentId));

    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(20.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            videoControllerState.when(
              data: (controller) => GestureDetector(
                onTap: () {
                  ref
                      .read(videoPlayerControllerProvider(widget.equipmentId).notifier)
                      .playPauseVideo();
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 300.h,
                      child: ColoredBox(
                        color: Colors.transparent,
                        child: VideoPlayer(controller),
                      ),
                    ),
                    if (!controller.value.isPlaying)
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 2.5,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.play_arrow,
                                color: Theme.of(context).primaryColor,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              loading: () => Container(
                width: double.infinity,
                height: 300.h,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
                ),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
              error: (error, _) => Container(
                width: double.infinity,
                height: 300.h,
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.error, color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
