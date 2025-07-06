import 'package:domain/model/response_model/digifit/digifit_exercise_details_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/common_background_clipper_widget.dart';
import 'package:kusel/common_widgets/feedback_card_widget.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/common_widgets/upstream_wave_clipper.dart';
import 'package:kusel/images_path.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:kusel/screens/digifit_screens/digifit_exercise_detail/params/digifit_exercise_details_params.dart';
import 'package:kusel/screens/digifit_screens/digifit_exercise_detail/digifit_exercise_card/digifit_card_exercise_details_controller.dart';
import 'package:kusel/screens/digifit_screens/digifit_exercise_detail/video_player/digifit_video_player_widget.dart';
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
              widget.digifitExerciseDetailsParams.station.id ?? 0,
              widget.digifitExerciseDetailsParams.station.name ?? '');
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
          // ExerciseCard(),
          DigifitVideoPlayerWidget(
            videoUrl: 'assets/video/Kusel_1.mp4',
          ),
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
                ref
                    .read(digifitCardExerciseDetailsControllerProvider.notifier)
                    .updateIconBackgroundVisibility(true);

                // final barcode = await ref
                //     .read(navigationProvider)
                //     .navigateUsingPath(
                //         path: digifitQRScannerScreenPath, context: context);
                // // Todo - replace with actual QR code login
                // if (barcode != null) {
                //   print('Scanned barcode: $barcode');
                // }
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
      children: [
        20.verticalSpace,
        Row(
          children: [
            Flexible(
                child: textRegularPoppins(
              text: equipments?.name ?? '',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyLarge?.color,
              maxLines: 1,
            )),
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

class ExerciseCard extends StatelessWidget {
  const ExerciseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 330, // enough height to accommodate all
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          /// 1. Blue background at top
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Color(0xFF233B8C),
              borderRadius: BorderRadius.circular(20),
            ),
          ),

          /// 2. Pause card (at the bottom)
          Positioned(
            top: 180, // right after blue background ends
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 300, // space from bottom
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(top: 18),
                        alignment: Alignment.bottomRight,
                        color: Colors.pink,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('Pause',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(width: 34),
                            Text('01:00 Min'),
                            SizedBox(width: 34),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: Color(0xFF233B8C),
                        child: Icon(Icons.skip_next,
                            color: Colors.white, size: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// 3. Satz/Wdh. card (floating on top)
          Positioned(
            top: 140, // less than pause to overlay it
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: 300,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Satz',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('3 / 5'),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Wdh.',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('12'),
                      ],
                    ),
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: Color(0xFF233B8C),
                      child: Icon(Icons.check, color: Colors.white, size: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// 4. Play button on blue area
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Center(
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20,
                child: Icon(Icons.play_arrow, color: Color(0xFF233B8C)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
