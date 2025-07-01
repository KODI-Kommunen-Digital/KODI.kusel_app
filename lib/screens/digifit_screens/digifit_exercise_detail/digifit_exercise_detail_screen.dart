import 'package:domain/model/response_model/digifit/digifit_exercise_details_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/common_background_clipper_widget.dart';
import 'package:kusel/common_widgets/feedback_card_widget.dart';
import 'package:kusel/common_widgets/upstream_wave_clipper.dart';
import 'package:kusel/images_path.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:kusel/screens/digifit_screens/digifit_exercise_detail/params/digifit_exercise_details_params.dart';
import 'package:kusel/screens/home/home_screen_provider.dart';

import '../../../app_router.dart';
import '../../../common_widgets/arrow_back_widget.dart';
import '../../../common_widgets/custom_button_widget.dart';
import '../../../common_widgets/digifit/digifit_text_image_card.dart';
import '../../../common_widgets/image_utility.dart';
import '../../../common_widgets/text_styles.dart';
import '../../../navigation/navigation.dart';
import 'digifit_exercise_details_controller.dart';

class DigifitExerciseDetailScreen extends ConsumerStatefulWidget {
  final DigifitExerciseDetailsParams digifitExerciseDetailsParams;

  const DigifitExerciseDetailScreen(
      {super.key, required this.digifitExerciseDetailsParams});

  @override
  ConsumerState<DigifitExerciseDetailScreen> createState() =>
      _DigifitExerciseDetailScreenState();
}

class _DigifitExerciseDetailScreenState
    extends ConsumerState<DigifitExerciseDetailScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(digifitExerciseDetailsControllerProvider.notifier)
          .fetchDigifitExerciseDetails(
              widget.digifitExerciseDetailsParams.equipmentId,
              widget.digifitExerciseDetailsParams.location);
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
          child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Stack(
          children: [
            Positioned(
                child: CommonBackgroundClipperWidget(
              clipperType: UpstreamWaveClipper(),
              height: 130.h,
              imageUrl: imagePath['exercise_background'] ?? '',
              isStaticImage: true,
              imageFit: BoxFit.values.first,
            )),
            Positioned(
              top: 25.h,
              left: 15.w,
              right: 15.w,
              child: _buildHeadingArrowSection(),
            ),
            Padding(
                padding: EdgeInsets.only(top: 80.h),
                child: Column(
                  children: [
                    _buildBody(),
                    20.verticalSpace,
                    FeedbackCardWidget(
                        height: 270.h,
                        onTap: () {
                          ref.read(navigationProvider).navigateUsingPath(
                              path: feedbackScreenPath, context: context);
                        })
                  ],
                ))
          ],
        ),
      )),
    );
  }

  _buildHeadingArrowSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ArrowBackWidget(
          onTap: () {
            ref.read(navigationProvider).removeTopPage(context: context);
          },
        ),
        16.horizontalSpace,
        Visibility(visible: true, child: _videoStatusCard())
      ],
    );
  }

  _videoStatusCard() {
    return Card(
      color: Theme.of(context).canvasColor,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
        child: Row(
          children: [
            Icon(
              Icons.verified,
              color: Theme.of(context).primaryColor,
              size: 18.h.w,
            ),
            8.horizontalSpace,
            textBoldMontserrat(
                text: AppLocalizations.of(context).complete,
                color: Theme.of(context).primaryColor,
                fontSize: 13)
          ],
        ),
      ),
    );
  }

  _buildBody() {
    final digifitExerciseDetailsState =
        ref.watch(digifitExerciseDetailsControllerProvider);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 13.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // DigifitVideoPlayerWidget(
          //   videoUrl: 'assets/video/test_video_2.mp4',
          // ),
          20.verticalSpace,
          textBoldPoppins(
              text: digifitExerciseDetailsState
                      .digifitExerciseEquipmentModel?.name ??
                  '',
              fontSize: 15),
          8.verticalSpace,
          textRegularMontserrat(
              text: digifitExerciseDetailsState
                      .digifitExerciseEquipmentModel?.description ??
                  '',
              textOverflow: TextOverflow.visible,
              textAlign: TextAlign.start),
          12.verticalSpace,
          textBoldPoppins(
              text: AppLocalizations.of(context).digifit_recommended_exercise,
              fontSize: 13),
          8.verticalSpace,
          textRegularMontserrat(
              text: digifitExerciseDetailsState
                      .digifitExerciseEquipmentModel?.recommendation.sets ??
                  '',
              textOverflow: TextOverflow.visible,
              textAlign: TextAlign.start),
          textRegularMontserrat(
              text: digifitExerciseDetailsState.digifitExerciseEquipmentModel
                      ?.recommendation.repetitions ??
                  '',
              textOverflow: TextOverflow.visible,
              textAlign: TextAlign.start),
          30.verticalSpace,
          CustomButton(
              iconHeight: 15.h,
              iconWidth: 15.w,
              icon: imagePath['scan_icon'],
              onPressed: () async {
                final barcode = await ref
                    .read(navigationProvider)
                    .navigateUsingPath(
                        path: digifitQRScannerScreenPath, context: context);
                // Todo - replace with actual QR code login
                if (barcode != null) {
                  print('Scanned barcode: $barcode');
                }
              },
              text: AppLocalizations.of(context).scan_exercise),
          20.verticalSpace,

          if (digifitExerciseDetailsState
              .digifitExerciseRelatedEquipmentsModel.isNotEmpty)
            _buildCourseDetailSection(
                isButtonVisible: false,
                relatedEquipments: digifitExerciseDetailsState
                    .digifitExerciseRelatedEquipmentsModel),
        ],
      ),
    );
  }

  _buildCourseDetailSection(
      {bool? isButtonVisible,
      required List<DigifitExerciseRelatedEquipmentModel> relatedEquipments}) {
    final equipments = ref
        .watch(digifitExerciseDetailsControllerProvider)
        .digifitExerciseEquipmentModel;

    return Column(
      children: [
        20.verticalSpace,
        Row(
          children: [
            textRegularPoppins(
                text: equipments?.name ?? '',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge?.color),
            12.horizontalSpace,
            ImageUtil.loadSvgImage(
                imageUrl: imagePath['arrow_icon'] ?? "",
                height: 10.h,
                width: 16.w,
                context: context)
          ],
        ),
        10.verticalSpace,
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: relatedEquipments.length,
            itemBuilder: (context, index) {
              var equipment = relatedEquipments[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: DigifitTextImageCard(
                    imageUrl: '',
                    heading: equipment.muscleGroups,
                    title: equipment.name,
                    isFavouriteVisible:
                        !ref.watch(homeScreenProvider).isSignInButtonVisible,
                    isFavorite: equipment.isFavorite,
                    sourceId: 1),
              );
            }),
        10.verticalSpace,
        Visibility(
          visible: isButtonVisible ?? true,
          child: CustomButton(
              onPressed: () {}, text: AppLocalizations.of(context).show_course),
        )
      ],
    );
  }
}
