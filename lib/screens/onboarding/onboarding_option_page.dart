import 'package:flutter/material.dart';
import 'package:kusel/common_widgets/device_helper.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/custom_selection_button.dart';
import 'package:kusel/screens/onboarding/onboarding_screen_provider.dart';

import '../../common_widgets/search_widget/search_widget.dart';
import '../../common_widgets/search_widget/search_widget_provider.dart';
import '../../common_widgets/text_styles.dart';

class OnboardingOptionPage extends ConsumerStatefulWidget {
  const OnboardingOptionPage({super.key});

  @override
  ConsumerState<OnboardingOptionPage> createState() =>
      _OnboardingStartPageState();
}

class _OnboardingStartPageState extends ConsumerState<OnboardingOptionPage> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<SearchStringWidgetState> _searchWidgetKey = GlobalKey();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ref.read(onboardingScreenProvider).isResident
        ? _buildResidentUi()
        : _buildTouristUi();
  }

  Widget _buildResidentUi() {
    final state = ref.watch(onboardingScreenProvider);
    final stateNotifier = ref.read(onboardingScreenProvider.notifier);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        _searchWidgetKey.currentState?.closeSuggestions();
        ref.read(searchProvider.notifier).clearSearch();
      },
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.w, horizontal: 20.h),
          child: Column(
            children: [
              65.verticalSpace,
              textBoldPoppins(
                  text: AppLocalizations.of(context).i_live_in_district,
                  fontSize: 20,
                  color: Theme.of(context).textTheme.bodyLarge?.color),
              20.verticalSpace,
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 12.w, bottom: 4.h),
                  child: textSemiBoldPoppins(
                    text: AppLocalizations.of(context).your_place_of_residence,
                    fontStyle: FontStyle.italic,
                    fontSize: 11,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
              _dropDownResidence(),
              20.verticalSpace,
              Divider(
                height: 3.h,
                color: Theme.of(context).dividerColor,
              ),
              20.verticalSpace,
              CustomSelectionButton(
                  text: AppLocalizations.of(context).alone,
                  isSelected: state.isSingle,
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    _searchWidgetKey.currentState?.closeSuggestions();
                    await stateNotifier.updateOnboardingFamilyType(
                        OnBoardingFamilyType.single);
                    stateNotifier.isAllOptionFieldsCompleted();
                  }),
              12.verticalSpace,
              CustomSelectionButton(
                  text: AppLocalizations.of(context).for_two,
                  isSelected: state.isForTwo,
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    _searchWidgetKey.currentState?.closeSuggestions();
                    await stateNotifier.updateOnboardingFamilyType(
                        OnBoardingFamilyType.withTwo);
                    stateNotifier.isAllOptionFieldsCompleted();
                  }),
              12.verticalSpace,
              CustomSelectionButton(
                  text: AppLocalizations.of(context).with_my_family,
                  isSelected: state.isWithFamily,
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    _searchWidgetKey.currentState?.closeSuggestions();
                    await stateNotifier.updateOnboardingFamilyType(
                        OnBoardingFamilyType.withMyFamily);
                    stateNotifier.isAllOptionFieldsCompleted();
                  }),
              20.verticalSpace,
              Divider(
                height: 3.h,
                color: Theme.of(context).dividerColor,
              ),
              20.verticalSpace,
              CustomSelectionButton(
                  text: AppLocalizations.of(context).with_dog,
                  isSelected: state.isWithDog,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    _searchWidgetKey.currentState?.closeSuggestions();
                    stateNotifier
                        .updateCompanionType(OnBoardingCompanionType.withDog);
                  }),
              12.verticalSpace,
              CustomSelectionButton(
                  text: AppLocalizations.of(context).barrierearm,
                  isSelected: state.isBarrierearm,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    _searchWidgetKey.currentState?.closeSuggestions();
                    stateNotifier.updateCompanionType(
                        OnBoardingCompanionType.barrierearm);
                  }),
              5.verticalSpace,
              Visibility(
                  visible: state.isErrorMsgVisible,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: textRegularPoppins(
                          text: AppLocalizations.of(context)
                              .please_select_the_field,
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 11),
                    ),
                  )),
              10.verticalSpace,
              if (DeviceHelper.isTablet(context)) 120.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTouristUi() {
    final stateNotifier = ref.read(onboardingScreenProvider.notifier);
    final state = ref.watch(onboardingScreenProvider);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.w, horizontal: 20.h),
          child: Column(
            children: [
              65.verticalSpace,
              textBoldPoppins(
                  text: AppLocalizations.of(context).i_am_visiting_the_district,
                  fontSize: 18,
                  color: Theme.of(context).textTheme.bodyLarge?.color),
              20.verticalSpace,
              Divider(
                height: 3.h,
                color: Theme.of(context).dividerColor,
              ),
              20.verticalSpace,
              CustomSelectionButton(
                  text: AppLocalizations.of(context).alone,
                  isSelected: state.isSingle,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    stateNotifier.updateOnboardingFamilyType(
                        OnBoardingFamilyType.single);
                  }),
              12.verticalSpace,
              CustomSelectionButton(
                  text: AppLocalizations.of(context).for_two,
                  isSelected: state.isForTwo,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    stateNotifier.updateOnboardingFamilyType(
                        OnBoardingFamilyType.withTwo);
                  }),
              12.verticalSpace,
              CustomSelectionButton(
                  text: AppLocalizations.of(context).with_my_family,
                  isSelected: state.isWithFamily,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    stateNotifier.updateOnboardingFamilyType(
                        OnBoardingFamilyType.withMyFamily);
                  }),
              20.verticalSpace,
              Divider(
                height: 3.h,
                color: Theme.of(context).dividerColor,
              ),
              20.verticalSpace,
              CustomSelectionButton(
                  text: AppLocalizations.of(context).with_dog,
                  isSelected: state.isWithDog,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    stateNotifier
                        .updateCompanionType(OnBoardingCompanionType.withDog);
                  }),
              12.verticalSpace,
              CustomSelectionButton(
                  text: AppLocalizations.of(context).barrierearm,
                  isSelected: state.isBarrierearm,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    stateNotifier.updateCompanionType(
                        OnBoardingCompanionType.barrierearm);
                  }),
              5.verticalSpace,
              Visibility(
                  visible: state.isErrorMsgVisible,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: textRegularPoppins(
                          text: AppLocalizations.of(context)
                              .please_select_the_field,
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 11),
                    ),
                  )),
              if (DeviceHelper.isTablet(context)) 100.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Widget _dropDownResidence() {
    final stateNotifier = ref.read(onboardingScreenProvider.notifier);
    final state = ref.watch(onboardingScreenProvider);

    if(state.resident!=null && state.resident!.isNotEmpty)
      {
        _searchController.text = state.resident!;
      }

    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowIndicator();
        return true;
      },
      child: SearchStringWidget(
        key: _searchWidgetKey,
        searchController: _searchController,
        isPaddingEnabled: true,
        suggestionCallback: (pattern) async {
          final list = state.residenceList;
          if (list.isEmpty) return [];

          if (pattern.trim().isEmpty) {
            return list;
          }

          return list
              .where((e) => e.toLowerCase().contains(pattern.toLowerCase()))
              .toList();
        },
        onItemClick: (selected) {
          _searchController.text = selected;
          stateNotifier.updateUserType(selected);
          stateNotifier.isAllOptionFieldsCompleted();
        },
      ),
    );
  }
}
