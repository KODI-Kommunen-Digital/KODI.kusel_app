import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kusel/navigation/navigation.dart';
import 'package:kusel/screens/all_event/all_event_screen_controller.dart';
import 'package:kusel/screens/fliter_screen/filter_screen_controller.dart';

import '../../common_widgets/custom_dropdown.dart';
import '../../common_widgets/custom_toggle_button.dart';

class FilterScreen extends ConsumerStatefulWidget {
  const FilterScreen({super.key});

  @override
  ConsumerState<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends ConsumerState<FilterScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(child: _buildFilterScreenUi(context)),
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
      ),
    );
  }

  Widget _buildFilterScreenUi(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              textRegularPoppins(
                  text: AppLocalizations.of(context).settings,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.labelLarge?.color),
              GestureDetector(
                onTap: ref.read(filterScreenProvider.notifier).onReset,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.r),
                      border: Border.all(
                          width: 1, color: Theme.of(context).primaryColor)),
                  child: textRegularPoppins(
                      text: AppLocalizations.of(context).reset,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.labelLarge?.color),
                ),
              )
            ],
          ),
          16.verticalSpace,
          _buildDropdownSection(),
          13.verticalSpace,
          Padding(
            padding: EdgeInsets.only(left: 16.w),
            child: textRegularPoppins(
                text: AppLocalizations.of(context).perimeter,
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
                color: Theme.of(context).primaryColor),
          ),
          8.verticalSpace,
          _buildSlider(context, ref.watch(filterScreenProvider).sliderValue),
          15.verticalSpace,
          _buildSortBySection(),
          12.verticalSpace,
          _buildOptionsToggle(ref.watch(filterScreenProvider).toggleFiltersMap),
          Padding(
            padding: EdgeInsets.all(15.h.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    ref.read(navigationProvider).removeTopPage(context: context);
                  },
                  child: textRegularPoppins(
                      text: AppLocalizations.of(context).cancel,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                      color: Theme.of(context).primaryColor),
                ),
                _filterButton(
                    text: AppLocalizations.of(context).apply,
                    isEnabled: true,
                    context: context,
                    enableLeadingIcon: true,
                    onTap: () {
                      // ref.read(allEventScreenProvider.notifier).applyFilter();
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildDropdownSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(context, AppLocalizations.of(context).period),
        CustomDropdown(
          hintText: "Select ${AppLocalizations.of(context).period}",
          items: ref.read(filterScreenProvider).periodItems,
          selectedItem: ref.watch(filterScreenProvider).periodValue,
          onSelected: (String? newValue) {
            ref
                .read(filterScreenProvider.notifier)
                .onDropdownItemSelected(newValue ?? '', DropdownType.period);
          },
        ),
        10.verticalSpace,
        _buildLabel(context, AppLocalizations.of(context).target_group),
        CustomDropdown(
          hintText: "Select ${AppLocalizations.of(context).target_group}",
          items: ref.read(filterScreenProvider).targetGroupItems,
          selectedItem: ref.watch(filterScreenProvider).targetGroupValue,
          onSelected: (String? newValue) {
            ref.read(filterScreenProvider.notifier).onDropdownItemSelected(
                newValue ?? '', DropdownType.targetGroup);
          },
        ),
        10.verticalSpace,
        _buildLabel(context, AppLocalizations.of(context).ort),
        CustomDropdown(
          hintText: "Select ${AppLocalizations.of(context).ort}",
          selectedItem: ref.watch(filterScreenProvider).ortItemValue,
          items: ref.read(filterScreenProvider).ortItems,
          onSelected: (String? newValue) {
            ref
                .read(filterScreenProvider.notifier)
                .onDropdownItemSelected(newValue ?? '', DropdownType.ort);
          },
        ),
      ],
    );
  }

  Widget _buildSortBySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textBoldPoppins(
            text: AppLocalizations.of(context).sort_by,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).textTheme.labelLarge?.color),
        12.verticalSpace,
        Row(
          children: [
            _filterButton(
                text: AppLocalizations.of(context).actuality,
                isEnabled: ref.watch(filterScreenProvider).isActualityEnabled,
                context: context,
                enableLeadingIcon: false,
                onTap: () {
                  ref
                      .read(filterScreenProvider.notifier)
                      .onSortByButtonTap("Actuality");
                }),
            15.horizontalSpace,
            _filterButton(
                text: AppLocalizations.of(context).distance,
                isEnabled: ref.watch(filterScreenProvider).isDistanceEnabled,
                context: context,
                enableLeadingIcon: false,
                onTap: () {
                  ref
                      .read(filterScreenProvider.notifier)
                      .onSortByButtonTap("Distance");
                })
          ],
        ),
      ],
    );
  }

  Widget _buildSlider(BuildContext context, double sliderValue) {
    return Row(
      children: [
        Flexible(
          flex: 10,
          child: Slider(
            value: sliderValue,
            min: 0,
            max: 100,
            divisions: 100,
            label: sliderValue.round().toString(),
            onChanged: (double value) {
              ref.read(filterScreenProvider.notifier).updateSlider(value);
            },
          ),
        ),
        Flexible(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: textRegularPoppins(
                text: "${sliderValue.round().toString()} km",
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
                color: Theme.of(context).primaryColor),
          ),
        )
      ],
    );
  }

  Widget _buildOptionsToggle(Map<String, bool> toggleFilterMap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textBoldPoppins(
            text: AppLocalizations.of(context).options,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).textTheme.labelLarge?.color),
        8.verticalSpace,
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            boxShadow: [],
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Column(
              children: toggleFilterMap.entries.map((entry) {
                return _toggleWidget(
                    text: entry.key,
                    isToggled: entry.value,
                    onValueChange: (value, type) {
                      ref
                          .read(filterScreenProvider.notifier)
                          .onToggleUpdate(value, type);
                    });
              }).toList(),
            ),
          ),
        )
      ],
    );
  }

  Widget _toggleWidget(
      {required String text,
      required bool isToggled,
      required Function(bool value, String type) onValueChange}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(
        children: [
          CustomToggleButton(
              selected: isToggled,
              onValueChange: (value) => {onValueChange(value, text)}),
          Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: textRegularPoppins(
                text: text,
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
                color: Theme.of(context).primaryColor),
          ),
        ],
      ),
    );
  }

  Widget _filterButton(
      {required String text,
      required bool isEnabled,
      required bool enableLeadingIcon,
      required BuildContext context,
      required Function() onTap}) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
            color: isEnabled
                ? Theme.of(context).primaryColor
                : Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(30.sp)),
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 9.h),
        child: Row(
          children: [
            (enableLeadingIcon && isEnabled)
                ? Padding(
                    padding: EdgeInsets.only(right: 5.w),
                    child: Icon(
                      Icons.check,
                      color: Theme.of(context).canvasColor,
                      size: 20,
                    ),
                  )
                : Container(),
            textRegularPoppins(
                text: text,
                color: isEnabled
                    ? Theme.of(context).canvasColor
                    : Theme.of(context).primaryColor),
            5.horizontalSpace,
            (!enableLeadingIcon && isEnabled)
                ? Icon(
                    Icons.check,
                    color: Theme.of(context).canvasColor,
                    size: 20,
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(left: 12.w, bottom: 4.h),
      child: textSemiBoldPoppins(
        text: text,
        fontSize: 10.sp,
        color: Theme.of(context).textTheme.labelLarge?.color,
      ),
    );
  }
}
