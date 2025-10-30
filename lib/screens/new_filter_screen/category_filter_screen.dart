import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/navigation/navigation.dart';
import 'package:kusel/screens/new_filter_screen/new_filter_screen_controller.dart';

import '../../common_widgets/image_utility.dart';
import '../../common_widgets/text_styles.dart';
import '../../l10n/app_localizations.dart';

class CategoryFilterScreen extends ConsumerStatefulWidget {

  CategoryFilterScreen({super.key});

  @override
  ConsumerState<CategoryFilterScreen> createState() =>
      _CategoryFilterScreenState();
}

class _CategoryFilterScreenState extends ConsumerState<CategoryFilterScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(context), body: _buildBody(context));
  }

  _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: false,
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      leading: IconButton(
          onPressed: () {
            ref.read(navigationProvider).removeTopPage(context: context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).shadowColor,
          )),
      title: textBoldPoppins(
          text: AppLocalizations.of(context).category, fontSize: 20),
    );
  }

  _buildBody(BuildContext context) {

    final controller =
        ref.watch(newFilterScreenControllerProvider);
    final controllerNotifier =
        ref.read(newFilterScreenControllerProvider.notifier);
    final theme = Theme.of(context);
    final appLoc = AppLocalizations.of(context);

    return Container(
      height: 400.h,
      margin: EdgeInsets.symmetric(vertical:32.h,horizontal: 16.w ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: theme.canvasColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SelectableRow(
            label: appLoc.all,
            isSelected: controller.selectedCategoryId.isEmpty,
            onTap: () => controllerNotifier.updateCategoryAllValue(),
          ),
          const Divider(thickness: 2),
          if (controller.categoryList.isNotEmpty)
            Expanded(
              child: ListView.separated(
                itemCount: controller.categoryList.length,
                separatorBuilder: (_, __) => SizedBox(height: 4.h),
                itemBuilder: (context, index) {
                  final category = controller.categoryList[index];
                  return _SelectableRow(
                    label: category.name ?? '',
                    isSelected: controller.selectedCategoryId.contains(category.id)?true:false,
                    onTap: () =>
                        controllerNotifier.updateSelectedCategoryList(category),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _SelectableRow extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectableRow({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          children: [
            SizedBox(
              height: 30.h,
              width: 35.w,
              child: isSelected
                  ? ImageUtil.loadLocalSvgImage(
                      height: 30.h,
                      width: 35.w,
                      imageUrl: "correct",
                      context: context,
                    )
                  : null,
            ),
            16.horizontalSpace,
            textBoldMontserrat(text: label, fontSize: 14),
          ],
        ),
      ),
    );
  }
}
