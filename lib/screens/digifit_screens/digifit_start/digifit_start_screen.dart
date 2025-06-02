import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/common_background_clipper_widget.dart';
import 'package:kusel/common_widgets/custom_button_widget.dart';
import 'package:kusel/common_widgets/digifit/digifit_options_card.dart';
import 'package:kusel/common_widgets/digifit/digifit_text_image_card.dart';
import 'package:kusel/common_widgets/feedback_card_widget.dart';
import 'package:kusel/common_widgets/upstream_wave_clipper.dart';

import '../../../common_widgets/digifit/digifit_map_card.dart';
import '../../../common_widgets/digifit/digifit_status_widget.dart';
import '../../../common_widgets/image_utility.dart';
import '../../../common_widgets/text_styles.dart';
import '../../../images_path.dart';
import '../../../navigation/navigation.dart';

class DigifitStartScreen extends ConsumerStatefulWidget {
  const DigifitStartScreen({super.key});

  @override
  ConsumerState<DigifitStartScreen> createState() => _DigifitStartScreenState();
}

class _DigifitStartScreenState extends ConsumerState<DigifitStartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Stack(
            children: [
              // Background
              CommonBackgroundClipperWidget(
                height: 200.h,
                clipperType: UpstreamWaveClipper(),
                imageUrl: imagePath['home_screen_background'] ?? '',
                isStaticImage: true,
              ),

              Positioned(
                top: 30.h,
                left: 10.r,
                child: _buildHeadingArrowSection(),
              ),

              Padding(
                padding: EdgeInsets.only(top: 100.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDigifitOverviewScreenUi(),
                    30.verticalSpace,
                    FeedbackCardWidget(
                      height: 270.h,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildHeadingArrowSection() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            ref.read(navigationProvider).removeTopPage(context: context);
          },
          icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
        ),
        16.horizontalSpace,
        textBoldPoppins(
          color: Theme.of(context).textTheme.labelLarge?.color,
          fontSize: 20,
          text: AppLocalizations.of(context).digifit_parcours,
        ),
      ],
    );
  }

  _buildDigifitOverviewScreenUi() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        children: [
          DigifitStatusWidget(
            pointsValue: 60,
            pointsText: AppLocalizations.of(context).points,
            trophiesValue: 2,
            trophiesText: AppLocalizations.of(context).trophies,
            onButtonTap: () {},
          ),
          20.verticalSpace,
          Row(
            children: [
              Expanded(
                child: DigifitOptionsCard(
                  cardText: AppLocalizations.of(context).brain_teasers,
                  svgImageUrl: imagePath['brain_teaser_icon'] ?? '',
                  onCardTap: () {},
                ),
              ),
              8.horizontalSpace,
              Expanded(
                child: DigifitOptionsCard(
                  cardText: AppLocalizations.of(context).points_and_trophy,
                  svgImageUrl: imagePath['trophy_icon'] ?? '',
                  onCardTap: () {
                    ref.read(navigationProvider).navigateUsingPath(
                        path: digifitTrophiesScreenPath, context: context);
                  },
                ),
              ),
            ],
          ),
          12.verticalSpace,
          _buildCourseDetailSection(),
          _buildCourseDetailSection(),
          _buildCourseDetailSection(),
        ],
      ),
    );
  }

  _buildCourseDetailSection({bool? isButtonVisible}) {
    return Column(
      children: [
        20.verticalSpace,
        Row(
          children: [
            textRegularPoppins(
                text: "Parcours Kusel",
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
        DigifitMapCard(
          imagePath: imagePath['digifit_map_image'] ?? '',
          onImageTap: () {
            ref.read(navigationProvider).navigateUsingPath(
                path: digifitOverViewScreenPath, context: context);
          },
        ),
        10.verticalSpace,
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 5,
            itemBuilder: (item, _) {
              return Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: DigifitTextImageCard(
                    imageUrl: '',
                    heading: "Muskelgruppen",
                    title: "Beinpresse",
                    isFavouriteVisible: true,
                    isFavorite: false,
                    sourceId: 1,
                    isMarked: true),
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
