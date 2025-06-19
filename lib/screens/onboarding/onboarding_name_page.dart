import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/kusel_text_field.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kusel/screens/onboarding/onboarding_screen_provider.dart';

import '../auth/validator/empty_field_validator.dart';

class OnBoardingNamePage extends ConsumerStatefulWidget {
  const OnBoardingNamePage({super.key});

  @override
  ConsumerState<OnBoardingNamePage> createState() =>
      _OnboardingStartPageState();
}

class _OnboardingStartPageState extends ConsumerState<OnBoardingNamePage> {
  TextEditingController nameEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final savedName = ref.read(onboardingScreenProvider).userFirstName;
    if (savedName != null) {
      nameEditingController.text = savedName;
    }
    nameEditingController.addListener(() {
      ref
          .read(onboardingScreenProvider.notifier)
          .updateFirstName(nameEditingController.text);
    });
  }
  @override
  Widget build(BuildContext context) {
    final onboardingNameFormKey =
        ref.read(onboardingScreenProvider.notifier).onboardingNameFormKey;

    return Form(
      key: onboardingNameFormKey,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.w, horizontal: 18.h),
        child: Column(
          children: [
            65.verticalSpace,
            textBoldPoppins(
                text: AppLocalizations.of(context).what_may_i_call_you,
                fontSize: 18,
                color: Theme.of(context).textTheme.bodyLarge?.color),
            20.verticalSpace,
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Align(
                alignment: Alignment.centerLeft,
                child: textRegularPoppins(
                    fontStyle: FontStyle.italic,
                    text: AppLocalizations.of(context).your_name,
                    fontSize: 12,
                    textAlign: TextAlign.left,
                    color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
            ),
            5.verticalSpace,
            KuselTextField(
              textEditingController: nameEditingController,
              validator: (value) {
                return validateField(
                  value,
                  "${AppLocalizations.of(context).name} ${AppLocalizations.of(context).is_required}",
                );
              },
              maxLines: 1,
            )
          ],
        ),
      ),
    );
  }
}
