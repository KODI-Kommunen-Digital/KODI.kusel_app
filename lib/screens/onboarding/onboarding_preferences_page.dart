import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kusel/screens/onboarding/onboarding_screen_provider.dart';

import '../../common_widgets/category_grid_card_view.dart';

class OnBoardingPreferencesPage extends ConsumerStatefulWidget {
  const OnBoardingPreferencesPage({super.key});

  @override
  ConsumerState<OnBoardingPreferencesPage> createState() =>
      _OnBoardingPreferencesPageState();
}

class _OnBoardingPreferencesPageState extends ConsumerState<OnBoardingPreferencesPage> {
  @override
  Widget build(BuildContext context) {
    String userName  = ref.read(onboardingScreenProvider).userNam;
    String displayMsg =
        "${AppLocalizations.of(context).complete}$userName${AppLocalizations.of(context).what_interest_you}";
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.w, horizontal: 18.h),
        child: Column(
          children: [
            65.verticalSpace,
            textBoldPoppins(
                text: displayMsg,
                fontSize: 18.sp,
                textOverflow: TextOverflow.visible,
                color: Theme.of(context).colorScheme.secondary),
            20.verticalSpace,
            categoryView(context)
          ],
        ),
      ),
    );
  }

  categoryView(BuildContext context) {
    return GridView.builder(
        padding: EdgeInsets.only(top: 0),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisExtent: 135.h),
        itemCount: 20,
        itemBuilder: (BuildContext context, int index) {
          // var exploreCategory = categoryScreenState.exploreCategories[index];
          return GestureDetector(
            onTap: () {
              // if (ref
              //     .read(categoryScreenProvider.notifier)
              //     .isSubCategoryAvailable(exploreCategory)) {
              //   ref.read(navigationProvider).navigateUsingPath(
              //       path: subCategoryScreenPath,
              //       context: context,
              //       params: SubCategoryScreenParameters(
              //           id: exploreCategory.id ?? 0,
              //           categoryHeading: exploreCategory.name ?? ""));
              // } else {
              //   ref.read(navigationProvider).navigateUsingPath(
              //       path: eventListScreenPath,
              //       // Need to be replaced with actual lat-long value
              //       params: EventListScreenParameter(
              //           radius: 1,
              //           centerLatitude: 49.53838,
              //           centerLongitude: 7.40647,
              //           listHeading: exploreCategory.name ?? "" ?? '',
              //           categoryId: exploreCategory.id),
              //       context: context);
              // }
            },
            child: CategoryGridCardView(
              imageUrl:
              "https://fastly.picsum.photos/id/452/200/200.jpg?hmac=f5vORXpRW2GF7jaYrCkzX3EwDowO7OXgUaVYM2NNRXY",
              title: "Digifit Parcours",
            ),
          );
        });
  }

}
