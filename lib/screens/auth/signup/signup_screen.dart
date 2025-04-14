import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/custom_button_widget.dart';
import 'package:kusel/common_widgets/kusel_text_field.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/common_widgets/toast_message.dart';
import 'package:kusel/images_path.dart';
import 'package:kusel/navigator/navigator.dart';
import 'package:kusel/screens/auth/signup/signup_controller.dart';
import 'package:kusel/screens/auth/validator/email_validator.dart';
import 'package:kusel/screens/auth/validator/empty_field_validator.dart';
import 'package:kusel/screens/auth/validator/password_validator.dart';

import '../../dashboard/dashboard_screen_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  final userNameTextEditingController = TextEditingController();
  final firstNameTextEditingController = TextEditingController();
  final lastNameTextEditingController = TextEditingController();

  final scrollController = ScrollController();

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final userNameFocusNode = FocusNode();
  final firstNameFocusNode = FocusNode();
  final lastNameFocusNode = FocusNode();

  final signupFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    passwordFocusNode.addListener(() => _scrollToFocused(passwordFocusNode));

    emailFocusNode.addListener(() => _scrollToFocused(emailFocusNode));

    userNameFocusNode.addListener(() => _scrollToFocused(userNameFocusNode));

    firstNameFocusNode.addListener(() => _scrollToFocused(firstNameFocusNode));

    lastNameFocusNode.addListener(() => _scrollToFocused(lastNameFocusNode));
  }

  @override
  void dispose() {
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
    userNameTextEditingController.dispose();
    firstNameTextEditingController.dispose();
    lastNameTextEditingController.dispose();

    scrollController.dispose();

    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    userNameFocusNode.dispose();
    firstNameFocusNode.dispose();
    lastNameFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: _buildBody(context),
      ).loaderDialog(context, ref.watch(signUpScreenProvider).isLoading),
    );
  }

  Widget _buildBody(BuildContext context) {
    final borderRadius = Radius.circular(30.r);
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0.h,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * .3,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                imagePath['background_image'] ?? "",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 0),
              child: Container(
                color: Theme.of(context).cardColor.withAlpha(150),
              ),
            ),
          ),
          Positioned(
            top: 100.h,
            bottom: 0.h,
            left: 0.w,
            right: 0.w,
            child: Container(
              padding: EdgeInsets.only(top: 20.h),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.only(
                  topRight: borderRadius,
                  topLeft: borderRadius,
                ),
              ),
              child: _buildSignUpCard(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpCard(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Form(
          key: signupFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              15.verticalSpace,
              Align(
                alignment: Alignment.center,
                child: textBoldPoppins(
                  text: AppLocalizations.of(context).signup,
                  fontSize: 20.sp,
                ),
              ),
              32.verticalSpace,
              _buildLabel(context, AppLocalizations.of(context).email),
              KuselTextField(
                textEditingController: emailTextEditingController,
                focusNode: emailFocusNode,
                validator: validateEmail,
              ),
              22.verticalSpace,
              _buildLabel(context, AppLocalizations.of(context).password),
              KuselTextField(
                maxLines: 1,
                textEditingController: passwordTextEditingController,
                focusNode: passwordFocusNode,
                validator: validatePassword,
                obscureText: !ref.watch(signUpScreenProvider).showPassword,
                suffixIcon: ref.read(signUpScreenProvider).showPassword
                    ? GestureDetector(
                        onTap: () {
                          ref
                              .read(signUpScreenProvider.notifier)
                              .updateShowPasswordStatus(false);
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
                              .read(signUpScreenProvider.notifier)
                              .updateShowPasswordStatus(true);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 10.w),
                          child: SvgPicture.asset(imagePath['eye_closed']!),
                        ),
                      ),
                suffixIconConstraints:
                    BoxConstraints(maxWidth: 40.w, maxHeight: 40.h),
              ),
              22.verticalSpace,
              _buildLabel(context, AppLocalizations.of(context).username),
              KuselTextField(
                textEditingController: userNameTextEditingController,
                focusNode: userNameFocusNode,
                validator: (value) =>
                    validateField(value, AppLocalizations.of(context).username),
              ),
              22.verticalSpace,
              _buildLabel(context, AppLocalizations.of(context).firstName),
              KuselTextField(
                textEditingController: firstNameTextEditingController,
                focusNode: firstNameFocusNode,
                validator: (value) => validateField(
                    value, AppLocalizations.of(context).firstName),
              ),
              22.verticalSpace,
              _buildLabel(context, AppLocalizations.of(context).lastName),
              KuselTextField(
                textEditingController: lastNameTextEditingController,
                focusNode: lastNameFocusNode,
                validator: (value) =>
                    validateField(value, AppLocalizations.of(context).lastName),
              ),
              32.verticalSpace,
              CustomButton(
                onPressed: () async {
                  if (signupFormKey.currentState?.validate() ?? false) {
                    await ref.read(signUpScreenProvider.notifier).registerUser(
                        userName: userNameTextEditingController.text,
                        password: passwordTextEditingController.text,
                        firstName: firstNameTextEditingController.text,
                        lastName: lastNameTextEditingController.text,
                        email: emailTextEditingController.text,
                        onError: (value) {
                          showErrorToast(message: value, context: context);
                        },
                        onSuccess: () {
                          showSuccessToast(
                              message:
                                  AppLocalizations.of(context).check_your_email,
                              context: context);
                          ref.read(navigationProvider).removeAllAndNavigate(
                              context: context, path: dashboardScreenPath);
                          ref.read(dashboardScreenProvider.notifier).onIndexChanged(0);
                        });
                  }
                },
                text: AppLocalizations.of(context).signup,
              ),
              12.verticalSpace,
              Align(
                alignment: Alignment.center,
                child: textRegularPoppins(
                  text: AppLocalizations.of(context).or,
                  fontSize: 12.sp,
                ),
              ),
              12.verticalSpace,
              GestureDetector(
                onTap: () {
                  ref.read(navigationProvider).removeCurrentAndNavigate(
                        context: context,
                        path: signInScreenPath,
                      );
                },
                child: Align(
                  alignment: Alignment.center,
                  child: textRegularPoppins(
                    text: AppLocalizations.of(context).login,
                    decoration: TextDecoration.underline,
                    fontSize: 12.sp,
                  ),
                ),
              ),
              22.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w),
      child: textSemiBoldPoppins(
        text: text,
        fontSize: 12.sp,
        color: Theme.of(context).textTheme.displayMedium?.color,
      ),
    );
  }

  void _scrollToFocused(FocusNode focusNode) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final context = focusNode.context;
      if (context != null && context.mounted) {
        Scrollable.ensureVisible(context,
            duration: const Duration(milliseconds: 300));
      }
    });
  }
}
