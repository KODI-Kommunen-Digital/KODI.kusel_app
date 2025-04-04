import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/common_widgets/upstream_wave_clipper.dart';
import 'package:kusel/navigation/navigation.dart';
import 'package:kusel/screens/category/category_screen_controller.dart';
import 'package:kusel/screens/category/category_screen_state.dart';
import 'package:kusel/screens/sub_category/sub_category_screen_parameter.dart';

import '../../common_widgets/category_grid_card_view.dart';
import '../../images_path.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({super.key});

  @override
  ConsumerState<CategoryScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(categoryScreenProvider.notifier).getCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final CategoryScreenState categoryScreenState =
        ref.watch(categoryScreenProvider);
    return SafeArea(
      child: Scaffold(
        body: _buildBody(categoryScreenState, context),
      ).loaderDialog(context, categoryScreenState.loading),
    );
  }

  _buildBody(CategoryScreenState categoryScreenState, BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image at the top
            Positioned(
              top: 0.h,
              child: ClipPath(
                clipper: UpstreamWaveClipper(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * .15,
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
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 0),
                child: Container(
                  color: Theme.of(context).cardColor.withValues(alpha: 0.6),
                ),
              ),
            ),

            Positioned(
              left: 16.r,
              top: 24.h,
              child: textBoldPoppins(
                  text: AppLocalizations.of(context).category_heading),
            ),

            Positioned.fill(
                top: MediaQuery.of(context).size.height * .15,
                child: categoryView(categoryScreenState, context))
          ],
        ),
      ),
    );
  }

  categoryView(CategoryScreenState categoryScreenState, BuildContext context) {
    return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisExtent: 200.h),
        itemCount: categoryScreenState.exploreCategories.length,
        itemBuilder: (BuildContext context, int index) {
          var exploreCategory = categoryScreenState.exploreCategories[index];
          return GestureDetector(
            onTap: () {
              ref.read(navigationProvider).navigateUsingPath(
                  path: subCategoryScreenPath,
                  context: context,
                  params:
                      SubCategoryScreenParameters(id: exploreCategory.id ?? 0));
            },
            child: CategoryGridCardView(
              imageUrl:
                  "https://fastly.picsum.photos/id/452/200/200.jpg?hmac=f5vORXpRW2GF7jaYrCkzX3EwDowO7OXgUaVYM2NNRXY",
              title: exploreCategory.name ?? "",
            ),
          );
        });
  }
}
