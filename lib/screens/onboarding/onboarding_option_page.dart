import 'package:flutter/material.dart';
import 'package:kusel/common_widgets/device_helper.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/custom_selection_button.dart';
import 'package:kusel/screens/onboarding/onboarding_screen_provider.dart';

import '../../common_widgets/text_styles.dart';

class OnboardingOptionPage extends ConsumerStatefulWidget {
  const OnboardingOptionPage({super.key});

  @override
  ConsumerState<OnboardingOptionPage> createState() =>
      _OnboardingStartPageState();
}

class _OnboardingStartPageState extends ConsumerState<OnboardingOptionPage> {

  @override
  Widget build(BuildContext context) {
    return ref.read(onboardingScreenProvider).isResident
        ? _buildResidentUi()
        : _buildTouristUi();
  }

  Widget _buildResidentUi() {
    final state = ref.watch(onboardingScreenProvider);
    final stateNotifier = ref.read(onboardingScreenProvider.notifier);
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.w, horizontal: 20.h),
        child: Column(
          children: [
            65.verticalSpace,
            textBoldPoppins(
                text: AppLocalizations.of(context).i_live_in_district,
                fontSize: 18,
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
            GestureDetector(
              onTap: (){
                FocusScope.of(context).unfocus();
              },
                child: _autoCompleteTextDropDown()),
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
                  stateNotifier
                      .updateOnboardingFamilyType(OnBoardingFamilyType.single);
                }),
            12.verticalSpace,
            CustomSelectionButton(
                text: AppLocalizations.of(context).for_two,
                isSelected: state.isForTwo,
                onTap: () {
                  stateNotifier
                      .updateOnboardingFamilyType(OnBoardingFamilyType.withTwo);
                }),
            12.verticalSpace,
            CustomSelectionButton(
                text: AppLocalizations.of(context).with_my_family,
                isSelected: state.isWithFamily,
                onTap: () {
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
                  stateNotifier
                      .updateCompanionType(OnBoardingCompanionType.withDog);
                }),
            12.verticalSpace,
            CustomSelectionButton(
                text: AppLocalizations.of(context).barrierearm,
                isSelected: state.isBarrierearm,
                onTap: () {
                  stateNotifier
                      .updateCompanionType(OnBoardingCompanionType.barrierearm);
                }),
            5.verticalSpace,
            Visibility(
                visible: state.isErrorMsgVisible,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: textRegularPoppins(
                        text:
                            AppLocalizations.of(context).please_select_the_field,
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 11),
                  ),
                )),
            5.verticalSpace,
            if(DeviceHelper.isTablet(context))
              100.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildTouristUi() {
    final stateNotifier = ref.read(onboardingScreenProvider.notifier);
    final state = ref.watch(onboardingScreenProvider);
    return SingleChildScrollView(
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
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 12.w, bottom: 4.h),
                child: textSemiBoldPoppins(
                  text: AppLocalizations.of(context).your_location,
                  fontStyle: FontStyle.italic,
                  fontSize: 11,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
            GestureDetector(
                onTap: (){
                  FocusScope.of(context).unfocus();
                },
                child: _autoCompleteTextDropDown()),
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
                  stateNotifier
                      .updateOnboardingFamilyType(OnBoardingFamilyType.single);
                }),
            12.verticalSpace,
            CustomSelectionButton(
                text: AppLocalizations.of(context).for_two,
                isSelected: state.isForTwo,
                onTap: () {
                  stateNotifier
                      .updateOnboardingFamilyType(OnBoardingFamilyType.withTwo);
                }),
            12.verticalSpace,
            CustomSelectionButton(
                text: AppLocalizations.of(context).with_my_family,
                isSelected: state.isWithFamily,
                onTap: () {
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
                  stateNotifier
                      .updateCompanionType(OnBoardingCompanionType.withDog);
                }),
            12.verticalSpace,
            CustomSelectionButton(
                text: AppLocalizations.of(context).barrierearm,
                isSelected: state.isBarrierearm,
                onTap: () {
                  stateNotifier
                      .updateCompanionType(OnBoardingCompanionType.barrierearm);
                }),
            5.verticalSpace,
            Visibility(
                visible: state.isErrorMsgVisible,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: textRegularPoppins(
                        text:
                            AppLocalizations.of(context).please_select_the_field,
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 11),
                  ),
                )),
            if(DeviceHelper.isTablet(context))
              100.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _autoCompleteTextDropDown() {
    final stateNotifier = ref.read(onboardingScreenProvider.notifier);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Autocomplete<String>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return const Iterable<String>.empty();
          }
          return ref.read(onboardingScreenProvider).residenceList.where(
                  (String city) => city
                  .toLowerCase()
                  .contains(textEditingValue.text.toLowerCase()));
        },
        onSelected: (String selection) {
          stateNotifier.updateUserType(selection ?? '');
          FocusScope.of(context).unfocus();
        },
        fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
          if(ref.read(onboardingScreenProvider).resident!=null){
            controller.text = ref.read(onboardingScreenProvider).resident!;
          }
          return TextField(
            textAlign: TextAlign.center,
            controller: controller,
            focusNode: focusNode,
            maxLines: 1,
            style: TextStyle(
              fontSize: 12.sp,
                color: Theme.of(context).textTheme.labelMedium?.color),
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context).select_residence,
              border: InputBorder.none,
            ),
          );
        },
        optionsViewBuilder: (context, onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 285.w,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final option = options.elementAt(index);
                    return ListTile(
                      title: Text(option),
                      onTap: () {
                        onSelected(option);
                      },
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
