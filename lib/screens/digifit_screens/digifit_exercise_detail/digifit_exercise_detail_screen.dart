import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/common_background_clipper_widget.dart';
import 'package:kusel/common_widgets/feedback_card_widget.dart';
import 'package:kusel/common_widgets/upstream_wave_clipper.dart';
import 'package:kusel/images_path.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../app_router.dart';
import '../../../common_widgets/arrow_back_widget.dart';
import '../../../common_widgets/custom_button_widget.dart';
import '../../../common_widgets/digifit/digifit_text_image_card.dart';
import '../../../common_widgets/image_utility.dart';
import '../../../common_widgets/text_styles.dart';
import '../../../navigation/navigation.dart';

class DigifitExerciseDetailScreen extends ConsumerStatefulWidget {
  const DigifitExerciseDetailScreen({super.key});

  @override
  ConsumerState<DigifitExerciseDetailScreen> createState() =>
      _DigifitExerciseDetailScreenState();
}

class _DigifitExerciseDetailScreenState
    extends ConsumerState<DigifitExerciseDetailScreen> {
  @override
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 13.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // DigifitVideoPlayerWidget(
          //   videoUrl: 'assets/video/test_video_2.mp4',
          // ),
          20.verticalSpace,
          textBoldPoppins(text: "Brustpresse", fontSize: 15),
          8.verticalSpace,
          textRegularMontserrat(
              text:
                  "Die Brustpresse kräftigt die Brustmuskulatur, Trizeps und den vorderen Teil der Schulter.",
              textOverflow: TextOverflow.visible,
              textAlign: TextAlign.start),
          12.verticalSpace,
          textBoldPoppins(text: "Empfohlen:", fontSize: 13),
          8.verticalSpace,
          textRegularMontserrat(
              text: "4 - 5 Sätze",
              textOverflow: TextOverflow.visible,
              textAlign: TextAlign.start),
          textRegularMontserrat(
              text: "8 - 12 wiederholungen",
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
          _buildCourseDetailSection(isButtonVisible: false)
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
                    isMarked: false),
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
