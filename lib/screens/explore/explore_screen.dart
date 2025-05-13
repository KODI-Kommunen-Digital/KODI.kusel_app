import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/screens/explore/explore_card_view.dart';
import 'package:kusel/screens/explore/explore_controller.dart';

import '../../app_router.dart';
import '../../common_widgets/feedback_card_widget.dart';
import '../../common_widgets/text_styles.dart';
import '../../common_widgets/upstream_wave_clipper.dart';
import '../../images_path.dart';
import '../../navigation/navigation.dart';
import '../municipal_party_detail/widget/municipal_detail_screen_params.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref
          .read(exploreControllerProvider.notifier)
          .initialCall(exploreTypeList: [
        AppLocalizations.of(context).virtual_town_hall,
        AppLocalizations.of(context).my_town,
        AppLocalizations.of(context).tourism_and_leisure,
        AppLocalizations.of(context).mobility,
        AppLocalizations.of(context).get_involved
      ], exploreTypeListImage: [
        "virtual_town_hall",
        "my_town",
        "tourism_and_lesiure",
        "mobility",
        "get_involved"
      ]);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        body: _buildBody(context),
      ),
    );
  }

  _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildClipper(context),
          _buildExploreView(context),
          32.verticalSpace,
          FeedbackCardWidget(
            onTap: () {
              ref.read(navigationProvider).navigateUsingPath(
                  path: feedbackScreenPath, context: context);
            },
          ),
          100.verticalSpace
        ],
      ),
    );
  }

  _buildClipper(context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.16,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image at the top
              Positioned(
                top: 0.h,
                child: ClipPath(
                  clipper: UpstreamWaveClipper(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * .16,
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset(
                      imagePath['background_image'] ?? "",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              // Blurred overlay
              Positioned.fill(
                child: ClipPath(
                  clipper: UpstreamWaveClipper(),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2, sigmaY: 0),
                    child: Container(
                      color: Theme.of(context).cardColor.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16.r,
                top: 68.h,
                child: textBoldPoppins(
                    color: Theme.of(context).textTheme.labelLarge?.color,
                    fontSize: 18,
                    text: AppLocalizations.of(context).category_heading),
              ),
            ],
          ),
        )
      ],
    );
  }

  _buildExploreView(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final controller = ref.read(exploreControllerProvider.notifier);
      final state = ref.watch(exploreControllerProvider);

      if (state.exploreTypeList.isEmpty) {
        // Show a placeholder during initial load
        return SizedBox(
          height: 300.h, // reserve space to avoid layout shift
          child: Center(child: CircularProgressIndicator()),
        );
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: state.exploreTypeList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          return ExploreGridCardView(
            imageName: state.exploreTypeListImages[index],
            title: state.exploreTypeList[index],
            onTap: whereToNavigate(index),
          );
        },
      );
    });
  }


  whereToNavigate(int index) {
    void Function()? onTap;
    switch (index) {
      case 0:
        onTap = () {
          ref.read(navigationProvider).navigateUsingPath(
              path: virtualTownHallScreenPath, context: context);
        };
        break;
      case 1:
        onTap = () {
          ref.read(navigationProvider).navigateUsingPath(
              path: meinOrtScreenPath, context: context,
          );
        };
        break;
      case 3:
        onTap = () {
          ref.read(navigationProvider).navigateUsingPath(
              path: mobilityScreenPath, context: context,
          );
        };
        break;
      case 4:
        onTap = () {
          ref.read(navigationProvider).navigateUsingPath(
            path: participateScreenPath, context: context,
          );
        };
        break;
      default:
        onTap = null;
    }

    return onTap;
  }
}
