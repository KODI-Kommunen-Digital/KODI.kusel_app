import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/custom_button_widget.dart';
import 'package:kusel/common_widgets/feedback_card_widget.dart';
import 'package:kusel/common_widgets/image_utility.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/screens/ort_detail/ort_detail_screen_controller.dart';
import 'package:kusel/screens/virtual_town_hall/virtual_town_hall_provider.dart';

import '../../app_router.dart';
import '../../common_widgets/common_background_clipper_widget.dart';
import '../../common_widgets/common_bottom_nav_card_.dart';
import '../../common_widgets/downstream_wave_clipper.dart';
import '../../common_widgets/text_styles.dart';
import '../../common_widgets/toast_message.dart';
import '../../images_path.dart';
import '../../navigation/navigation.dart';
import '../../providers/favourite_cities_notifier.dart';
import '../../utility/url_launcher_utility.dart';
import '../mein_ort/mein_ort_provider.dart';
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

      ref.read(ortDetailScreenControllerProvider.notifier).isUserLoggedIn();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    ).loaderDialog(
        context, ref.watch(ortDetailScreenControllerProvider).isLoading);
  }

  _buildBody(BuildContext context) {
    final state = ref
        .watch(ortDetailScreenControllerProvider);
    final ortDetailDataModel = state.ortDetailDataModel;
    return SafeArea(
      child: Stack(
        children: [
          Positioned.fill(
            child: _buildScreen(context),
          ),
          Positioned(
              bottom: 16.h,
              left: 16.w,
              right: 16.w,
              child: CommonBottomNavCard(
                onBackPress: () {
                  ref.read(navigationProvider).removeTopPage(context: context);
                },
                isFavVisible:
                state.isUserLoggedIn,
                isFav: ortDetailDataModel?.isFavorite ??
                    false,
                onFavChange: () {
                  ref
                      .watch(favouriteCitiesNotifier.notifier)
                      .toggleFavorite(
                    isFavourite : ortDetailDataModel?.isFavorite,
                    id : ortDetailDataModel?.id,
                    success: ({required bool isFavorite}) {
                      _updateCityFavStatus(
                          isFavorite, ortDetailDataModel?.id ?? 0);
                          widget.ortDetailScreenParams.onFavSuccess(
                              isFavorite, ortDetailDataModel?.id ?? 0);
                        },
                    error: ({required String message}) {
                      showErrorToast(message: message, context: context);
                    },
                  );                },
              ))
        ],
      ),
    );
  }

  _buildScreen(BuildContext context) {
    return SingleChildScrollView(
        physics: ClampingScrollPhysics(),
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
            FeedbackCardWidget(
              onTap: () {
                ref.read(navigationProvider).navigateUsingPath(
                    path: feedbackScreenPath, context: context);
              },
              height: 270.h,
            ),
            50.verticalSpace
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

  _updateCityFavStatus(bool isFav, int id) {
    ref
        .read(ortDetailScreenControllerProvider.notifier)
        .setIsFavoriteCity(isFav);
    // ref.read(meinOrtProvider.notifier).setIsFavoriteCity(isFav, id);
    // ref.read(virtualTownHallProvider.notifier).setIsFavoriteMunicipality(isFav, id);
  }
}
