import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/images_path.dart';

class OnboardingStartPage extends ConsumerStatefulWidget {
  const OnboardingStartPage({super.key});

  @override
  ConsumerState<OnboardingStartPage> createState() =>
      _OnboardingStartPageState();
}

class _OnboardingStartPageState extends ConsumerState<OnboardingStartPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical :15.w, horizontal: 18.h),
      child: Column(
        children: [
          50.verticalSpace,
          Image.asset(imagePath["onboarding_logo"] ?? '', width: 270.w, height: 210.h,),
          textBoldPoppins(text: AppLocalizations.of(context).welcome_text, fontSize: 16.sp),
          20.verticalSpace,
          textRegularPoppins(
              text: AppLocalizations.of(context).welcome_para_first ,textOverflow: TextOverflow.visible,
            fontSize: 12.sp
          ),
          16.verticalSpace,
          textRegularPoppins(
              text: AppLocalizations.of(context).welcome_para_second ,textOverflow: TextOverflow.visible,
              fontSize: 12.sp
          )
        ],
      ),
    );
  }
}
