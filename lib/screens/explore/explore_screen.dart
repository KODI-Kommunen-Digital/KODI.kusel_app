import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/navigation/navigation.dart';
import 'package:kusel/screens/explore/explore_screen_controller.dart';
import 'package:kusel/screens/explore/explore_screen_state.dart';
import 'package:kusel/screens/sub_category/sub_category_screen_parameter.dart';

import '../../common_widgets/category_grid_card_view.dart';
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final ExploreScreenState exploreScreenState =
        ref.watch(exploreScreenProvider);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background image at the top
                Positioned(
                  top: 0.h,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * .3,
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset(
                      imagePath['background_image'] ?? "",
                      fit: BoxFit.cover,
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
                exploreScreenState.loading ?? false
                    ? const Center(child: CircularProgressIndicator())
                    : Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: categoryView(exploreScreenState),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  categoryView(ExploreScreenState exploreScreenState) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.r, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          24.verticalSpace,
          Padding(
            padding: EdgeInsets.only(left: 16.w),
            child: textBoldPoppins(text: "Was gibt’s zu entdecken"),
          ),
          Expanded(
            child: GridView.builder(
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, mainAxisExtent: 200.h),
                itemCount: exploreScreenState.exploreCategories.length,
                itemBuilder: (BuildContext context, int index) {
                  var exploreCategory =
                      exploreScreenState.exploreCategories[index];
                  return GestureDetector(
                    onTap: () {
                      ref.read(navigationProvider).navigateUsingPath(
                          path: subCategoryScreenPath,
                          context: context,
                          params: SubCategoryScreenParameters(
                              id: exploreCategory.id ?? 0));
                    },
                    child: CategoryGridCardView(
                      imageUrl:
                          "https://fastly.picsum.photos/id/452/200/200.jpg?hmac=f5vORXpRW2GF7jaYrCkzX3EwDowO7OXgUaVYM2NNRXY",
                      title: exploreCategory.name ?? "",
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
