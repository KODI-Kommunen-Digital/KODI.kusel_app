import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/screens/location/location_screen_provider.dart';

import '../../../common_widgets/category_icon.dart';
import '../../../common_widgets/image_utility.dart';
import '../bottom_sheet_selected_ui_type.dart';
import '../filter_category.dart';

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
      ref
          .read(locationScreenProvider.notifier)
          .setSliderHeight(BottomSheetSelectedUIType.allEvent);
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
    return SingleChildScrollView(
      child: Column(children: [
        16.verticalSpace,
        Container(
          height: 5.h,
          width: 100.w,
          padding: EdgeInsets.only(left: 8.w, right: 18.w, bottom: 40.h),
          decoration: BoxDecoration(
            color: Theme.of(context).textTheme.labelMedium!.color,
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        32.verticalSpace,
        GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: staticFilterCategoryList(context).length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisExtent: 90.h,
            crossAxisSpacing: 20.h,
            mainAxisSpacing: 16.h,
          ),
          itemBuilder: (context, index) {
            final listing = staticFilterCategoryList(context)[index];
            final imagePath = getCategoryIconPath(listing.categoryId);

            return filterCard(
                imagePath, listing.categoryId.toString(), listing.categoryName);
          },
        ),
        50.verticalSpace,
      ]),
    );
  }

  filterCard(String image, String categoryID, String categoryName) {
    return GestureDetector(
      onTap: () {
        ref
            .read(locationScreenProvider.notifier)
            .updateSelectedCategory(int.parse(categoryID), categoryName);
        ref
            .read(locationScreenProvider.notifier)
            .updateBottomSheetSelectedUIType(
            BottomSheetSelectedUIType.eventList);

      },
      child: Column(
        children: [
          Material(
            elevation: 6,
            shape: const CircleBorder(),
            color: Theme.of(context).colorScheme.onPrimary, // background color
            child: Padding(
              padding:  EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
              child: SizedBox(
                height: 20.h,
                width: 20.w,
                child: ImageUtil.loadLocalSvgImage(
                  imageUrl: image,
                  context: context,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          5.verticalSpace,
          textRegularMontserrat(text: categoryName, fontSize: 13, textAlign: TextAlign.center, textOverflow: TextOverflow.visible),
        ],
      ),
    );
  }
}
