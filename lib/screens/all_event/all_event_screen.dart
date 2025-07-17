import 'package:flutter/material.dart';
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

import '../../common_widgets/arrow_back_widget.dart';
import '../../common_widgets/event_list_section_widget.dart';
import '../../common_widgets/text_styles.dart';
import '../../common_widgets/upstream_wave_clipper.dart';
import '../../images_path.dart';
import '../../navigation/navigation.dart';

class AllEventScreen extends ConsumerStatefulWidget {
  AllEventScreenParam allEventScreenParam;

  AllEventScreen({super.key, required this.allEventScreenParam});

  @override
  ConsumerState<AllEventScreen> createState() => _AllEventScreenState();
}

class _AllEventScreenState extends ConsumerState<AllEventScreen> {
  @override
  void initState() {
    Future.microtask(() {
      final currentPageNumber = ref.read(allEventScreenProvider).currentPageNo;
      ref
          .read(allEventScreenProvider.notifier)
          .getEventsList(currentPageNumber);
      ref.read(filterScreenProvider.notifier).onReset();
      ref.read(datePickerProvider.notifier).resetDates();
      ref.read(allEventScreenProvider.notifier).isUserLoggedIn();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentPageNumber = ref.read(allEventScreenProvider).currentPageNo;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(child: _buildBody(context, currentPageNumber)),
    ).loaderDialog(context, ref.watch(allEventScreenProvider).isLoading);
  }

  Widget _buildBody(BuildContext context, int currentPageNumber) {
    bool isFilterApplied =
        ref.watch(allEventScreenProvider).filterCount != null &&
            ref.watch(allEventScreenProvider).filterCount! > 0;
    return Stack(
      children: [
        SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            children: [
              CommonBackgroundClipperWidget(
                clipperType: UpstreamWaveClipper(),
                height: 130.h,
                headingTextLeftMargin: 20,
                imageUrl: imagePath['home_screen_background'] ?? '',
                isStaticImage: true,
                isBackArrowEnabled: false,
                headingText: AppLocalizations.of(context).events,
                customWidget1: _buildFilterWidget(isFilterApplied),
              ),
              if (!ref.watch(allEventScreenProvider).isLoading)
                ref.watch(allEventScreenProvider).listingList.isEmpty
                    ? Center(
                        child: textHeadingMontserrat(
                            text: AppLocalizations.of(context).no_data),
                      )
                    : EventsListSectionWidget(
                        eventsList:
                            ref.watch(allEventScreenProvider).listingList,
                        heading: null,
                        maxListLimit: ref
                            .watch(allEventScreenProvider)
                            .listingList
                            .length,
                        buttonText: null,
                        buttonIconPath: null,
                        isLoading: false,
                        onButtonTap: () {},
                        context: context,
                        isFavVisible:
                            ref.watch(allEventScreenProvider).isUserLoggedIn,
                        onHeadingTap: () {},
                        onSuccess: (bool isFav, int? id) {
                          ref
                              .read(allEventScreenProvider.notifier)
                              .updateIsFav(isFav, id);
                          widget.allEventScreenParam.onFavChange();
                        },
                        onFavClickCallback: () {
                          ref
                              .read(allEventScreenProvider.notifier)
                              .getEventsList(currentPageNumber);
                        },
                        isMultiplePagesList: true,
                        onLoadMoreTap: () {
                          ref
                              .read(allEventScreenProvider.notifier)
                              .onLoadMoreList(currentPageNumber);
                        },
                        isMoreListLoading: ref
                            .watch(allEventScreenProvider)
                            .isMoreListLoading),
            ],
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

  _buildFilterWidget(bool isFilterApplied) {
    return Positioned(
      top: 120,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20.r)),
                    ),
                    builder: (context) => SizedBox(
                        height: MediaQuery.of(context).size.height * 0.80,
                        child: FilterScreen()),
                  );
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.r, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: isFilterApplied
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Center(
                        child: Image.asset(imagePath['filter_icon'] ?? '',
                            height: 14.h,
                            width: 20.w,
                            color: isFilterApplied
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).colorScheme.onPrimary),
                      ),
                      4.horizontalSpace,
                      textRegularPoppins(
                          text: AppLocalizations.of(context).settings,
                          fontSize: 12,
                          color: isFilterApplied
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).colorScheme.onPrimary),
                      8.horizontalSpace,
                      Visibility(
                        visible: isFilterApplied,
                        child: Container(
                          padding: EdgeInsets.all(4.h.w),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).primaryColor),
                          child: textRegularPoppins(
                              color:
                                  Theme.of(context).textTheme.labelSmall?.color,
                              fontSize: 10,
                              text: ref
                                  .watch(allEventScreenProvider)
                                  .filterCount
                                  .toString()),
                        ),
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
