import 'package:domain/model/response_model/digifit/digifit_exercise_details_response_model.dart';
import 'package:domain/model/response_model/digifit/digifit_information_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/common_background_clipper_widget.dart';
import 'package:kusel/common_widgets/feedback_card_widget.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/common_widgets/upstream_wave_clipper.dart';
import 'package:kusel/images_path.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:kusel/providers/digifit_equipment_fav_provider.dart';
import 'package:kusel/screens/digifit_screens/digifit_exercise_detail/digifit_exercise_card/digifit_card_exercise_details_controller.dart';
import 'package:kusel/screens/digifit_screens/digifit_exercise_detail/params/digifit_exercise_details_params.dart';
import 'package:kusel/screens/digifit_screens/digifit_exercise_detail/video_player/digifit_video_player_widget.dart';
import 'package:kusel/screens/home/home_screen_provider.dart';

import '../../../app_router.dart';
import '../../../common_widgets/arrow_back_widget.dart';
import '../../../common_widgets/common_bottom_nav_card_.dart';
import '../../../common_widgets/custom_button_widget.dart';
import '../../../common_widgets/digifit/digifit_text_image_card.dart';
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
    Future.microtask(() {
      ref
          .read(digifitExerciseDetailsControllerProvider.notifier)
          .fetchDigifitExerciseDetails(
              widget.digifitExerciseDetailsParams.station.id ?? 0,
              widget.digifitExerciseDetailsParams.locationId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
          child: Stack(
        children: [
          Positioned.fill(
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
                      )),
                ],
              ),
            ),
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
                    !ref.watch(homeScreenProvider).isSignInButtonVisible,
                isFav: ref
                        .watch(digifitExerciseDetailsControllerProvider)
                        .digifitExerciseEquipmentModel
                        ?.isFavorite ??
                    false,
                onFavChange: () async {
                  final equipment = ref
                      .read(digifitExerciseDetailsControllerProvider)
                      .digifitExerciseEquipmentModel;

                  if (equipment != null) {
                    DigifitEquipmentFavParams params =
                        DigifitEquipmentFavParams(
                            isFavorite: !equipment.isFavorite,
                            equipmentId: equipment.id,
                            locationId:
                                widget.digifitExerciseDetailsParams.locationId);

                    await ref
                        .read(digifitExerciseDetailsControllerProvider.notifier)
                        .onFavTap(
                            digifitEquipmentFavParams: params,
                            onFavStatusChange: ref
                                .read(digifitExerciseDetailsControllerProvider
                                    .notifier)
                                .detailPageOnFavStatusChange);

                    if (widget.digifitExerciseDetailsParams.onFavCallBack !=
                        null) {
                      widget.digifitExerciseDetailsParams.onFavCallBack!();
                    }
                  }
                },
              ))
        ],
      )),
    ).loaderDialog(
        context, ref.read(digifitExerciseDetailsControllerProvider).isLoading);
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
        Visibility(
            visible: ref
                    .read(digifitExerciseDetailsControllerProvider)
                    .digifitExerciseEquipmentModel
                    ?.userProgress
                    .isCompleted ??
                false,
            child: _isCompletedCard())
      ],
    );
  }

  _isCompletedCard() {
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
          DigifitVideoPlayerWidget(
            videoUrl: 'assets/video/Kusel_1.mp4',
          ),
          20.verticalSpace,
          textBoldPoppins(
              text: digifitExerciseDetailsState
                      .digifitExerciseEquipmentModel?.name ??
                  '',
              fontSize: 15,
              textOverflow: TextOverflow.visible,
              textAlign: TextAlign.start),
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
                // ref
                //     .read(digifitCardExerciseDetailsControllerProvider.notifier)
                //     .updateIconBackgroundVisibility(true);

                final barcode = await ref
                    .read(navigationProvider)
                    .navigateUsingPath(
                        path: digifitQRScannerScreenPath, context: context);

                if(barcode!=null)
                  {


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
      required List<DigifitExerciseRelatedStationsModel> relatedEquipments}) {
    final equipments = ref
        .watch(digifitExerciseDetailsControllerProvider)
        .digifitExerciseEquipmentModel;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textRegularPoppins(
            text: equipments?.name ?? '',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            textOverflow: TextOverflow.visible,
            color: Theme.of(context).textTheme.bodyLarge?.color,
            textAlign: TextAlign.start),

        10.verticalSpace,

        // related equipments list
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: relatedEquipments.length,
            itemBuilder: (context, index) {
              var equipment = relatedEquipments[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: DigifitTextImageCard(
                  onCardTap: () {
                    ref.read(navigationProvider).navigateUsingPath(
                        path: digifitExerciseDetailScreenPath,
                        context: context,
                        params: DigifitExerciseDetailsParams(
                            station: DigifitInformationStationModel(
                              id: equipment.id,
                              name: equipment.name,
                              isFavorite: equipment.isFavorite,
                              muscleGroups: equipment.muscleGroups,
                            ),
                            locationId: widget
                                    .digifitExerciseDetailsParams.locationId ??
                                0,
                            onFavCallBack: () {
                              ref
                                  .read(digifitExerciseDetailsControllerProvider
                                      .notifier)
                                  .fetchDigifitExerciseDetails(
                                      widget.digifitExerciseDetailsParams
                                              .station.id ??
                                          0,
                                      widget.digifitExerciseDetailsParams
                                          .locationId);
                            }));
                  },
                  imageUrl: '',
                  heading: equipment.muscleGroups,
                  title: equipment.name,
                  isFavouriteVisible:
                      !ref.watch(homeScreenProvider).isSignInButtonVisible,
                  isFavorite: equipment.isFavorite,
                  sourceId: 1,
                  onFavorite: () async {
                    DigifitEquipmentFavParams params =
                        DigifitEquipmentFavParams(
                            isFavorite: !equipment.isFavorite,
                            equipmentId: equipment.id,
                            locationId:
                                widget.digifitExerciseDetailsParams.locationId);

                    await ref
                        .read(digifitExerciseDetailsControllerProvider.notifier)
                        .onFavTap(
                            digifitEquipmentFavParams: params,
                            onFavStatusChange: ref
                                .read(digifitExerciseDetailsControllerProvider
                                    .notifier)
                                .recommendOnFavStatusChange);

                    if (widget.digifitExerciseDetailsParams.onFavCallBack !=
                        null) {
                      widget.digifitExerciseDetailsParams.onFavCallBack!();
                    }
                  },
                ),
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
