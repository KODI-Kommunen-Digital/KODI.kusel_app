import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dashboard_screen_state.dart';

final dashboardScreenProvider = StateNotifierProvider.autoDispose<
        DashBoardScreenProvider, DashboardScreenState>(
    (ref) => DashBoardScreenProvider(
        sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider)));

class DashBoardScreenProvider extends StateNotifier<DashboardScreenState> {
  SharedPreferenceHelper sharedPreferenceHelper;

  DashBoardScreenProvider(
      { required this.sharedPreferenceHelper})
      : super(DashboardScreenState.empty());

  void onIndexChanged(int index) {

    bool canPop = false;
    if(index==0)
      {
        canPop=true;
      }
    state = state.copyWith(selectedIndex: index,canPop: canPop);
  }


}
