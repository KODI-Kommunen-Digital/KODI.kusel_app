import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/screens/digifit_screens/digifit_exercise_detail/video_player/video_player_controller.dart';
import 'package:video_player/video_player.dart';

import '../../../../common_widgets/text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../digifit_exercise_details_controller.dart';

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
    final videoControllerState = ref.watch(videoPlayerControllerProvider);

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
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
                        child: ValueListenableBuilder(
                          valueListenable: controller,
                          builder: (context, VideoPlayerValue value, _) {
                            return Stack(
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
                                if (!value.isPlaying)
                                  SizedBox(
                                    width: double.infinity,
                                    height: 300.h,
                                    child: Center(
                                      child: Icon(
                                        Icons.play_arrow,
                                        size: 52.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                Positioned(
                                  bottom: 12.h,
                                  left: 12.w,
                                  right: 12.w,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _formatDuration(value.position),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.sp),
                                      ),
                                      Text(
                                        _formatDuration(value.duration),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.sp),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
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
                    _buildInfoCard(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildAlignedText(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 52.w,
              height: 52.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).disabledColor,
                  width: 1.2,
                ),
              ),
              child: Icon(
                Icons.check,
                size: 25.sp,
                color: Theme.of(context).disabledColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlignedText() {
    final digifitExerciseUserProgress = ref
        .watch(digifitExerciseDetailsControllerProvider)
        .digifitExerciseEquipmentModel
        ?.userProgress;

    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    '${digifitExerciseUserProgress?.currentSet}/${digifitExerciseUserProgress?.totalSets}',
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
    );
  }
}

String _formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));
  return '$minutes:$seconds';
}