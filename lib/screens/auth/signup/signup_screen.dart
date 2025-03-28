import 'dart:ui';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/custom_button_widget.dart';
import 'package:kusel/common_widgets/kusel_text_field.dart';
import 'package:kusel/common_widgets/text_styles.dart' ;
import 'package:kusel/images_path.dart';
import 'package:kusel/navigator/navigator.dart';
import 'package:kusel/screens/auth/signup/signup_controller.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _buildBody(context),
      ),
    );
  }

  _buildBody(BuildContext context) {
    final borderRadius = Radius.circular(50.r);
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
                top: 0.h,
                child: Container(
                  height: MediaQuery.of(context).size.height * .3,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(),
                  child: Image.asset(
                    imagePath['background_image'] ?? "",
                    fit: BoxFit.cover,
                  ),
                )),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 0),
                child: Container(
                  color: Theme.of(context).cardColor.withValues(alpha: 0.6),
                ),
              ),
            ),
            Positioned(
              bottom: 0.h,
              left: 0.w,
              right: 0.w,
              child: Container(
                  height: MediaQuery.of(context).size.height * .8,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.only(
                          topRight: borderRadius, topLeft: borderRadius)),
                  child: _buildLoginCard(context)),
            ),
          ],
        ),
      ),
    );
  }

  _buildLoginCard(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          15.verticalSpace,
          Align(
              alignment: Alignment.center,
              child: textBoldPoppins(
                  text: AppLocalizations.of(context).signup, fontSize: 20.sp)),
          32.verticalSpace,
          Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: textSemiBoldPoppins(
                text: AppLocalizations.of(context).enter_email_id,
                fontSize: 12.sp,
                color: Theme.of(context).textTheme.displayMedium?.color),
          ),
          5.verticalSpace,
          KuselTextField(
            textEditingController: ref
                .read(signUpScreenProvider.notifier)
                .emailTextEditingController,
          ),
          22.verticalSpace,
          Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: textSemiBoldPoppins(
                text: AppLocalizations.of(context).password,
                fontSize: 12.sp,
                color: Theme.of(context).textTheme.displayMedium?.color),
          ),
          5.verticalSpace,
          KuselTextField(
            textEditingController: ref
                .read(signUpScreenProvider.notifier)
                .passwordTextEditingController,
          ),
          22.verticalSpace,
          Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: textSemiBoldPoppins(
                text: AppLocalizations.of(context).username,
                fontSize: 12.sp,
                color: Theme.of(context).textTheme.displayMedium?.color),
          ),
          5.verticalSpace,
          KuselTextField(
            textEditingController: ref
                .read(signUpScreenProvider.notifier)
                .userNameTextEditingController,
          ),
          32.verticalSpace,
          CustomButton(
              onPressed: () {}, text: AppLocalizations.of(context).signup),
          12.verticalSpace,
          Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  ref.read(navigationProvider).navigateUsingPath(
                      path: dashboardScreenPath, context: context);
                },
                child: textRegularPoppins(
                    text: AppLocalizations.of(context).or, fontSize: 12.sp),
              )),
          12.verticalSpace,
          GestureDetector(
            onTap: () {
              ref.read(navigationProvider).removeCurrentAndNavigate(
                  context: context, path: signInScreenPath);
            },
            child: Align(
              alignment: Alignment.center,
              child: textRegularPoppins(
                  text: AppLocalizations.of(context).login,
                  decoration: TextDecoration.underline,
                  fontSize: 12.sp),
            ),
          )
        ],
      ),
    );
  }
}
