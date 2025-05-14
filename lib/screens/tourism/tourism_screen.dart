import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/image_utility.dart';
import 'package:kusel/screens/tourism/tourism_screen_controller.dart';

import '../../common_widgets/arrow_back_widget.dart';
import '../../common_widgets/common_text_arrow_widget.dart';
import '../../common_widgets/text_styles.dart';
import '../../common_widgets/upstream_wave_clipper.dart';
import '../../navigation/navigation.dart';
import '../../theme_manager/colors.dart';

class TourismScreen extends ConsumerStatefulWidget {
  const TourismScreen({super.key});

  @override
  ConsumerState<TourismScreen> createState() => _TourismScreenState();
}

class _TourismScreenState extends ConsumerState<TourismScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _buildBody(context),
      ),
    );
  }

  _buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildClipper(context), _buildRecommendation(context)],
    );
  }

  _buildClipper(context) {
    return Column(
      children: [
        SizedBox(
          height: 150.h,
          width: double.infinity,
          child: Stack(
            children: [
              ClipPath(
                clipper: UpstreamWaveClipper(),
                child: Container(
                  decoration: BoxDecoration(),
                  height: 150.h,
                  width: double.infinity,
                  child: ImageUtil.loadLocalAssetImage(
                    imageUrl: 'background_image',
                    context: context,
                  ),
                ),
              ),
              Positioned(
                top: 30.h,
                left: 15.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ArrowBackWidget(
                      onTap: () {
                        ref
                            .read(navigationProvider)
                            .removeTopPage(context: context);
                      },
                    ),
                    20.horizontalSpace,
                    textBoldPoppins(
                      color: lightThemeSecondaryColor,
                      fontSize: 18,
                      textAlign: TextAlign.center,
                      text: AppLocalizations.of(context).tourism_and_leisure,
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  _buildRecommendation(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(tourismScreenControllerProvider);
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              32.verticalSpace,
              CommonTextArrowWidget(
                text: AppLocalizations.of(context).recommendation,
                onTap: () {},
              )
            ],
          ),
        );
      },
    );
  }
}
