import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/fliter_screen/fliter_screen_state.dart';

final filterScreenProvider =
    StateNotifierProvider<FilterScreenProvider, FilterScreenState>(
        (ref) => FilterScreenProvider());

class FilterScreenProvider extends StateNotifier<FilterScreenState> {
  FilterScreenProvider() : super(FilterScreenState.empty());

  void updateSlider(double value) {
    state = state.copyWith(sliderValue: value);
  }

  void onDropdownItemSelected(String newValue, DropdownType dropdownType) {
    switch (dropdownType) {
      case DropdownType.period:
        state = state.copyWith(periodValue: newValue);
      case DropdownType.targetGroup:
        state = state.copyWith(targetGroupValue: newValue);
      case DropdownType.ort:
        state = state.copyWith(ortItemValue: newValue);
    }
  }

  void onSortByButtonTap(String buttonType) {
    bool isActualityEnabled = state.isActualityEnabled;
    bool isDistanceEnabled = state.isDistanceEnabled;

    if (buttonType == "Actuality") {
      state = state.copyWith(
        isActualityEnabled: !isActualityEnabled,
        isDistanceEnabled: false,
      );
    } else if (buttonType == "Distance") {
      state = state.copyWith(
        isDistanceEnabled: !isDistanceEnabled,
        isActualityEnabled: false,
      );
    }
  }

  void onToggleUpdate(bool value, String type) {
    final updatedMap = Map<String, bool>.from(state.toggleFiltersMap);
    updatedMap[type] = value;
    state = state.copyWith(toggleFiltersMap: updatedMap);
  }

  void onApplyChanges() {}

  void onCancel() {}

  void onReset() {
    state = FilterScreenState.empty();
  }
}

enum DropdownType { period, targetGroup, ort }
