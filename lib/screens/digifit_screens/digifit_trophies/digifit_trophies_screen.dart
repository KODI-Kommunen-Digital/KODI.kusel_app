import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/common_background_clipper_widget.dart';
import 'package:kusel/common_widgets/custom_button_widget.dart';
import 'package:kusel/common_widgets/digifit/digifit_text_image_card.dart';
import 'package:kusel/common_widgets/feedback_card_widget.dart';
import 'package:kusel/common_widgets/upstream_wave_clipper.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:kusel/screens/digifit_screens/digifit_trophies/digifit_user_trophies_controller.dart';

import '../../../app_router.dart';
import '../../../common_widgets/digifit/digifit_status_widget.dart';
import '../../../common_widgets/image_utility.dart';
import '../../../common_widgets/text_styles.dart';
import '../../../images_path.dart';
import '../../../navigation/navigation.dart';
import 'package:kusel/l10n/app_localizations.dart';

class DigifitTrophiesScreen extends ConsumerStatefulWidget {
  const DigifitTrophiesScreen({super.key});

  @override
  ConsumerState<DigifitTrophiesScreen> createState() => _DigifitTrophiesScreenState();
}

class _DigifitTrophiesScreenState extends ConsumerState<DigifitTrophiesScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref
          .read(digifitUserTrophiesControllerProvider.notifier)
          .fetchDigifitUserTrophies();
    });
    super.initState();
  }

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
                    _buildDigifitTrophiesScreenUi(),
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
          text: AppLocalizations.of(context).points_and_trophy,
        ),
      ],
    );
  }

  _buildDigifitTrophiesScreenUi() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        children: [
          DigifitStatusWidget(
            pointsValue: 60,
            pointsText: AppLocalizations.of(context).points,
            trophiesValue: 2,
            trophiesText: AppLocalizations.of(context).trophies,
            onButtonTap: () async {
              final barcode = await ref.read(navigationProvider).navigateUsingPath(
                  path: digifitQRScannerScreenPath, context: context);
              // Todo - replace with actual QR code login
              if (barcode != null) {
                print('Scanned barcode: $barcode');
              }
            },
          ),
          20.verticalSpace,
          _buildCourseDetailSection(isButtonVisible: false),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            textRegularPoppins(
                text: "Parcours Kusel",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge?.color),
            12.horizontalSpace,
            
            textRegularMontserrat(text: "30/36 offen")
            
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
                    isCompleted: true),
              );
            }),
        10.verticalSpace,
        Visibility(
          visible: isButtonVisible ?? true,
          child: CustomButton(
              onPressed: () {}, text: AppLocalizations.of(context).digifit_trophies_load_more),
        )
      ],
    );
  }
}
