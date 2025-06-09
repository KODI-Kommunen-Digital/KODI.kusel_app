import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/custom_button_widget.dart';
import 'package:kusel/common_widgets/image_utility.dart';
import 'package:kusel/common_widgets/kusel_text_field.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/common_widgets/toast_message.dart';
import 'package:kusel/images_path.dart';
import 'package:kusel/navigator/navigator.dart';
import 'package:kusel/screens/auth/signin/signin_controller.dart';

import '../../../common_widgets/arrow_back_widget.dart';
import '../../environment/environment_dialog.dart';
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, dynamicType) {
        if (!didPop) {
          //TODO: need to check this as for now we are using shell route
          ref
              .read(navigationProvider)
              .removeAllAndNavigate(path: homeScreenPath, context: context);
        }
      },
      child: Scaffold(
        body: _buildBody(context),
      ).loaderDialog(context, ref.watch(signInScreenProvider).showLoading),
    );
  }

  _buildBody(BuildContext context) {
    final borderRadius = Radius.circular(50.r);
    return SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: ClampingScrollPhysics(),
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
                        color: Theme.of(context)
                            .colorScheme
                            .onSecondary
                            .withValues(alpha: 0.6),
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
                            color: Theme.of(context).colorScheme.onSecondary,
                            borderRadius: BorderRadius.only(
                                topRight: borderRadius, topLeft: borderRadius)),
                        child: _buildLoginCard(context)),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 10.h,
            left: 16.w,
            child: ArrowBackWidget(
              onTap: () {
                ref
                    .read(navigationProvider)
                    .removeAllAndNavigate(path: homeScreenPath, context: context);
              },
            ),
          ),
        ],
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
            GestureDetector(
              onLongPress: () async {
                if (kDebugMode) {
                  await showEnvironmentDialog(context: context, ref: ref);
                }
              },
              child: Align(
                  alignment: Alignment.center,
                  child: textBoldPoppins(
                      text: AppLocalizations.of(context).login, fontSize: 20)),
            ),
            32.verticalSpace,
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: textSemiBoldPoppins(
                  text: AppLocalizations.of(context).enter_email_id,
                  fontSize: 12,
                  color: Theme.of(context).textTheme.displayMedium?.color),
            ),
            5.verticalSpace,
            KuselTextField(
              textEditingController: emailTextEditingController,
              validator: (value) {
                return validateField(value,
                    "${AppLocalizations.of(context).name_or_email} ${AppLocalizations.of(context).is_required}");
              },
            ),
            22.verticalSpace,
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: textSemiBoldPoppins(
                  text: AppLocalizations.of(context).password,
                  fontSize: 12,
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
                        child: ImageUtil.loadSvgImage(
                            imageUrl: imagePath['eye_open']!, context: context),
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
                        child: ImageUtil.loadSvgImage(
                            imageUrl: imagePath['eye_closed']!,
                            context: context),
                      ),
                    ),
              validator: (value) {
                return validateField(
                    value, "${AppLocalizations
                    .of(context)
                    .password} ${AppLocalizations
                    .of(context)
                    .is_required}");
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
                    fontSize: 12,
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
                        success: () async {
                          bool isOnboarded = await ref
                              .read(signInScreenProvider.notifier)
                              .isOnboardingDone();
                          if (isOnboarded) {
                            ref.read(navigationProvider).removeAllAndNavigate(
                                context: context, path: homeScreenPath);
                          } else {
                            ref.read(navigationProvider).removeAllAndNavigate(
                                context: context, path: onboardingScreenPath);
                          }
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
                    text: AppLocalizations.of(context).or, fontSize: 12)),
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
                    fontSize: 12),
              ),
            )
          ],
        ),
      ),
    );
  }
}
