import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/common_widgets/upstream_wave_clipper.dart';
import 'package:kusel/screens/explore/explore_screen_controller.dart';
import 'package:kusel/screens/explore/explore_screen_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../common_widgets/category_grid_card_view.dart';
import '../../common_widgets/downstream_wave_clipper.dart';
import '../../images_path.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(exploreScreenProvider.notifier).getCategories();
    });  }

    @override
    Widget build(BuildContext context) {
      final ExploreScreenState exploreScreenState = ref.watch(
          exploreScreenProvider);
      return SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background image at the top
                  Positioned(
                    top: 0.h,
                    child: ClipPath(
                      clipper: UpstreamWaveClipper(),
                      child: SizedBox(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * .15,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        child: Image.asset(
                          imagePath['background_image'] ?? "",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  // Blurred overlay
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 0),
                      child: Container(
                        color: Theme
                            .of(context)
                            .cardColor
                            .withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  exploreScreenState.loading ?? false
                      ? const Center(child: CircularProgressIndicator())
                      : Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: categoryView(exploreScreenState, context),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  categoryView(ExploreScreenState exploreScreenState, BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 8.r, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          24.verticalSpace,
          Padding(
            padding: EdgeInsets.only(left: 16.w),
            child: textBoldPoppins(text: AppLocalizations.of(context).category_heading),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height*0.2,
            child: Expanded(
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                  gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 200.h
                  ),
                  itemCount: exploreScreenState.exploreCategories.length,
                  itemBuilder: (BuildContext context, int index) {
                    var exploreCategory =
                        exploreScreenState.exploreCategories[index];
                    return CategoryGridCardView(
                      imageUrl:
                          "https://fastly.picsum.photos/id/452/200/200.jpg?hmac=f5vORXpRW2GF7jaYrCkzX3EwDowO7OXgUaVYM2NNRXY",
                      title: exploreCategory.name ?? "",
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

