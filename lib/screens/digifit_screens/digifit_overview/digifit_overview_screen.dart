import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/common_background_clipper_widget.dart';
import 'package:kusel/common_widgets/custom_button_widget.dart';
import 'package:kusel/common_widgets/digifit/digifit_text_image_card.dart';
import 'package:kusel/common_widgets/feedback_card_widget.dart';

import '../../../common_widgets/digifit/digifit_status_widget.dart';
import '../../../common_widgets/downstream_wave_clipper.dart';
import '../../../common_widgets/image_utility.dart';
import '../../../common_widgets/text_styles.dart';
import '../../../images_path.dart';

class DigifitOverviewScreen extends ConsumerStatefulWidget {
  const DigifitOverviewScreen({super.key});

  @override
  ConsumerState<DigifitOverviewScreen> createState() =>
      _DigifitOverviewScreenState();
}

class _DigifitOverviewScreenState extends ConsumerState<DigifitOverviewScreen> {
  @override
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
          top: 180.h,
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
              context: context,
            ),
          ),
        )
      ],
    );
  }

  _buildDigifitTrophiesScreenUi() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textBoldPoppins(
            color: Theme.of(context).textTheme.labelLarge?.color,
            fontSize: 20,
            textAlign: TextAlign.left,
            text: AppLocalizations.of(context).show_course,
          ),
          12.verticalSpace,
          DigifitStatusWidget(
            pointsValue: 60,
            pointsText: AppLocalizations.of(context).points,
            trophiesValue: 2,
            trophiesText: AppLocalizations.of(context).trophies,
            onButtonTap: () {},
          ),
          20.verticalSpace,
          _buildCourseDetailSection(isButtonVisible: false),
          _buildCourseDetailSection(isButtonVisible: false),
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
