import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/custom_button_widget.dart';
import 'package:kusel/common_widgets/kusel_text_field.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/common_widgets/toast_message.dart';
import 'package:kusel/images_path.dart';
import 'package:kusel/navigator/navigator.dart';
import 'package:kusel/screens/auth/signin/signin_controller.dart';

import '../validator/empty_field_validator.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  GlobalKey<FormState> signInFormKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _buildBody(context),
      ).loaderDialog(context, ref.watch(signInScreenProvider).showLoading),
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
    return Form(
      key: signInFormKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            15.verticalSpace,
            Align(
                alignment: Alignment.center,
                child: textBoldPoppins(
                    text: AppLocalizations.of(context).login, fontSize: 20.sp)),
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
              textEditingController: emailTextEditingController,
              validator: (value) {
                return validateField(value, "Email or Username");
              },
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
              maxLines: 1,
              textEditingController: passwordTextEditingController,
              obscureText: !ref.watch(signInScreenProvider).showPassword,
              suffixIcon: ref.read(signInScreenProvider).showPassword
                  ? GestureDetector(
                      onTap: () {
                        ref
                            .read(signInScreenProvider.notifier)
                            .updateShowPassword(false);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 10.w),
                        child: SvgPicture.asset(
                          imagePath['eye_open']!,
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        ref
                            .read(signInScreenProvider.notifier)
                            .updateShowPassword(true);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 10.w),
                        child: SvgPicture.asset(imagePath['eye_closed']!),
                      ),
                    ),
              validator: (value) {
                return validateField(
                    value, AppLocalizations.of(context).password);
              },
              suffixIconConstraints:
                  BoxConstraints(maxWidth: 40.w, maxHeight: 40.h),
            ),
            22.verticalSpace,
            GestureDetector(
              onTap: () {
                ref.read(navigationProvider).navigateUsingPath(
                    context: context, path: forgotPasswordPath);
              },
              child: Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: textRegularPoppins(
                    text: AppLocalizations.of(context).forgot_password,
                    fontSize: 12.sp,
                    decoration: TextDecoration.underline),
              ),
            ),
            32.verticalSpace,
            CustomButton(
                onPressed: () async {
                  if (signInFormKey.currentState!.validate()) {
                    await ref.read(signInScreenProvider.notifier).sigInUser(
                        userName: emailTextEditingController.text,
                        password: passwordTextEditingController.text,
                        success: () {
                          ref.read(navigationProvider).removeAllAndNavigate(
                              context: context, path: dashboardScreenPath);
                        },
                        error: (message) {
                          showErrorToast(message: message, context: context);
                        });
                  }
                },
                text: AppLocalizations.of(context).login),
            12.verticalSpace,
            Align(
                alignment: Alignment.center,
                child: textRegularPoppins(
                    text: AppLocalizations.of(context).or, fontSize: 12.sp)),
            12.verticalSpace,
            GestureDetector(
              onTap: () {
                ref.read(navigationProvider).navigateUsingPath(
                    context: context, path: signUpScreenPath);
              },
              child: Align(
                alignment: Alignment.center,
                child: textRegularPoppins(
                    text: AppLocalizations.of(context).signup,
                    decoration: TextDecoration.underline,
                    fontSize: 12.sp),
              ),
            )
          ],
        ),
      ),
    );
  }
}
