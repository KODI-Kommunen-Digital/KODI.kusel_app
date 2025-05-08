import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/virtual_town_hall/virtual_town_hall_state.dart';

final virtualTownHallControllerProvider = StateNotifierProvider.autoDispose<
    VirtualTownHallController,
    VirtualTownHallState>((ref) => VirtualTownHallController());

class VirtualTownHallController extends StateNotifier<VirtualTownHallState> {
  VirtualTownHallController() : super(VirtualTownHallState.empty());
}
