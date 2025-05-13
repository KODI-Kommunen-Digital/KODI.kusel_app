import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/arrow_back_widget.dart';
import 'package:kusel/common_widgets/custom_button_widget.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/screens/ort_detail/ort_detail_screen_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common_widgets/downstream_wave_clipper.dart';
import '../../common_widgets/text_styles.dart';
import '../../images_path.dart';
import '../../navigation/navigation.dart';
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
        _buildClipper(context),
        _buildTitle(context),
        _buildDescription(context),
        _buildButton(context)
      ],
    ));
  }

  _buildClipper(context) {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(ortDetailScreenControllerProvider);

        return Column(
          children: [
            SizedBox(
              height: 250.h,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background image at the top
                  Positioned(
                    top: 0.h,
                    child: ClipPath(
                      clipper: DownstreamCurveClipper(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * .3,
                        width: MediaQuery.of(context).size.width,
                        child: Image.asset(
                          imagePath['city_background_image'] ?? "",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 30.h,
                    left: 15.w,
                    child: ArrowBackWidget(
                      onTap: () {
                        ref
                            .read(navigationProvider)
                            .removeTopPage(context: context);
                      },
                    ),
                  ),

                  Positioned(
                    top: 120.h,
                    left: 0.w,
                    right: 0.w,
                    child: Container(
                      height: 120.h,
                      width: 70.w,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: (state.ortDetailDataModel?.image != null)
                          ? FittedBox(
                              fit: BoxFit.contain,
                              child: CachedNetworkImage(
                                height: 70.h,
                                width: 55.w,
                                fit: BoxFit.contain,
                                imageUrl: state.ortDetailDataModel!.image!,
                                errorWidget: (context, val, _) {
                                  return Image.asset(imagePath['crest']!);
                                },
                                progressIndicatorBuilder: (context, val, _) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              ),
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
              ),
            )
          ],
        );
      },
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
                  text: AppLocalizations.of(context).mobility,
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
        child: Row(
          children: [
            textRegularMontserrat(
                text: state.ortDetailDataModel?.description ?? "",
                fontSize: 14),
          ],
        ),
      );
    });
  }

  _buildButton(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final state = ref.watch(ortDetailScreenControllerProvider);
      return Padding(
        padding:  EdgeInsets.symmetric(horizontal: 16.w),
        child: CustomButton(
            onPressed: () async {
              final Uri uri = Uri.parse(state.ortDetailDataModel!.websiteUrl!);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              }
            },
            text: AppLocalizations.of(context).view_ort),
      );
    });
  }
}
