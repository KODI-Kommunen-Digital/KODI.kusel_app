import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kusel/screens/onboarding/onboarding_screen_provider.dart';

import '../../common_widgets/interests_grid_card_view.dart';

class OnBoardingPreferencesPage extends ConsumerStatefulWidget {
  const OnBoardingPreferencesPage({super.key});

  @override
  ConsumerState<OnBoardingPreferencesPage> createState() =>
      _OnBoardingPreferencesPageState();
}

class _OnBoardingPreferencesPageState extends ConsumerState<OnBoardingPreferencesPage> {

  @override
  Widget build(BuildContext context) {
    String userName  = ref.read(onboardingScreenProvider).userFirstName ?? '';
    String displayMsg =
        "${AppLocalizations.of(context).complete}$userName${AppLocalizations.of(context).what_interest_you}";
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.w, horizontal: 18.h),
          child: Column(
            children: [
              65.verticalSpace,
              textBoldPoppins(
                  text: displayMsg,
                  fontSize: 18,
                  textOverflow: TextOverflow.visible,
                  color: Theme.of(context).textTheme.bodyLarge?.color),
              20.verticalSpace,
              categoryView(context),
              120.verticalSpace
            ],
          ),
        ),
      ),
    );
  }

  categoryView(BuildContext context) {
    final state = ref.watch(onboardingScreenProvider);
    final stateNotifier = ref.read(onboardingScreenProvider.notifier);
    return GridView.builder(
        padding: EdgeInsets.only(top: 0),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisExtent: 135.h),
        itemCount: state.interests.length,
        itemBuilder: (BuildContext context, int index) {
          var interest = state.interests[index];
          final isSelected = state.interestsMap[interest.id] ?? false;
          return GestureDetector(
            onTap: () {
              stateNotifier.updateInterestMap(interest.id);
            },
            child: InterestsGridCardView(
              imageUrl: interest.image ?? "",
              title: interest.name ?? '',
              isSelected: isSelected,
            ),
          );
        });
  }

}
