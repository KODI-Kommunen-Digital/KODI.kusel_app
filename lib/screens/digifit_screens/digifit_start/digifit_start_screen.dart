import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/common_background_clipper_widget.dart';
import 'package:kusel/common_widgets/digifit/digifit_options_card.dart';
import 'package:kusel/common_widgets/feedback_card_widget.dart';
import 'package:kusel/common_widgets/upstream_wave_clipper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../common_widgets/digifit/digifit_status_widget.dart';
import '../../../common_widgets/text_styles.dart';
import '../../../images_path.dart';
import '../../../navigation/navigation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
      body: SafeArea(child:
          SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  CommonBackgroundClipperWidget(
                      height: 200.h,
                      clipperType: UpstreamWaveClipper(),
                      imageUrl: imagePath['home_screen_background'] ?? '',
                      isStaticImage: true,
                    customWidget1:  Positioned(
                      left: 10.r,
                      top: 30.h,
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                ref
                                    .read(navigationProvider)
                                    .removeTopPage(context: context);
                              },
                              icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor,)
                          ),
                          16.horizontalSpace,
                          textBoldPoppins(
                              color: Theme.of(context).textTheme.labelLarge?.color,
                              fontSize: 20,
                              text: AppLocalizations.of(context).digifit_parcours
                          ),
                    ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 100.h,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Column(
                            children: [
                              DigifitStatusWidget(
                                  pointsValue: 60,
                                  pointsText: AppLocalizations.of(context).points,
                                  trophiesValue: 2,
                                  trophiesText: AppLocalizations.of(context).trophies,
                                  onButtonTap: (){}),
                              20.verticalSpace,
                              Row(
                                children: [
                                  Expanded(child: DigifitOptionsCard(cardText: AppLocalizations.of(context).brain_teasers, svgImageUrl: imagePath['brain_teaser_icon']??'', onCardTap: (){})),
                                  8.horizontalSpace,
                                  Expanded(child: DigifitOptionsCard(cardText: AppLocalizations.of(context).points_and_trophy, svgImageUrl: imagePath['trophy_icon']??'', onCardTap: (){}))
                                ],
                              ),
                            ],
                          ),
                        ),
                        30.verticalSpace,
                        FeedbackCardWidget(
                            height: 270.h,
                            onTap: (){})

                      ],
                    ),
                  )
                ],
              ),
            ),
          )
      ),
    );
  }
}
