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
      physics: ClampingScrollPhysics(),
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
                child: _dropDownResidence()),
            20.verticalSpace,
            Divider(
              height: 3.h,
              color: Theme.of(context).dividerColor,
            ),
            20.verticalSpace,
            CustomSelectionButton(
                text: AppLocalizations.of(context).alone,
                isSelected: state.isSingle,
                onTap: () async{
                  await stateNotifier
                      .updateOnboardingFamilyType(OnBoardingFamilyType.single);
                  stateNotifier.isAllOptionFieldsCompleted();
                }),
            12.verticalSpace,
            CustomSelectionButton(
                text: AppLocalizations.of(context).for_two,
                isSelected: state.isForTwo,
                onTap: () async{
                  await stateNotifier
                      .updateOnboardingFamilyType(OnBoardingFamilyType.withTwo);
                  stateNotifier.isAllOptionFieldsCompleted();
                }),
            12.verticalSpace,
            CustomSelectionButton(
                text: AppLocalizations.of(context).with_my_family,
                isSelected: state.isWithFamily,
                onTap: () async{
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
                child: _dropDownResidence()),
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

  Widget _dropDownResidence() {
    final stateNotifier = ref.read(onboardingScreenProvider.notifier);
    final state = ref.watch(onboardingScreenProvider);

    Offset getPopupOffset(BuildContext context) {
      if (DeviceHelper.isMobile(context)) {
        return Offset(6, 64);
      } else {
        return Offset(16, 64);
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      child: PopupMenuButton<String>(
        offset: getPopupOffset(context), // Dynamic offset
        onSelected: (value) {
          stateNotifier.updateUserType(value);
        },
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem<String>(
              enabled: false,
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowIndicator();
                  return true;
                },
                child: SizedBox(
                  height: 200.h,
                  width: DeviceHelper.isMobile(context) ? 250.w : 300.w, // Device based width
                  child: ListView.builder(
                    itemCount:
                        ref.read(onboardingScreenProvider).residenceList.length,
                    itemBuilder: (context, index) {
                      final city = ref
                          .read(onboardingScreenProvider)
                          .residenceList[index];
                      return InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          stateNotifier.updateUserType(city);
                        },
                        child: Container(
                          constraints: const BoxConstraints(
                            maxHeight: 40,
                          ),
                          alignment: Alignment.centerLeft,
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(
                            city,
                            style: TextStyle(fontSize: 14, color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ];
        },
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        constraints: BoxConstraints(
          maxHeight: 200.h,
          minWidth: DeviceHelper.isMobile(context)
              ? 250.w
              : 300.w, // Device based constraints
        ),
        child: SizedBox(
          height: 50.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  state.resident ??
                      AppLocalizations.of(context).select_residence,
                  style: TextStyle(
                    fontSize: state.resident != null ? 14.sp : 13.sp,
                    color: state.resident != null
                        ? Theme.of(context).textTheme.labelMedium?.color
                        : Theme.of(context).hintColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
