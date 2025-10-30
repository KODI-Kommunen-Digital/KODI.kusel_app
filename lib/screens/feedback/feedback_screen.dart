import 'package:flutter/material.dart';
import 'package:kusel/common_widgets/custom_dropdown.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/custom_button_widget.dart';
import 'package:kusel/common_widgets/kusel_text_field.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/common_widgets/upstream_wave_clipper.dart';
import 'package:kusel/common_widgets/web_view_page.dart';
import 'package:kusel/screens/dashboard/dashboard_screen_provider.dart';
import 'package:kusel/screens/feedback/feedback_screen_provider.dart';
import 'package:kusel/screens/feedback/feedback_screen_state.dart';
import 'package:kusel/utility/url_constants/url_constants.dart';

import '../../common_widgets/arrow_back_widget.dart';
import '../../common_widgets/common_background_clipper_widget.dart';
import '../../common_widgets/text_styles.dart';
import '../../common_widgets/toast_message.dart';
import '../../images_path.dart';
import '../../navigation/navigation.dart';
import '../auth/validator/empty_field_validator.dart';

class FeedbackScreen extends ConsumerStatefulWidget {
  const FeedbackScreen({super.key});

  @override
  ConsumerState<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  GlobalKey<FormState> feedbackFormKey = GlobalKey();
  List<String> titleList = [];

  @override
  void initState() {

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (titleList.isEmpty) { // prevent multiple rebuilds
      titleList = [
        AppLocalizations.of(context).infrastructure_and_public_space,
        AppLocalizations.of(context).transportation_and_mobility,
        AppLocalizations.of(context).cleanliness_and_environment,
        AppLocalizations.of(context).digital_services_and_app_functionality,
        AppLocalizations.of(context).disruptions_and_damage,
        AppLocalizations.of(context).citizen_services_and_administration,
        AppLocalizations.of(context).general_feedback,
      ];

      Future.microtask((){
        ref.read(feedbackScreenProvider.notifier).updateTitle(titleList[0]);

      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final stateRead = ref.read(feedbackScreenProvider);
    final stateWatch = ref.watch(feedbackScreenProvider);
    final stateNotifier = ref.read(feedbackScreenProvider.notifier);
    final titleEditingController = stateNotifier.titleEditingController;
    final descriptionEditingController =
        stateNotifier.descriptionEditingController;
    final emailEditingController = stateNotifier.emailEditingController;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: _buildFeedbackUi(
                  titleEditingController,
                  descriptionEditingController,
                  emailEditingController,
                  stateWatch,
                  stateNotifier),
            ),
            Positioned(
              top: 30.h,
              left: 16.w,
              child: ArrowBackWidget(
                onTap: () {
                  ref.read(dashboardScreenProvider).selectedIndex = 0;
                  ref.read(navigationProvider).removeAllAndNavigate(
                      path: homeScreenPath, context: context);
                },
              ),
            ),
          ],
        ),
      ),
    ).loaderDialog(context, stateWatch.loading);
  }

  Widget _buildFeedbackUi(
      TextEditingController titleEditingController,
      TextEditingController descriptionEditingController,
      TextEditingController emailEditingController,
      FeedbackScreenState stateWatch,
      FeedbackScreenProvider stateNotifier) {
    return Column(
      children: [
        CommonBackgroundClipperWidget(
            clipperType: UpstreamWaveClipper(),
            imageUrl: imagePath['background_image'] ?? "",
            headingText: AppLocalizations.of(context).feedback,
            height: 130.h,
            blurredBackground: true,
            isBackArrowEnabled: false,
            isStaticImage: true),
        _buildForm(titleEditingController, descriptionEditingController,
            emailEditingController, stateWatch, stateNotifier)
      ],
    );
  }

  Widget _buildForm(
      TextEditingController titleEditingController,
      TextEditingController descriptionEditingController,
      TextEditingController emailEditingController,
      FeedbackScreenState stateWatch,
      FeedbackScreenProvider stateNotifier) {
    return Form(
      key: feedbackFormKey,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: textRegularMontserrat(
                      text: AppLocalizations.of(context).regarding,
                      fontSize: 14)),
            ),
            6.verticalSpace,
            CustomDropdown(
                hintText: AppLocalizations.of(context).feedback_about_app,
                items: titleList,
                selectedItem: ref.watch(feedbackScreenProvider).title.isEmpty
                    ? ''
                    : ref.read(feedbackScreenProvider).title,
                onSelected: (value) {
                  ref
                      .read(feedbackScreenProvider.notifier)
                      .updateTitle(value ?? "");
                }),
            6.verticalSpace,
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: textRegularMontserrat(
                      text: AppLocalizations.of(context).email, fontSize: 14)),
            ),
            6.verticalSpace,
            KuselTextField(
              textEditingController: emailEditingController,
              hintText: AppLocalizations.of(context).enter_email,
              validator: (value) {
                return validateField(value,
                    "${AppLocalizations.of(context).email} ${AppLocalizations.of(context).is_required}");
              },
            ),
            15.verticalSpace,
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: textRegularMontserrat(
                      text: AppLocalizations.of(context).news, fontSize: 14)),
            ),
            6.verticalSpace,
            KuselTextField(
              textEditingController: descriptionEditingController,
              maxLength: 300,
              maxLines: 6,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15.h, horizontal: 12.w),
              hintText: AppLocalizations.of(context).enter_description,
              validator: (value) {
                return validateField(value,
                    "${AppLocalizations.of(context).description} ${AppLocalizations.of(context).is_required}");
              },
            ),
            8.verticalSpace,
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: textRegularMontserrat(
                      text: AppLocalizations.of(context).maximum_characters,
                      fontSize: 12)),
            ),
            16.verticalSpace,
            Row(
              children: [
                Checkbox(
                    value: stateWatch.isChecked,
                    activeColor: Theme.of(context).indicatorColor,
                    onChanged: (value) {
                      stateNotifier.updateCheckBox(value ?? false);
                    }),
                Expanded(
                  child: GestureDetector(
                    onTap: () => ref.read(navigationProvider).navigateUsingPath(
                        path: webViewPagePath,
                        params: WebViewParams(url: privacyPolicyUrl),
                        context: context),
                    child: textBoldMontserrat(
                        text: AppLocalizations.of(context).feedback_text,
                        textOverflow: TextOverflow.visible,
                        textAlign: TextAlign.start,
                        fontSize: 12),
                  ),
                ),
              ],
            ),
            Visibility(
                visible: stateWatch.onError,
                child: textSemiBoldMontserrat(
                    fontSize: 12,
                    textOverflow: TextOverflow.visible,
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    color: Theme.of(context).colorScheme.error,
                    text:
                        AppLocalizations.of(context).privacy_policy_error_msg)),
            10.verticalSpace,
            CustomButton(
                onPressed: () {
                  if (feedbackFormKey.currentState!.validate() &&
                      stateWatch.isChecked) {
                    ref.read(feedbackScreenProvider.notifier).sendFeedback(
                        success: () {
                          showSuccessToast(
                              message: AppLocalizations.of(context)
                                  .feedback_sent_successfully,
                              context: context);
                          titleEditingController.clear();
                          descriptionEditingController.clear();
                          ref
                              .read(navigationProvider)
                              .removeTopPage(context: context);
                        },
                        onError: (String msg) {
                          showErrorToast(message: msg, context: context);
                        },
                        title: ref.read(feedbackScreenProvider).title,
                        description: descriptionEditingController.text,
                        email: emailEditingController.text);
                  }
                },
                text: AppLocalizations.of(context).submit),
            25.verticalSpace,
          ],
        ),
      ),
    );
  }
}
