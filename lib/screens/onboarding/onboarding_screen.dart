import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/custom_button_widget.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/images_path.dart';
import 'package:kusel/navigation/navigation.dart';
import 'package:kusel/screens/onboarding/onboarding_name_page.dart';
import 'package:kusel/screens/onboarding/onboarding_preferences_page.dart';
import 'package:kusel/screens/onboarding/onboarding_screen_provider.dart';
import 'package:kusel/screens/onboarding/onboarding_screen_state.dart';
import 'package:kusel/screens/onboarding/onboarding_start_page.dart';
import 'package:kusel/screens/onboarding/onboarding_type_page.dart';
import 'onboarding_option_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  @override
  void initState() {
    ref.read(onboardingScreenProvider.notifier).initializerPageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selectedPageIndex =
        ref.watch(onboardingScreenProvider).selectedPageIndex;
    final pageController =
        ref.watch(onboardingScreenProvider.notifier).pageController;

    final List<Widget> pages = [
      const OnboardingStartPage(),
      const OnBoardingNamePage(),
      const OnboardingTypePage(),
      const OnboardingOptionPage(),
      const OnBoardingPreferencesPage()
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus(); // Dismiss the keyboard

      },child: _buildDashboardUi(pages, selectedPageIndex, pageController)),
    );
  }

  Widget _buildDashboardUi(List<Widget> pages, int selectedPageIndex,
      PageController pageController) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath['onboarding_background'] ?? ''),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          _customPageViewer(pages, pageController),
          selectedPageIndex == 4
              ? Positioned(
                  bottom: 1,
                  left: 16,
                  right: 16,
                  child: Container(
                    color: Colors.white.withAlpha(150),
                    height: 100.h,
                  ))
              : Container(),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: _buildBottomUi(selectedPageIndex, pages, pageController),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomUi(int selectedPageIndex, List<Widget> pages,
      PageController pageController) {
    final state = ref.read(onboardingScreenProvider);
    final stateNotifier = ref.read(onboardingScreenProvider.notifier);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        children: [
          CustomButton(
            onPressed: () {
              switch (selectedPageIndex) {
                case 0:
                  stateNotifier.nextPage();
                  break;
                case 1:
                  if (stateNotifier.onboardingNameFormKey.currentState
                          ?.validate() ??
                      false) {
                    stateNotifier.nextPage();
                  }
                  break;
                case 2:
                  if(!state.isTourist && !state.isResident){
                    stateNotifier.updateErrorMsgStatus(true);
                  } else {
                    stateNotifier.updateErrorMsgStatus(false);
                    stateNotifier.submitUserType();
                    stateNotifier.fetchCities();
                    stateNotifier.nextPage();
                  }
                  break;
                case 3:
                  if (stateNotifier.isAllOptionFieldsCompleted()) {
                    stateNotifier.updateErrorMsgStatus(true);
                  } else {
                    stateNotifier.updateErrorMsgStatus(false);
                    stateNotifier.submitUserDemographics();
                    stateNotifier.nextPage();
                  }
                  break;
                case 4:
                  stateNotifier.submitUserInterests();
                  ref.read(navigationProvider).navigateUsingPath(
                        path: onboardingLoadingPagePath,
                        context: context,
                      );
                  break;
                default:
                  break;
              }
            },
            text: (selectedPageIndex == 0)
                ? AppLocalizations.of(context).lets_get_started
                : selectedPageIndex == 4
                    ? AppLocalizations.of(context).complete
                    : AppLocalizations.of(context).next,
          ),
          18.verticalSpace,
          selectedPageIndex == 0
              ? GestureDetector(
                  onTap: () {
                    ref.read(navigationProvider).removeAllAndNavigate(
                        context: context, path: dashboardScreenPath);
                  },
                  child: textBoldPoppins(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontSize: 11,
                    text: AppLocalizations.of(context).another_time,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: stateNotifier.onBackPress,
                      child: textBoldPoppins(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: 11,
                        text: AppLocalizations.of(context).back,
                      ),
                    ),
                    8.horizontalSpace,
                    GestureDetector(
                      onTap: () {
                        stateNotifier.onSkipPress(() {
                          ref.read(navigationProvider).removeAllAndNavigate(
                              context: context,
                              path: onboardingLoadingPagePath);
                        });
                      },
                      child: textBoldPoppins(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: 11,
                        text: AppLocalizations.of(context).skip,
                      ),
                    )
                  ],
                ),
          18.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              pages.length,
              (index) => InkWell(
                onTap: () {
                  pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                  stateNotifier.updateSelectedPageIndex(index);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Icon(
                    Icons.circle,
                    size: selectedPageIndex == index ? 11 : 8,
                    color: selectedPageIndex == index
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).primaryColor.withAlpha(130),
                  ),
                ),
              ),
            ),
          ),
          12.verticalSpace,
        ],
      ),
    );
  }

  Widget _customPageViewer(List<Widget> pages, PageController pageController) {
    return PageView(
      controller: pageController,
      onPageChanged: (int index) {
        ref
            .read(onboardingScreenProvider.notifier)
            .updateSelectedPageIndex(index);
      },
      physics: const NeverScrollableScrollPhysics(),
      children: pages,
    );
  }
}
