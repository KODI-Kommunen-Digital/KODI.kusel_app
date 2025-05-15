import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/common_event_card.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/common_widgets/upstream_wave_clipper.dart';
import 'package:kusel/navigation/navigation.dart';
import 'package:kusel/screens/event/event_detail_screen_controller.dart';
import 'package:kusel/screens/events_listing/selected_event_list_screen_controller.dart';
import 'package:kusel/screens/events_listing/selected_event_list_screen_parameter.dart';
import 'package:kusel/screens/home/home_screen_provider.dart';
import 'package:kusel/screens/search_result/search_result_screen_parameter.dart';
import 'package:kusel/screens/search_result/search_result_screen_provider.dart';
import 'package:kusel/screens/search_result/search_result_screen_state.dart';

import '../../common_widgets/arrow_back_widget.dart';
import '../../images_path.dart';
import '../../theme_manager/colors.dart';
import '../dashboard/dashboard_screen_provider.dart';
import '../events_listing/selected_event_list_screen_parameter.dart';
import '../search/search_screen_provider.dart';

class SearchResultScreen extends ConsumerStatefulWidget {
  final SearchResultScreenParameter searchResultScreenParameter;

  const SearchResultScreen(
      {super.key, required this.searchResultScreenParameter});

  @override
  ConsumerState<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends ConsumerState<SearchResultScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .watch(searchResultScreenProvider.notifier)
          .getEventsList(widget.searchResultScreenParameter.searchType);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final SearchResultScreenState categoryScreenState =
        ref.watch(searchResultScreenProvider);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: categoryScreenState.loading
            ? const Center(child: CircularProgressIndicator())
            : _buildBody(categoryScreenState, context),
      ),
    );
  }

  Widget _buildBody(
      SearchResultScreenState categoryScreenState, BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          toolbarHeight: MediaQuery.of(context).size.height * 0.1,
          automaticallyImplyLeading: false,
          floating: true,
          pinned: false,
          expandedHeight: MediaQuery.of(context).size.height * 0.2,
          flexibleSpace: FlexibleSpaceBar(
            background: ClipPath(
              clipper: UpstreamWaveClipper(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
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
                    text: AppLocalizations.of(context).search_result ?? "",
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.onSecondary.withValues(alpha: 0.6),
        ),

        categoryScreenState.groupedEvents.isEmpty
            ? SliverFillRemaining(
                child: Center(
                  child: textHeadingMontserrat(
                      text: AppLocalizations.of(context).no_data),
                ),
              )
            : SliverList(
                delegate: SliverChildListDelegate(
                  categoryScreenState.groupedEvents.entries.expand((entry) {
                    final categoryId = entry.key;
                    final items = ref
                        .read(searchResultScreenProvider.notifier)
                        .subList(entry.value);

                    return [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 24),
                        child: InkWell(
                          onTap: () {
                            ref.read(navigationProvider).navigateUsingPath(
                                path: selectedEventListScreenPath,
                                params: SelectedEventListScreenParameter(
                                    listHeading: AppLocalizations.of(context)
                                        .search_heading,
                                    categoryId: items.first.categoryId),
                                context: context);
                          },
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 10.w),
                                child: textRegularPoppins(
                                    text: items.isNotEmpty ? items.first.categoryName ?? "" : "",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color),
                              ),
                              12.horizontalSpace,
                              SvgPicture.asset(
                                imagePath['arrow_icon'] ?? "",
                                height: 10.h,
                                width: 16.w,
                              )
                            ],
                          ),
                        ),
                      ),
                      ...items.map((item) {
                        return CommonEventCard(
                          isFavorite: item.isFavorite ?? false,
                          imageUrl: item.logo ?? "",
                          date: item.startDate ?? "",
                          title: item.title ?? "",
                          location: item.address ?? "",
                          onTap: () {
                            ref.read(navigationProvider).navigateUsingPath(
                                  context: context,
                                  path: eventDetailScreenPath,
                                  params: EventDetailScreenParams(eventId: item.id),
                                );
                          },
                          isFavouriteVisible: !ref
                              .watch(homeScreenProvider)
                              .isSignupButtonVisible, sourceId: item.sourceId!,
                        );
                      }),
                    ];
                  }).toList(),
                ),
              )
      ],
    );
  }
}
