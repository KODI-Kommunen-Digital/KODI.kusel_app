import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/mobility_screen/mobility_screen_state.dart';

final mobilityScreenProvider = StateNotifierProvider.autoDispose<
    MobilityScreenProvider,
    MobilityScreenState>((ref) => MobilityScreenProvider());

class MobilityScreenProvider extends StateNotifier<MobilityScreenState> {
  MobilityScreenProvider() : super(MobilityScreenState.empty());
}
