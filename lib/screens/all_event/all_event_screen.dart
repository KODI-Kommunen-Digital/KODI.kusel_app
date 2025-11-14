import 'package:flutter/material.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/common_background_clipper_widget.dart';
import 'package:kusel/common_widgets/date_picker/date_picker_provider.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/screens/all_event/all_event_screen_controller.dart';
import 'package:kusel/screens/all_event/all_event_screen_param.dart';
import 'package:kusel/screens/fliter_screen/filter_screen.dart';
import 'package:kusel/screens/fliter_screen/filter_screen_controller.dart';
import 'package:kusel/screens/new_filter_screen/new_filter_screen_params.dart';

import '../../common_widgets/arrow_back_widget.dart';
import '../../common_widgets/event_list_section_widget.dart';
import '../../common_widgets/image_utility.dart';
import '../../common_widgets/text_styles.dart';
import '../../common_widgets/upstream_wave_clipper.dart';
import '../../images_path.dart';
import '../../navigation/navigation.dart';

class AllEventScreen extends ConsumerStatefulWidget {
  String screenName = "allEventScreen";

  AllEventScreenParam allEventScreenParam;

  AllEventScreen({super.key, required this.allEventScreenParam});

  @override
  ConsumerState<AllEventScreen> createState() => _AllEventScreenState();
}

class _AllEventScreenState extends ConsumerState<AllEventScreen> {
  @override
  void initState() {
    Future.microtask(() {
      final state = ref.watch(allEventScreenProvider);
      final controller = ref.read(allEventScreenProvider.notifier);

      controller.getListing(state.currentPageNo);
      ref.read(filterScreenProvider.notifier).onReset();
      ref.read(datePickerProvider.notifier).resetDates();
      controller.isUserLoggedIn();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentPageNumber = ref.read(allEventScreenProvider).currentPageNo;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(child: _buildBody(context)),
    ).loaderDialog(context, ref.watch(allEventScreenProvider).isLoading);
  }

  Widget _buildBody(BuildContext context) {
    final controller = ref.read(allEventScreenProvider.notifier);
    final state = ref.watch(allEventScreenProvider);

    return Stack(
      children: [
        NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowIndicator();
            return true;
          },
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              children: [
                CommonBackgroundClipperWidget(
                  clipperType: UpstreamWaveClipper(),
                  height: 110.h,
                  headingTextLeftMargin: 20,
                  imageUrl: imagePath['home_screen_background'] ?? '',
                  isStaticImage: true,
                  isBackArrowEnabled: false,
                  headingText: AppLocalizations.of(context).events,
                ),
                _buildFilter(context),
                8.verticalSpace,
                if (state.selectedCategoryNameList.isNotEmpty)
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 16.w,vertical: 8.h),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        runAlignment: WrapAlignment.start,
                        spacing: 8.w,
                        runSpacing: 6.h,
                        children: state.selectedCategoryNameList.map((value) {
                          return _buildChip(value);
                        }).toList(),
                      ),
                    ),
                  ),
                if (!state.isLoading) _buildList(context)
              ],
            ),
          ),
        ),
        Positioned(
          top: 30.h,
          left: 5.h,
          child: ArrowBackWidget(
            onTap: () {
              ref.read(navigationProvider).removeTopPage(context: context);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String label, {bool isExtra = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isExtra
            ? Theme.of(context).indicatorColor.withOpacity(0.2)
            : Theme.of(context).indicatorColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Theme.of(context).indicatorColor,
        ),
      ),
      child: textRegularMontserrat(
          text: label,
          fontSize: 13,
          color: Theme.of(context).textTheme.displayMedium!.color),
    );
  }

  _buildFilter(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          final state = ref.read(allEventScreenProvider);

          ref
              .read(navigationProvider)
              .navigateUsingPath(
                  path: newFilterScreenPath,
                  context: context,
                  params: NewFilterScreenParams(
                      selectedCityId: state.selectedCityId,
                      selectedCityName: state.selectedCityName,
                      radius: state.radius,
                      startDate: state.startDate,
                      endDate: state.endDate,
                      selectedCategoryName:
                          List.from(state.selectedCategoryNameList),
                      selectedCategoryId:
                          List.from(state.selectedCategoryIdList)))
              .then((value) async {
            if (value != null) {
              final res = value as NewFilterScreenParams;

              await ref
                  .read(allEventScreenProvider.notifier)
                  .applyNewFilterValues(
                      res.selectedCategoryName,
                      res.selectedCityId,
                      res.selectedCityName,
                      res.radius,
                      res.startDate,
                      res.endDate,
                      res.selectedCategoryId);

              await ref.read(allEventScreenProvider.notifier).getListing(1);
            }
          });
        },
        child: Badge(
          backgroundColor: Colors.transparent,
          alignment: Alignment.topCenter,
          isLabelVisible:
              ref.watch(allEventScreenProvider).numberOfFiltersApplied != 0,
          label: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).indicatorColor,
                border:
                    Border.all(color: Theme.of(context).colorScheme.secondary)),
            child: Center(
              child: textBoldMontserrat(
                  text: ref
                      .watch(allEventScreenProvider)
                      .numberOfFiltersApplied
                      .toString(),
                  fontSize: 14),
            ),
          ),
          child: ImageUtil.loadLocalSvgImage(
              imageUrl: 'filter_button',
              context: context,
              height: 35.h,
              width: 35.w),
        ),
      ),
    );
  }

  _buildList(BuildContext context) {
    final controller = ref.read(allEventScreenProvider.notifier);
    final state = ref.watch(allEventScreenProvider);

    return (state.listingList.isEmpty)
        ? Center(
            child: textHeadingMontserrat(
                text: AppLocalizations.of(context).no_data),
          )
        : EventsListSectionWidget(
            eventsList: state.listingList,
            heading: null,
            maxListLimit: state.listingList.length,
            buttonText: null,
            buttonIconPath: null,
            isLoading: false,
            onButtonTap: () {},
            context: context,
            isFavVisible: true,
            onHeadingTap: () {},
            onSuccess: (bool isFav, int? id) {
              controller.updateIsFav(isFav, id);
              widget.allEventScreenParam.onFavChange();
            },
            onFavClickCallback: () {
              controller.getListing(state.currentPageNo);
            },
            isMultiplePagesList: state.isLoadMoreButtonEnabled,
            onLoadMoreTap: () {
              controller.onLoadMoreList(state.currentPageNo);
            },
            isMoreListLoading: state.isMoreListLoading);
  }
}
