import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/utility/video_player_utility.dart';
import 'package:video_player/video_player.dart';

final videoPlayerControllerProvider = StateNotifierProvider.autoDispose<
    VideoControllerNotifier, AsyncValue<VideoPlayerController>>(
  (ref) => VideoControllerNotifier(),
);

class VideoControllerNotifier
    extends StateNotifier<AsyncValue<VideoPlayerController>> {
  VideoPlayerController? _controller;

  VideoControllerNotifier() : super(const AsyncLoading());

  Future<void> initializeVideoController(String videoUrl, int sourceId) async {
    // Dispose previous controller if any
    _controller?.dispose();


    String url = videoPlayerUtility(videoUrl, sourceId);
    final controller = VideoPlayerController.networkUrl(Uri.parse(url));

    try {
      await controller.initialize();
      controller.setVolume(1.0);
      _controller = controller;

      state = AsyncData(controller);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void playPauseVideo() {
    final controller = state.valueOrNull;
    if (controller != null) {
      controller.value.isPlaying ? controller.pause() : controller.play();
      state = AsyncData(controller);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}