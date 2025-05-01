import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/custom_button_widget.dart';
import 'package:kusel/common_widgets/kusel_text_field.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/common_widgets/upstream_wave_clipper.dart';
import 'package:kusel/screens/feedback/feedback_screen_provider.dart';

import '../../common_widgets/arrow_back_widget.dart';
import '../../common_widgets/text_styles.dart';
import '../../common_widgets/toast_message.dart';
import '../../images_path.dart';
import '../../navigation/navigation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        body: SingleChildScrollView(
          child: _buildFeedbackUi(titleEditingController,
              descriptionEditingController),
        ),
      ).loaderDialog(context, stateWatch.loading),
    );
  }

  Widget _buildFeedbackUi(
      TextEditingController titleEditingController,
      TextEditingController descriptionEditingController) {
    return Column(
      children: [
        _buildClipperBackground(),
        _buildForm(titleEditingController,
            descriptionEditingController)
      ],
    );
  }

  Widget _buildForm(TextEditingController titleEditingController,
      TextEditingController descriptionEditingController) {
    return Form(
      key: feedbackFormKey,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
        child: Column(
          children: [
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
            _buildDescriptionTextField(
                validator: (value) {
                  return validateField(
                      value, AppLocalizations.of(context).description);
                },
                descriptionEditingController: descriptionEditingController),
            25.verticalSpace,
            CustomButton(
                onPressed: () {
                  if (feedbackFormKey.currentState!.validate()) {
                    ref.read(feedbackScreenProvider.notifier).sendFeedback(
                        success: () {
                          showSuccessToast(
                              message: AppLocalizations.of(context).feedback_sent_successfully,
                              context: context);
                        },
                        onError: (String msg) {
                      showErrorToast(message: msg, context: context);
                    },
                      title: titleEditingController.text,
                      description: descriptionEditingController.text
                    );
                  }
                  descriptionEditingController.text = '';
                },
                text: AppLocalizations.of(context).submit),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionTextField(
      {String? Function(String?)? validator,
      required TextEditingController descriptionEditingController}) {
    return TextFormField(
      controller: descriptionEditingController,
      keyboardType: TextInputType.multiline,
      validator: validator,
      maxLines: 10,
      minLines: 8,
      decoration: InputDecoration(
        fillColor: Theme.of(context).canvasColor,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: BorderSide.none
          // borderSide: BorderSide(
          //     color: Color.fromRGBO(255, 255, 255, 0.8), width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        hintText: AppLocalizations.of(context).enter_description,
        hintStyle: TextStyle(
          color: Theme.of(context).hintColor,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildClipperBackground() {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: ClipPath(
            clipper: UpstreamWaveClipper(),
            child: Container(
              height: 130.h,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imagePath['home_screen_background'] ?? ''),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 30.h,
          left: 15.w,
          right: 15.w,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                ArrowBackWidget(
                  onTap: () {
                    ref
                        .read(navigationProvider)
                        .removeTopPage(context: context);
                  },
                ),
                70.horizontalSpace,
                textBoldPoppins(
                    text: AppLocalizations.of(context).feedback,
                    fontSize: 20.sp,
                    color: Theme.of(context).textTheme.labelLarge?.color),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
