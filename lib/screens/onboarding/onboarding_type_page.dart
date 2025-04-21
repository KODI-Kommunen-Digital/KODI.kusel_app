import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/kusel_text_field.dart';

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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.w, horizontal: 18.h),
      child: Column(
        children: [
          65.verticalSpace,
          textBoldPoppins(
              text: AppLocalizations.of(context).ich_text,
              fontSize: 18.sp,
              color: Theme.of(context).colorScheme.secondary),
          20.verticalSpace,
          KuselTextField(
            textEditingController: TextEditingController(),
            hintText: "lebe hier",
            textAlign: TextAlign.center,
          ),
          15.verticalSpace,
          KuselTextField(
            textEditingController: TextEditingController(),
            hintText: "verbringe meine Freizeit hier",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
