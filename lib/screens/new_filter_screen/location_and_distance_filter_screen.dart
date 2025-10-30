import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/image_utility.dart';
import 'package:kusel/navigation/navigation.dart';
import 'package:kusel/screens/new_filter_screen/new_filter_screen_controller.dart';
import '../../common_widgets/text_styles.dart';
import '../../l10n/app_localizations.dart';

class LocationAndDistanceFilterScreen extends ConsumerStatefulWidget {

  const LocationAndDistanceFilterScreen({
    super.key,
  });

  @override
  ConsumerState<LocationAndDistanceFilterScreen> createState() =>
      _LocationAndDistanceFilterScreenState();
}

class _LocationAndDistanceFilterScreenState
    extends ConsumerState<LocationAndDistanceFilterScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLoc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: theme.colorScheme.onSecondary,
        leading: IconButton(
          onPressed: () =>
              ref.read(navigationProvider).removeTopPage(context: context),
          icon: Icon(Icons.arrow_back, color: theme.shadowColor),
        ),
        title: textBoldPoppins(text: appLoc.location_distance, fontSize: 18),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            32.verticalSpace,
            _RadiusUI(),
            16.verticalSpace,
            _CityList(),
          ],
        ),
      ),
    );
  }
}

class _RadiusUI extends ConsumerWidget {

  const _RadiusUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(newFilterScreenControllerProvider);
    final controllerNotifier =
        ref.read(newFilterScreenControllerProvider.notifier);
    final appLoc = AppLocalizations.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: Theme.of(context).canvasColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textSemiBoldMontserrat(text: appLoc.perimeter, fontSize: 14),
          16.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                flex: 7,
                child: (controller.selectedCityId == 0)
                    ? Container(
                        height: 10.h,
                        decoration: BoxDecoration(
                          color: Theme.of(context).shadowColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      )
                    : Slider(
                        value: controller.sliderValue,
                        inactiveColor:
                            Theme.of(context).indicatorColor.withOpacity(0.2),
                        thumbColor: Theme.of(context).colorScheme.secondary,
                        min: 0,
                        max: 100,
                        divisions: 100,
                        activeColor: Theme.of(context).indicatorColor,
                        label: controller.sliderValue.round().toString(),
                        onChanged: (double value) {
                          controllerNotifier.updateSliderValue(value);
                        },
                      ),
              ),
              5.horizontalSpace,
              Flexible(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: textBoldMontserrat(
                    text: "${controller.sliderValue.round()} km",
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _CityList extends ConsumerWidget {

  const _CityList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(newFilterScreenControllerProvider);
    final controllerNotifier =
        ref.read(newFilterScreenControllerProvider.notifier);
    final theme = Theme.of(context);
    final appLoc = AppLocalizations.of(context);

    return Container(
      height: 400.h,
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
            isSelected: controller.selectedCityId == 0,
            onTap: () => controllerNotifier.updateLocationAndDistanceAllValue(),
          ),
          const Divider(thickness: 2),
          if (controller.cityList.isNotEmpty)
            Expanded(
              child: ListView.separated(
                itemCount: controller.cityList.length,
                separatorBuilder: (_, __) => SizedBox(height: 4.h),
                itemBuilder: (context, index) {
                  final city = controller.cityList[index];
                  return _SelectableRow(
                    label: city.name ?? '',
                    isSelected: controller.selectedCityId == city.id,
                    onTap: () => controllerNotifier.updateSelectedCity(
                      city.id ?? 0,
                      city.name ?? "",
                    ),
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
