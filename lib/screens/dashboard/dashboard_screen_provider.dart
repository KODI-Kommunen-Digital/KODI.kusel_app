import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:domain/model/request_model/user_detail/user_detail_request_model.dart';
import 'package:domain/model/response_model/user_detail/user_detail_response_model.dart';
import 'package:domain/usecase/user_detail/user_detail_usecase.dart';
import 'package:flutter/material.dart';
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

  void onItemTapped(int index) {
    state = state.copyWith(selectedIndex: index);
  }


}
