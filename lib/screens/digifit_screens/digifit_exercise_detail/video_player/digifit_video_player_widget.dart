import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/screens/digifit_screens/digifit_exercise_detail/digifit_exercise_details_controller.dart';
import 'package:kusel/screens/digifit_screens/digifit_exercise_detail/video_player/video_player_controller.dart';
import 'package:video_player/video_player.dart';

import '../digifit_exercise_card/digifit_exercise_timer_widget.dart';
import '../digifit_exercise_card/digifit_info_card_widget.dart';

class DigifitVideoPlayerWidget extends ConsumerStatefulWidget {
  final String videoUrl;

  const DigifitVideoPlayerWidget({
    super.key,
    required this.videoUrl,
  });

  @override
  ConsumerState<DigifitVideoPlayerWidget> createState() =>
      _DigifitVideoPlayerWidgetState();
}

class _DigifitVideoPlayerWidgetState
    extends ConsumerState<DigifitVideoPlayerWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(videoPlayerControllerProvider.notifier)
          .initializeVideoController(widget.videoUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildVideoPlayer(),
            SizedBox(height: 18.h),
            Visibility(
                visible: (ref
                            .watch(digifitExerciseDetailsControllerProvider)
                            .isScannerVisible ==
                        false &&
                    !ref
                        .watch(digifitExerciseDetailsControllerProvider)
                        .isReadyToSubmitSet),
                child: PauseCardWidget())
          ],
        ),
        Positioned(
          top: 270.h,
          left: 0.w,
          right: 0.w,
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(20.r),
            child: InfoCardWidget(),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoPlayer() {
    final videoControllerState = ref.watch(videoPlayerControllerProvider);

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
                      .read(videoPlayerControllerProvider.notifier)
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
