import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/arrow_back_widget.dart';
import 'package:kusel/common_widgets/custom_button_widget.dart';
import 'package:kusel/common_widgets/feedback_card_widget.dart';
import 'package:kusel/common_widgets/image_utility.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/screens/ort_detail/ort_detail_screen_controller.dart';
import 'package:kusel/screens/utility/image_loader_utility.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_router.dart';
import '../../common_widgets/common_background_clipper_widget.dart';
import '../../common_widgets/downstream_wave_clipper.dart';
import '../../common_widgets/text_styles.dart';
import '../../images_path.dart';
import '../../navigation/navigation.dart';
import '../../utility/url_launcher_utility.dart';
import 'ort_detail_screen_params.dart';

class OrtDetailScreen extends ConsumerStatefulWidget {
  OrtDetailScreenParams ortDetailScreenParams;

  OrtDetailScreen({super.key, required this.ortDetailScreenParams});

  @override
  ConsumerState<OrtDetailScreen> createState() => _OrtDetailScreenState();
}

class _OrtDetailScreenState extends ConsumerState<OrtDetailScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref
          .read(ortDetailScreenControllerProvider.notifier)
          .getOrtDetail(ortId: widget.ortDetailScreenParams.ortId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _buildBody(context),
      ).loaderDialog(
          context, ref.watch(ortDetailScreenControllerProvider).isLoading),
    );
  }

  _buildBody(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildClipper(),
        _buildTitle(context),
        _buildDescription(context),
        32.verticalSpace,
        _buildButton(context),
        32.verticalSpace,
        FeedbackCardWidget(onTap: () {
          ref.read(navigationProvider).navigateUsingPath(
              path: feedbackScreenPath, context: context);
        })
      ],
    ));
  }

  _buildClipper() {
    final state = ref.watch(ortDetailScreenControllerProvider);
    return Stack(
      children: [
        SizedBox(
          height: 250.h,
          child: CommonBackgroundClipperWidget(
            clipperType: DownstreamCurveClipper(),
            imageUrl: imagePath['city_background_image'] ?? "",
            height: 210.h,
            isBackArrowEnabled: true,
            isStaticImage: true,
          ),
        ),
        Positioned(
          top: 120.h,
          left: 0.w,
          right: 0.w,
          child: Container(
            height: 120.h,
            width: 70.w,
            padding: EdgeInsets.all(25.w),
            decoration:
            BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            child: (state.ortDetailDataModel?.image != null)
                ? ImageUtil.loadNetworkImage(
              imageUrl: state.ortDetailDataModel!.image!,
              sourceId: 1,
              fit: BoxFit.contain,
              svgErrorImagePath: imagePath['crest']!,
              context: context,
            )
                : Center(
              child: Image.asset(
                imagePath['crest']!,
                height: 120.h,
                width: 100.w,
              ),
            ),
          ),
        )
      ],
    );
  }

  _buildTitle(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(ortDetailScreenControllerProvider);

        return Padding(
          padding: EdgeInsets.all(12.h.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textBoldPoppins(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  text: state.ortDetailDataModel?.name ?? "",
                  fontSize: 18),
              10.verticalSpace,
              textSemiBoldMontserrat(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  textAlign: TextAlign.start,
                  fontSize: 14,
                  text: state.ortDetailDataModel?.subtitle ?? "",
                  textOverflow: TextOverflow.visible)
            ],
          ),
        );
      },
    );
  }

  _buildDescription(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final state = ref.watch(ortDetailScreenControllerProvider);

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.h),
        child: textRegularMontserrat(
            text: state.ortDetailDataModel?.description ?? "",
            fontSize: 12,
            textAlign: TextAlign.start,
            maxLines: 50),
      );
    });
  }

  _buildButton(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final state = ref.watch(ortDetailScreenControllerProvider);
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: CustomButton(
            onPressed: () => UrlLauncherUtil.launchWebUrl(
                url: state.ortDetailDataModel!.websiteUrl!),
            text: AppLocalizations.of(context).view_ort),
      );
    });
  }
}
