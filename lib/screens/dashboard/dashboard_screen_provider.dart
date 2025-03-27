import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dashboard_screen_state.dart';

final dashboardScreenProvider = StateNotifierProvider.autoDispose<
  DashBoardScreenProvider,
  DashboardScreenState>((ref) => DashBoardScreenProvider());

class DashBoardScreenProvider extends StateNotifier<DashboardScreenState> {
  DashBoardScreenProvider() : super(DashboardScreenState.empty());

  void onItemTapped(int index) {
      state = state.copyWith(selectedIndex: index);
  }
}
