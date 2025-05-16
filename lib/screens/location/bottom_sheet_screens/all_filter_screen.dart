import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/screens/location/location_screen_provider.dart';

import '../../../common_widgets/image_utility.dart';
import '../../../images_path.dart';
import '../bottom_sheet_selected_ui_type.dart';

class AllFilterScreen extends ConsumerStatefulWidget {
  const AllFilterScreen({super.key});

  @override
  ConsumerState<AllFilterScreen> createState() => _AllFilterScreenState();
}

class _AllFilterScreenState extends ConsumerState<AllFilterScreen> {

  @override
  void initState() {
    Future.microtask(() {
      ref.read(locationScreenProvider.notifier).getAllEventList();
      ref.read(locationScreenProvider.notifier).setSliderHeight(BottomSheetSelectedUIType.allEvent);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    return Column(
      children: [
        16.verticalSpace,
        Container(
          height: 5.h,
          width: 100.w,
          decoration: BoxDecoration(
              color: Theme.of(context).textTheme.labelMedium!.color,
              borderRadius: BorderRadius.circular(10.r)),
        ),
        32.verticalSpace,
        Expanded(
          child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: ref
                  .watch(locationScreenProvider)
                  .distinctFilterCategoryList
                  .length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisExtent: 70.h,
                  mainAxisSpacing: 16.h),
              itemBuilder: (context, index) {
                final listing = ref
                    .read(locationScreenProvider)
                    .distinctFilterCategoryList[index];

                return filterCard(
                    "map_fav", listing.categoryId?.toString() ?? "", listing.categoryName?.toString() ?? "");
              }),
        )
      ],
    );
  }

  filterCard(String image, String categoryID, String categoryName) {
    return GestureDetector(
      onTap: () {
        ref.read(locationScreenProvider.notifier).updateSelectedCategory(int.parse(categoryID), categoryName);
        ref.read(locationScreenProvider.notifier).updateBottomSheetSelectedUIType(
                BottomSheetSelectedUIType.eventList);
      },
      child: Column(
        children: [
          Material(
            elevation: 6,
            shape: const CircleBorder(),
            color:
                Theme.of(context).colorScheme.onPrimary, // background color
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
              child: ImageUtil.loadSvgImage(
                      imageUrl :imagePath['heart_icon'] ?? '',
                      context: context,
                    fit: BoxFit.contain,
                  )
              ),
            ),
          5.verticalSpace,
          textRegularMontserrat(text: categoryName, fontSize: 13),
        ],
      ),
    );
  }
}
