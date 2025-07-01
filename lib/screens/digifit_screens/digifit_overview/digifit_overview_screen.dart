import 'package:domain/model/response_model/digifit/digifit_overview_response_model.dart';
import 'package:flutter/material.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/common_background_clipper_widget.dart';
import 'package:kusel/common_widgets/custom_button_widget.dart';
import 'package:kusel/common_widgets/digifit/digifit_text_image_card.dart';
import 'package:kusel/common_widgets/feedback_card_widget.dart';
import 'package:kusel/screens/digifit_screens/digifit_overview/params/digifit_overview_params.dart';

import '../../../app_router.dart';
import '../../../common_widgets/digifit/digifit_status_widget.dart';
import '../../../common_widgets/downstream_wave_clipper.dart';
import '../../../common_widgets/image_utility.dart';
import '../../../common_widgets/text_styles.dart';
import '../../../images_path.dart';
import '../../../navigation/navigation.dart';
import 'digifit_overview_controller.dart';

class DigifitOverviewScreen extends ConsumerStatefulWidget {
  final DigifitOverviewScreenParams digifitOverviewScreenParams;

  const DigifitOverviewScreen(
      {super.key, required this.digifitOverviewScreenParams});

  @override
  ConsumerState<DigifitOverviewScreen> createState() =>
      _DigifitOverviewScreenState();
}

class _DigifitOverviewScreenState extends ConsumerState<DigifitOverviewScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(digifitOverviewScreenControllerProvider.notifier)
          .fetchDigifitOverview(widget.digifitOverviewScreenParams.location);
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildClipper(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDigifitTrophiesScreenUi(),
                  30.verticalSpace,
                  FeedbackCardWidget(
                    height: 270.h,
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClipper() {
    return Stack(
      children: [
        SizedBox(
          height: 320.h,
          child: CommonBackgroundClipperWidget(
            clipperType: DownstreamCurveClipper(),
            imageUrl: imagePath['background_image'] ?? "",
            height: 280.h,
            blurredBackground: true,
            isBackArrowEnabled: true,
            isStaticImage: true,
          ),
        ),
        Positioned(
          top: 175.h,
          left: 0.w,
          right: 0.w,
          child: Container(
            height: 120.h,
            width: 70.w,
            padding: EdgeInsets.all(25.w),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            child: ImageUtil.loadSvgImage(
              imageUrl: imagePath['dumble_icon']!,
              fit: BoxFit.contain,
              height: 40.h,
              width: 40.w,
              context: context,
            ),
          ),
        )
      ],
    );
  }

  _buildDigifitTrophiesScreenUi() {
    var digifitOverview = ref
        .watch(digifitOverviewScreenControllerProvider)
        .digifitOverviewDataModel;

    var offeneUebungen = digifitOverview?.parcours?.offeneUebungen ?? [];

    var abgeschlossen = digifitOverview?.parcours?.abgeschlossen ?? [];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textBoldPoppins(
            color: Theme.of(context).textTheme.labelLarge?.color,
            fontSize: 20,
            textAlign: TextAlign.left,
            text: digifitOverview?.parcours?.name ?? "",
          ),
          12.verticalSpace,
          DigifitStatusWidget(
            pointsValue: digifitOverview?.userStats?.points ?? 0,
            pointsText: AppLocalizations.of(context).points,
            trophiesValue: digifitOverview?.userStats?.trophies ?? 0,
            trophiesText: AppLocalizations.of(context).trophies,
            onButtonTap: () async {
              final barcode = await ref
                  .read(navigationProvider)
                  .navigateUsingPath(
                      path: digifitQRScannerScreenPath, context: context);
              // Todo - replace with actual QR code login
              if (barcode != null) {
                print('Scanned barcode: $barcode');
              }
            },
          ),
          20.verticalSpace,
          if (offeneUebungen.isNotEmpty)
            _buildCourseDetailSection(
              title: AppLocalizations.of(context).digitfit_open_exercise,
              stationList: offeneUebungen,
              isButtonVisible: false,
            ),
          if (abgeschlossen.isNotEmpty)
            _buildCourseDetailSection(
              title: AppLocalizations.of(context).digitfit_completed_exercise,
              stationList: abgeschlossen,
              isButtonVisible: true,
            ),
        ],
      ),
    );
  }

  _buildCourseDetailSection({
    bool? isButtonVisible,
    required String title,
    required List<DigifitOverviewStationModel> stationList,
  }) {
    return Column(
      children: [
        20.verticalSpace,
        Row(
          children: [
            textRegularPoppins(
                text: title,
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
            itemCount: stationList.length,
            itemBuilder: (context, index) {
              var station = stationList[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: DigifitTextImageCard(
                    imageUrl: station.machineImageUrl ?? '',
                    heading: station.muscleGroups ?? '',
                    title: station.name ?? '',
                    isFavouriteVisible: true,
                    isFavorite: station.isFavorite ?? false,
                    sourceId: 1,
                    isMarked: true),
              );
            }),
        10.verticalSpace,
      ],
    );
  }
}
