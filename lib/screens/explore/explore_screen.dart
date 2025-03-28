import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/screens/explore/explore_screen_controller.dart';
import 'package:kusel/screens/explore/explore_screen_state.dart';

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
    ref.read(exploreScreenProvider.notifier).getCategories();
  }

  @override
  Widget build(BuildContext context) {
    ExploreScreenState exploreScreenState = ref.watch(exploreScreenProvider);
    final borderRadius = Radius.circular(50.r);
    return Scaffold(
        body: SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
                top: 0.h,
                child: Container(
                  height: MediaQuery.of(context).size.height * .3,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(),
                  child: Image.asset(
                    imagePath['background_image'] ?? "",
                    fit: BoxFit.cover,
                  ),
                )),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 0),
                child: Container(
                  color: Theme.of(context).cardColor.withValues(alpha: 0.6),
                ),
              ),
            ),
            Positioned(
              child: CategoryView(exploreScreenState),
            )
          ],
        ),
      ),
    ));
  }

  CategoryView(ExploreScreenState exploreScreenState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: textBoldPoppins(text: "Was gibt’s zu entdecken"),
          ),
          Expanded(
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
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
        ],
      ),
    );
  }
}
