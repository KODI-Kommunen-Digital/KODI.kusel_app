import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/custom_button_widget.dart';
import 'package:kusel/common_widgets/kusel_text_field.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/common_widgets/upstream_wave_clipper.dart';
import 'package:kusel/screens/feedback/feedback_screen_provider.dart';
import 'package:kusel/screens/feedback/feedback_screen_state.dart';
import 'package:url_launcher/url_launcher.dart';

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

  @override
  Widget build(BuildContext context) {
    final stateRead = ref.read(feedbackScreenProvider);
    final stateWatch = ref.watch(feedbackScreenProvider);
    final stateNotifier = ref.read(feedbackScreenProvider.notifier);
    final titleEditingController = stateNotifier.titleEditingController;
    final descriptionEditingController =
        stateNotifier.descriptionEditingController;
    final emailEditingController = stateNotifier.emailEditingController;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SingleChildScrollView(
          child: _buildFeedbackUi(
              titleEditingController,
              descriptionEditingController,
              emailEditingController,
              stateWatch,
              stateNotifier),
        ),
      ).loaderDialog(context, stateWatch.loading),
    );
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
            isBackArrowEnabled: true,
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
            Align(
                alignment: Alignment.centerLeft,
                child: textRegularPoppins(
                    text: AppLocalizations.of(context).email,
                    color: Theme.of(context).textTheme.labelMedium?.color,
                    fontWeight: FontWeight.w600)),
            6.verticalSpace,
            KuselTextField(
              textEditingController: emailEditingController,
              hintText: AppLocalizations.of(context).enter_email,
              validator: (value) {
                return validateField(
                    value, AppLocalizations.of(context).enter_email);
              },
            ),
            15.verticalSpace,
            Align(
                alignment: Alignment.centerLeft,
                child: textRegularPoppins(
                    text: AppLocalizations.of(context).title,
                    color: Theme.of(context).textTheme.labelMedium?.color,
                    fontWeight: FontWeight.w600)),
            6.verticalSpace,
            KuselTextField(
              textEditingController: titleEditingController,
              hintText: AppLocalizations.of(context).enter_title,
              validator: (value) {
                return validateField(
                    value, AppLocalizations.of(context).enter_title);
              },
            ),
            15.verticalSpace,
            Align(
                alignment: Alignment.centerLeft,
                child: textRegularPoppins(
                    text: AppLocalizations.of(context).description,
                    color: Theme.of(context).textTheme.labelMedium?.color,
                    fontWeight: FontWeight.w600)),
            6.verticalSpace,
            KuselTextField(
              textEditingController: descriptionEditingController,
              maxLines: 10,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15.h, horizontal: 12.w),
              hintText: AppLocalizations.of(context).enter_description,
              validator: (value) {
                return validateField(
                    value, AppLocalizations.of(context).description);
              },
            ),
            5.verticalSpace,
            Row(
              children: [
                Checkbox(
                    value: stateWatch.isChecked,
                    onChanged: (value) {
                      stateNotifier.updateCheckBox(value ?? false);
                    }),
                Expanded(
                  child: textRegularPoppins(
                      text: AppLocalizations.of(context).feedback_text,
                      textOverflow: TextOverflow.visible,
                      textAlign: TextAlign.start,
                      fontSize: 11),
                )
              ],
            ),
            10.verticalSpace,
            CustomButton(
                onPressed: () {
                  if (feedbackFormKey.currentState!.validate()) {
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
                        title: titleEditingController.text,
                        description: descriptionEditingController.text,
                        email: emailEditingController.text);
                  }
                },
                text: AppLocalizations.of(context).submit),
            25.verticalSpace,
            GestureDetector(
              onTap: () async {
                final Uri uri = Uri.parse(
                    "https://heidi.troisdorf.dksr.city/PrivacyPolicy");
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                }
              },
              child: textRegularMontserrat(
                  text: AppLocalizations.of(context).privacy_policy,
                  decoration: TextDecoration.underline),
            ),
            10.verticalSpace,
          ],
        ),
      ),
    );
  }

}
