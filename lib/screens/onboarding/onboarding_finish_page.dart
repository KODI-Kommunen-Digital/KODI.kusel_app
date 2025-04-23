import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/custom_button_widget.dart';
import 'package:kusel/navigation/navigation.dart';

import '../../common_widgets/text_styles.dart';
import '../../images_path.dart';

class OnboardingFinishPage extends ConsumerStatefulWidget {
  const OnboardingFinishPage({super.key});

  @override
  ConsumerState<OnboardingFinishPage> createState() =>
      _OnboardingFinishPageState();
}

class _OnboardingFinishPageState extends ConsumerState<OnboardingFinishPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath['onboarding_background'] ?? ''),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.w, horizontal: 22.h),
            child: Column(
              children: [
                65.verticalSpace,
                Image.asset(
                  imagePath["onboarding_logo"] ?? '',
                  width: 270.w,
                  height: 210.h,
                ),
                textBoldPoppins(
                    text: AppLocalizations.of(context).ready,
                    fontSize: 18.sp,
                    color: Theme.of(context).colorScheme.secondary),
                15.verticalSpace,
                textRegularPoppins(
                    text: AppLocalizations.of(context)
                        .i_have_prepared_everything_text,
                    color: Theme.of(context).colorScheme.secondary,
                    textOverflow: TextOverflow.visible,
                    fontSize: 12.sp),
                25.verticalSpace,
                CustomButton(
                    onPressed: () {
                      ref.read(navigationProvider).removeAllAndNavigate(
                          path: dashboardScreenPath, context: context);
                    },
                    text: AppLocalizations.of(context).continue_to_homepage)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
