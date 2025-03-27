import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_screen_state.dart';

final homeScreenProvider =
    StateNotifierProvider.autoDispose<HomeScreenProvider, HomeScreenState>(
        (ref) => HomeScreenProvider());

class HomeScreenProvider extends StateNotifier<HomeScreenState> {
  HomeScreenProvider() : super(HomeScreenState.empty());

  addCarouselListener(CarouselController carouselController) {
    final position = carouselController.position;
    final width = 317;
    if (position.hasPixels) {
      final index = (position.pixels / width).round();
      state = state.copyWith(highlightCount: index);
    }

    updateCarouselCard(int index) {
      state = state.copyWith(highlightCount: index);
    }
  }
}
