import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/custom_selection_button.dart';
import 'package:kusel/screens/onboarding/onboarding_screen_provider.dart';

import '../../common_widgets/text_styles.dart';

class OnboardingTypePage extends ConsumerStatefulWidget {
  const OnboardingTypePage({super.key});

  @override
  ConsumerState<OnboardingTypePage> createState() =>
      _OnboardingStartPageState();
}

class _OnboardingStartPageState extends ConsumerState<OnboardingTypePage> {

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingScreenProvider);
    final stateNotifier = ref.read(onboardingScreenProvider.notifier);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.w, horizontal: 18.h),
      child: Column(
        children: [
          65.verticalSpace,
          textBoldPoppins(
              text: AppLocalizations.of(context).ich_text,
              fontSize: 18,
              color: Theme.of(context).textTheme.bodyLarge?.color),
          20.verticalSpace,
          CustomSelectionButton(
              text:
                  "${AppLocalizations.of(context).live_here} ${AppLocalizations.of(context).kusel}",
              isSelected: state.isResident,
              onTap: () {
                stateNotifier.updateOnboardingType(OnBoardingType.resident);
              }),
          15.verticalSpace,
          CustomSelectionButton(
              text: "${AppLocalizations.of(context).spend_my_free_time_here} ${AppLocalizations.of(context).kusel}",
              isSelected: state.isTourist,
              onTap: () {
                stateNotifier.updateOnboardingType(OnBoardingType.tourist);
              }),
          12.verticalSpace,
          Visibility(
              visible: state.isErrorMsgVisible,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: textRegularPoppins(
                      text: AppLocalizations.of(context).please_select_the_field,
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 11),
                ),
              ))
        ],
      ),
    );
  }
}
