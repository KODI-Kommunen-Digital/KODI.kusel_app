import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/participate_screen/participate_screen_state.dart';

final participateScreenProvider = StateNotifierProvider.autoDispose<
    ParticipateScreenProvider,
    ParticipateScreenState>((ref) => ParticipateScreenProvider());

class ParticipateScreenProvider extends StateNotifier<ParticipateScreenState> {
  ParticipateScreenProvider() : super(ParticipateScreenState.empty());
}
