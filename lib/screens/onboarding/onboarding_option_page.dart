import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kusel/screens/onboarding/onboarding_screen_provider.dart';

import '../../common_widgets/custom_dropdown.dart';
import '../../common_widgets/kusel_text_field.dart';
import '../../common_widgets/text_styles.dart';

class OnboardingOptionPage extends ConsumerStatefulWidget {
  final bool isResident;
  const OnboardingOptionPage({super.key, required this.isResident});

  @override
  ConsumerState<OnboardingOptionPage> createState() =>
      _OnboardingStartPageState();
}

class _OnboardingStartPageState extends ConsumerState<OnboardingOptionPage> {
  @override
  Widget build(BuildContext context) {
    return widget.isResident ? _buildResidentUi() : _buildTouristUi();
  }

  Widget _buildResidentUi() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.w, horizontal: 20.h),
      child: Column(
        children: [
          65.verticalSpace,
          textBoldPoppins(
              text: AppLocalizations.of(context).i_live_in_district,
              fontSize: 18.sp,
              color: Theme.of(context).colorScheme.secondary),
          20.verticalSpace,
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 12.w, bottom: 4.h),
              child: textSemiBoldPoppins(
                text: AppLocalizations.of(context).your_place_of_residence,
                fontStyle: FontStyle.italic,
                fontSize: 11.sp,
                color: Theme.of(context).textTheme.labelLarge?.color,
              ),
            ),
          ),
          CustomDropdown(
            hintText: AppLocalizations.of(context).select_residence,
            items: ref.read(onboardingScreenProvider).residenceList,
            selectedItem: ref.watch(onboardingScreenProvider).resident,
            textAlignCenter: true,
            onSelected: (String? newValue) {
            },
          ),
          20.verticalSpace,
          Divider(
            height: 3.h,
            color: Theme.of(context).dividerColor,
          ),
          20.verticalSpace,
          KuselTextField(
            textEditingController: TextEditingController(),
            hintText: AppLocalizations.of(context).alone,
            textAlign: TextAlign.center,
          ),
          12.verticalSpace,
          KuselTextField(
            textEditingController: TextEditingController(),
            hintText: AppLocalizations.of(context).for_two,
            textAlign: TextAlign.center,
          ),
          12.verticalSpace,
          KuselTextField(
            textEditingController: TextEditingController(),
            hintText: AppLocalizations.of(context).with_my_family,
            textAlign: TextAlign.center,
          ),
          20.verticalSpace,
          Divider(
            height: 3.h,
            color: Theme.of(context).dividerColor,
          ),
          20.verticalSpace,
          KuselTextField(
            textEditingController: TextEditingController(),
            hintText: AppLocalizations.of(context).with_dog,
            textAlign: TextAlign.center,
          ),
          12.verticalSpace,
          KuselTextField(
            textEditingController: TextEditingController(),
            hintText: AppLocalizations.of(context).back,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTouristUi() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.w, horizontal: 20.h),
      child: Column(
        children: [
          65.verticalSpace,
          textBoldPoppins(
              text: AppLocalizations.of(context).i_live_in_district,
              fontSize: 18.sp,
              color: Theme.of(context).colorScheme.secondary),
          20.verticalSpace,
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 12.w, bottom: 4.h),
              child: textSemiBoldPoppins(
                text: AppLocalizations.of(context).your_location,
                fontStyle: FontStyle.italic,
                fontSize: 11.sp,
                color: Theme.of(context).textTheme.labelLarge?.color,
              ),
            ),
          ),
          CustomDropdown(
            hintText: AppLocalizations.of(context).select_residence,
            items: ref.read(onboardingScreenProvider).residenceList,
            selectedItem: ref.watch(onboardingScreenProvider).resident,
            textAlignCenter: true,
            onSelected: (String? newValue) {
            },
          ),
          20.verticalSpace,
          Divider(
            height: 3.h,
            color: Theme.of(context).dividerColor,
          ),
          20.verticalSpace,
          KuselTextField(
            textEditingController: TextEditingController(),
            hintText: AppLocalizations.of(context).alone,
            textAlign: TextAlign.center,
          ),
          12.verticalSpace,
          KuselTextField(
            textEditingController: TextEditingController(),
            hintText: AppLocalizations.of(context).for_two,
            textAlign: TextAlign.center,
          ),
          12.verticalSpace,
          KuselTextField(
            textEditingController: TextEditingController(),
            hintText: AppLocalizations.of(context).with_my_family,
            textAlign: TextAlign.center,
          ),
          20.verticalSpace,
          Divider(
            height: 3.h,
            color: Theme.of(context).dividerColor,
          ),
          20.verticalSpace,
          KuselTextField(
            textEditingController: TextEditingController(),
            hintText: AppLocalizations.of(context).with_dog,
            textAlign: TextAlign.center,
          ),
          12.verticalSpace,
          KuselTextField(
            textEditingController: TextEditingController(),
            hintText: AppLocalizations.of(context).back,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
