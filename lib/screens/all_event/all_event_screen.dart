import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _buildBody(context),
    ).loaderDialog(context, ref.watch(allEventScreenProvider).isLoading);
  }

  Widget _buildBody(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          automaticallyImplyLeading: false,
          floating: true,
          pinned: false,
          expandedHeight: MediaQuery.of(context).size.height * 0.15,
          flexibleSpace: FlexibleSpaceBar(
            background: ClipPath(
              clipper: UpstreamWaveClipper(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  imagePath['background_image'] ?? "",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          title: Row(
            children: [
              ArrowBackWidget(
                onTap: () {
                  ref.read(navigationProvider).removeTopPage(context: context);
                },
                size: 15,
              ),
              Expanded(
                child: Center(
                  child: textBoldPoppins(
                    color: lightThemeSecondaryColor,
                    fontSize: 16,
                    textAlign: TextAlign.center,
                    text: "Events",
                  ),
                ),
              ),
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
                  child: SizedBox(
                    height: 30.h,
                    width: 100.w,
                    child: Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.r, vertical: 7.h),
                          decoration: BoxDecoration(
                            color: (ref
                                            .watch(allEventScreenProvider)
                                            .filterCount !=
                                        null &&
                                    ref
                                            .watch(allEventScreenProvider)
                                            .filterCount! >
                                        0)
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
                                    color: (ref
                                                    .watch(
                                                        allEventScreenProvider)
                                                    .filterCount !=
                                                null &&
                                            ref
                                                    .watch(
                                                        allEventScreenProvider)
                                                    .filterCount! >
                                                0)
                                        ? Theme.of(context).primaryColor
                                        : Theme.of(context).colorScheme.onPrimary),
                              ),
                              4.horizontalSpace,
                              textRegularPoppins(
                                  text: "Filters",
                                  fontSize: 12,
                                  color: (ref
                                                  .watch(allEventScreenProvider)
                                                  .filterCount !=
                                              null &&
                                          ref
                                                  .watch(allEventScreenProvider)
                                                  .filterCount! >
                                              0)
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).colorScheme.onPrimary),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: (ref
                                      .watch(allEventScreenProvider)
                                      .filterCount !=
                                  null &&
                              ref.watch(allEventScreenProvider).filterCount! >
                                  0),
                          child: Positioned(
                            top: 4.h,
                            left: 75.w,
                            child: Container(
                              padding: EdgeInsets.all(4.h.w),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).primaryColor),
                              child: textRegularPoppins(
                                  color: Theme.of(context).textTheme.labelSmall?.color,
                                  fontSize: 10,
                                  text: ref
                                      .watch(allEventScreenProvider)
                                      .filterCount
                                      .toString()),
                            ),
                          ),
                        )
                      ],
                    ),
                  ))
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.onSecondary.withValues(alpha: 0.6),
        ),

        // If no events exist, show a message using a SliverFillRemaining
        if(!ref.watch(allEventScreenProvider).isLoading)
        ref.watch(allEventScreenProvider).listingList.isEmpty
            ? SliverFillRemaining(
                child: Center(
                  child: textHeadingMontserrat(
                      text: AppLocalizations.of(context).no_data),
                ),
              )
            : SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
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
                      onTap: () {
                        ref.read(navigationProvider).navigateUsingPath(
                              context: context,
                              path: eventScreenPath,
                              params: EventDetailScreenParams(eventId: item.id),
                            );
                      },
                      isFavouriteVisible: ref
                          .watch(favoritesProvider.notifier)
                          .showFavoriteIcon(), sourceId: item.sourceId!,
                    );
                  },
                  childCount:
                      ref.watch(allEventScreenProvider).listingList.length,
                ),
              ),
      ],
    );
  }
}
