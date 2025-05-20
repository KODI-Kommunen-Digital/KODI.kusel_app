import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/common_background_clipper_widget.dart';
import 'package:kusel/common_widgets/date_picker/date_picker_provider.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/screens/all_event/all_event_screen_controller.dart';
import 'package:kusel/screens/fliter_screen/filter_screen.dart';
import 'package:kusel/screens/fliter_screen/filter_screen_controller.dart';

import '../../app_router.dart';
import '../../common_widgets/arrow_back_widget.dart';
import '../../common_widgets/common_event_card.dart';
import '../../common_widgets/text_styles.dart';
import '../../common_widgets/upstream_wave_clipper.dart';
import '../../images_path.dart';
import '../../navigation/navigation.dart';
import '../../providers/favorites_list_notifier.dart';
import '../../theme_manager/colors.dart';
import '../event/event_detail_screen_controller.dart';

class AllEventScreen extends ConsumerStatefulWidget {
  const AllEventScreen({super.key});

  @override
  ConsumerState<AllEventScreen> createState() => _AllEventScreenState();
}

class _AllEventScreenState extends ConsumerState<AllEventScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(allEventScreenProvider.notifier).getEventsList();
      ref.read(filterScreenProvider.notifier).onReset();
      ref.read(datePickerProvider.notifier).resetDates();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: _buildBody(context),
      ).loaderDialog(context, ref.watch(allEventScreenProvider).isLoading),
    );
  }

  Widget _buildBody(BuildContext context) {
    bool isFilterApplied =
        ref.watch(allEventScreenProvider).filterCount != null &&
            ref.watch(allEventScreenProvider).filterCount! > 0;
    return SingleChildScrollView(
      child: Column(
        children: [
          CommonBackgroundClipperWidget(
            clipperType: UpstreamWaveClipper(),
            height: 130.h,
            imageUrl: imagePath['home_screen_background'] ?? '',
            isStaticImage: true,
            isBackArrowEnabled: true,
            headingText: AppLocalizations.of(context).events,
            customWidget1 : _buildFilterWidget(isFilterApplied),
          ),
          if (!ref.watch(allEventScreenProvider).isLoading)
            ref.watch(allEventScreenProvider).listingList.isEmpty
                ? Center(
                    child: textHeadingMontserrat(
                        text: AppLocalizations.of(context).no_data),
                  )
                : ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount:
                        ref.watch(allEventScreenProvider).listingList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final item =
                          ref.read(allEventScreenProvider).listingList[index];
                      return CommonEventCard(
                        imageUrl: item.logo ?? "",
                        date: item.startDate ?? "",
                        title: item.title ?? "",
                        location: item.address ?? "",
                        onFavorite: () {
                          ref.read(favoritesProvider.notifier).toggleFavorite(
                              item, success: ({required bool isFavorite}) {
                            ref
                                .read(allEventScreenProvider.notifier)
                                .setIsFavorite(isFavorite, item.id);
                          }, error: ({required String message}) {});
                        },
                        isFavorite: item.isFavorite ?? false,
                        onCardTap: () {
                          ref.read(navigationProvider).navigateUsingPath(
                                context: context,
                                path: eventDetailScreenPath,
                                params:
                                    EventDetailScreenParams(eventId: item.id),
                              );
                        },
                        isFavouriteVisible: ref
                            .watch(favoritesProvider.notifier)
                            .showFavoriteIcon(),
                        sourceId: item.sourceId!,
                      );
                    },
                  )
        ],
      ),
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
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.r, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: isFilterApplied
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Center(
                        child: Image.asset(
                            imagePath['filter_icon'] ?? '',
                            height: 14.h,
                            width: 20.w,
                            color: isFilterApplied
                                ? Theme.of(context).primaryColor
                                : Theme.of(context)
                                .colorScheme
                                .onPrimary),
                      ),
                      4.horizontalSpace,
                      textRegularPoppins(
                          text: AppLocalizations.of(context).settings,
                          fontSize: 12,
                          color: isFilterApplied
                              ? Theme.of(context).primaryColor
                              : Theme.of(context)
                              .colorScheme
                              .onPrimary),
                      8.horizontalSpace,
                      Visibility(
                        visible: isFilterApplied,
                        child: Container(
                          padding: EdgeInsets.all(4.h.w),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).primaryColor),
                          child: textRegularPoppins(
                              color: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.color,
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
