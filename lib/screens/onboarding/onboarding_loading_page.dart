import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/navigation/navigation.dart';
import 'package:kusel/screens/onboarding/onboarding_screen_provider.dart';

import '../../common_widgets/text_styles.dart';
import '../../images_path.dart';

class OnboardingLoadingPage extends ConsumerStatefulWidget {
  const OnboardingLoadingPage({super.key});

  @override
  ConsumerState<OnboardingLoadingPage> createState() =>
      _OnboardingLoadingPageState();
}

class _OnboardingLoadingPageState extends ConsumerState<OnboardingLoadingPage> {

  @override
  void initState() {
    super.initState(); // super.initState FIRST is better practice

    Future.delayed(Duration.zero, () {
      ref.read(onboardingScreenProvider.notifier).startLoadingTimer(() {
        ref.read(navigationProvider).removeAllAndNavigate(
          context: context,
          path: onboardingFinishPagePath,
        );
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    String userName = ref.read(onboardingScreenProvider).userNam;
    String textMsg = "${AppLocalizations.of(context).thanks} $userName!";
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath['onboarding_background'] ?? ''),
              // your image path
              fit: BoxFit.cover, // cover the entire screen
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.w, horizontal: 18.h),
            child: Column(
              children: [
                150.verticalSpace,
                Center(child: SizedBox(
                  height: 120.h,
                  width: 140.w,
                  child:
                    CircularProgressIndicator(
                      color: Color(0xFF6972A8),
                    )
                )),
                30.verticalSpace,
                textBoldPoppins(
                    text: textMsg,
                    fontSize: 18.sp,
                    color: Theme.of(context).colorScheme.secondary),
                10.verticalSpace,
                textRegularPoppins(
                    text: AppLocalizations.of(context).preparing_the_app_text,
                    textOverflow: TextOverflow.visible,
                    fontSize: 12.sp)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
