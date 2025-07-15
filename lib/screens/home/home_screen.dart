import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/common_background_clipper_widget.dart';
import 'package:kusel/common_widgets/custom_shimmer_widget.dart';
import 'package:kusel/common_widgets/event_list_section_widget.dart';
import 'package:kusel/common_widgets/highlights_card.dart';
import 'package:kusel/common_widgets/upstream_wave_clipper.dart';
import 'package:kusel/common_widgets/weather_widget.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:kusel/providers/favorites_list_notifier.dart';
import 'package:kusel/screens/dashboard/dashboard_screen_provider.dart';
import 'package:kusel/screens/event/event_detail_screen_controller.dart';
import 'package:kusel/screens/home/home_screen_provider.dart';
import 'package:kusel/screens/home/home_screen_state.dart';
import 'package:kusel/screens/no_network/network_status_screen_provider.dart';

import '../../../images_path.dart';
import '../../app_router.dart';
import '../../common_widgets/common_text_arrow_widget.dart';
import '../../common_widgets/feedback_card_widget.dart';
import '../../common_widgets/listing_id_enum.dart';
import '../../common_widgets/search_widget.dart';
import '../../common_widgets/text_styles.dart';
import '../../common_widgets/toast_message.dart';
import '../../navigation/navigation.dart';
import '../events_listing/selected_event_list_screen_parameter.dart';

class HomeScreen extends ConsumerStatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    Future.microtask(() async {

      ref.read(dashboardScreenProvider.notifier).onIndexChanged(0);
      ref.read(homeScreenProvider.notifier).initialCall();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            final networkStatus = await ref
                .read(networkStatusProvider.notifier)
                .checkNetworkStatus();
            if (networkStatus) {
              await ref.read(homeScreenProvider.notifier).refresh();
            }
          },
          child: SizedBox(
              height: MediaQuery.of(context).size.height, child: buildUi()),
        ),
      ),
    );
  }

  Widget buildUi() {
    final isLoading = ref.watch(homeScreenProvider).loading;
    final state = ref.watch(homeScreenProvider);
    final latitude = ref.watch(homeScreenProvider).latitude;
    final longitude = ref.watch(homeScreenProvider).longitude;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            CommonBackgroundClipperWidget(
              clipperType: UpstreamWaveClipper(),
              imageUrl: imagePath['home_screen_background'] ?? '',
              isStaticImage: true,
              height: 285.h,
              customWidget1: Positioned(
                top: 85.h,
                left: 20.w,
                right: 20.w,
                child: Column(
                  children: [
                    Visibility(
                        visible: !ref
                            .watch(homeScreenProvider)
                            .isSignInButtonVisible,
                        child: isLoading
                            ? CustomShimmerWidget.rectangular(
                                height: 20.h,
                                width: 150.w,
                                shapeBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r)))
                            : textBoldPoppins(
                                fontSize: 20,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color,
                                textAlign: TextAlign.center,
                                text: ref.watch(homeScreenProvider).userName,
                              )),
                    isLoading ? 10.verticalSpace : 0.verticalSpace,
                    isLoading
                        ? CustomShimmerWidget.rectangular(
                            height: 20.h,
                            width: 200.w,
                            shapeBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r)))
                        : textBoldPoppins(
                            fontSize: 20,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            textAlign: TextAlign.center,
                            textOverflow: TextOverflow.visible,
                            text: AppLocalizations.of(context)
                                .today_its_going_to_be,
                          ),
                    32.verticalSpace,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 15.w),
                          child: textRegularPoppins(
                              text: AppLocalizations.of(context).search,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color),
                        ),
                        SearchWidget(
                          onItemClick: (listing) {
                            ref.read(navigationProvider).navigateUsingPath(
                                context: context,
                                path: eventDetailScreenPath,
                                params:
                                    EventDetailScreenParams(event: listing));
                          },
                          searchController: TextEditingController(),
                          hintText:
                              AppLocalizations.of(context).enter_search_term,
                          suggestionCallback: (search) async {
                            List<Listing>? list;
                            if (search.isEmpty) return [];
                            try {
                              list = await ref
                                  .read(homeScreenProvider.notifier)
                                  .searchList(
                                      searchText: search,
                                      success: () {},
                                      error: (err) {});
                            } catch (e) {
                              return [];
                            }
                            final sortedList = ref
                                .watch(homeScreenProvider.notifier)
                                .sortSuggestionList(search, list);
                            return sortedList;
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
              customWidget2: Visibility(
                  visible: ref.watch(homeScreenProvider).isSignInButtonVisible,
                  child: Positioned(
                      left: 15.w,
                      right: 15.w,
                      top: 30.h,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            isLoading
                                ? CustomShimmerWidget.circular(
                                    width: 120.w,
                                    height: 30.h,
                                    shapeBorder: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.r)),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      ref
                                          .read(navigationProvider)
                                          .removeCurrentAndNavigate(
                                              context: context,
                                              path: signInScreenPath);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30.r),
                                          border: Border.all(
                                              width: 2.w,
                                              color: Theme.of(context)
                                                  .primaryColor)),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8.w, vertical: 5.h),
                                      child: textBoldPoppins(
                                          text: AppLocalizations.of(context)
                                              .log_in_sign_up,
                                          fontSize: 12,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.color),
                                    ),
                                  ),
                          ],
                        ),
                      ))),
            ),
            customPageViewer(isLoading),
            20.verticalSpace,
            WeatherWidget(
              weatherResponseModel:
                  ref.watch(homeScreenProvider).weatherResponseModel,
            ),
            if (ref.watch(homeScreenProvider).nearbyEventsList.isNotEmpty)
              EventsListSectionWidget(
                context: context,
                eventsList: state.nearbyEventsList,
                heading: AppLocalizations.of(context).near_you,
                maxListLimit: 5,
                buttonText: AppLocalizations.of(context).to_map_view,
                buttonIconPath: imagePath['map_icon'] ?? "",
                isLoading: isLoading,
                onButtonTap: () {
                  ref.read(navigationProvider).navigateUsingPath(
                        path: selectedEventListScreenPath,
                        context: context,
                        params: SelectedEventListScreenParameter(
                          radius: 1,
                          centerLatitude: latitude,
                          centerLongitude: longitude,
                          categoryId: 3,
                          listHeading: "Events in your area",
                          onFavChange: () {
                            ref
                                .read(homeScreenProvider.notifier)
                                .getNearbyEvents();
                          },
                        ),
                      );
                },
                onFavClickCallback: () {
                  ref.read(homeScreenProvider.notifier).getNearbyEvents();
                },
                onHeadingTap: () {
                  ref.read(navigationProvider).navigateUsingPath(
                        path: selectedEventListScreenPath,
                        context: context,
                        params: SelectedEventListScreenParameter(
                          radius: 1,
                          centerLatitude: latitude,
                          centerLongitude: longitude,
                          categoryId: 3,
                          listHeading: "Events in your area",
                          onFavChange: () {
                            ref
                                .read(homeScreenProvider.notifier)
                                .getNearbyEvents();
                          },
                        ),
                      );
                },
                isFavVisible: (state.isSignInButtonVisible) ? false : true,
                onSuccess: (bool isFav, int? id) {
                  ref
                      .read(homeScreenProvider.notifier)
                      .setIsFavoriteNearBy(isFav, id);
                },
              ),
            if (state.newsList != null && state.newsList!.isNotEmpty)
              EventsListSectionWidget(
                context: context,
                eventsList: state.newsList ?? [],
                heading: AppLocalizations.of(context).news,
                maxListLimit: 5,
                buttonText: AppLocalizations.of(context).all_news,
                buttonIconPath: imagePath['map_icon'] ?? "",
                isLoading: false,
                onButtonTap: () {
                  ref.read(navigationProvider).navigateUsingPath(
                      path: selectedEventListScreenPath,
                      context: context,
                      params: SelectedEventListScreenParameter(
                          cityId: 1,
                          listHeading: AppLocalizations.of(context).news,
                          categoryId: ListingCategoryId.news.eventId,
                          onFavChange: () {
                            ref.read(homeScreenProvider.notifier).getNews();
                          }));
                },
                onFavClickCallback: () {
                  ref.read(homeScreenProvider.notifier).getNews();
                },
                onHeadingTap: () {
                  ref.read(navigationProvider).navigateUsingPath(
                      path: selectedEventListScreenPath,
                      context: context,
                      params: SelectedEventListScreenParameter(
                          cityId: 1,
                          listHeading: AppLocalizations.of(context).news,
                          categoryId: ListingCategoryId.news.eventId,
                          onFavChange: () {
                            ref.read(homeScreenProvider.notifier).getNews();
                          }));
                },
                isFavVisible: !state.isSignInButtonVisible,
                onSuccess: (bool isFav, int? id) {
                  ref
                      .read(homeScreenProvider.notifier)
                      .updateNewsIsFav(isFav, id);
                },
              ),
            if (ref.watch(homeScreenProvider).eventsList.isNotEmpty)
              EventsListSectionWidget(
                context: context,
                eventsList: state.eventsList,
                heading: AppLocalizations.of(context).all_events,
                maxListLimit: 3,
                buttonText: AppLocalizations.of(context).all_events,
                buttonIconPath: imagePath['calendar'] ?? "",
                isLoading: isLoading,
                onButtonTap: () {
                  ref.read(navigationProvider).navigateUsingPath(
                      path: selectedEventListScreenPath,
                      context: context,
                      params: SelectedEventListScreenParameter(
                          categoryId: ListingCategoryId.event.eventId,
                          onFavChange: () {
                            ref.read(homeScreenProvider.notifier).getEvents();
                          },
                          listHeading: AppLocalizations.of(context).events));
                },
                onFavClickCallback: () {
                  ref.read(homeScreenProvider.notifier).getEvents();
                },
                onHeadingTap: () {
                  ref.read(navigationProvider).navigateUsingPath(
                      path: selectedEventListScreenPath,
                      context: context,
                      params: SelectedEventListScreenParameter(
                          categoryId: ListingCategoryId.event.eventId,
                          onFavChange: () {
                            ref.read(homeScreenProvider.notifier).getEvents();
                          },
                          listHeading: AppLocalizations.of(context).events));
                },
                onSuccess: (isFav, eventId) {
                  ref
                      .read(homeScreenProvider.notifier)
                      .setIsFavoriteEvent(isFav, eventId);
                },
                isFavVisible: (state.isSignInButtonVisible) ? false : true,
              ),
            FeedbackCardWidget(
              height: 270.h,
              onTap: () {
                ref.read(navigationProvider).navigateUsingPath(
                    path: feedbackScreenPath, context: context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget customPageViewer(bool isLoading) {
    HomeScreenState state = ref.watch(homeScreenProvider);
    int currentIndex = state.highlightCount;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Column(
        children: [
          40.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: isLoading
                ? CustomShimmerWidget.rectangular(
                    height: 30.h,
                    shapeBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r)))
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonTextArrowWidget(
                        text: AppLocalizations.of(context).highlights,
                        onTap: () {
                          ref.read(navigationProvider).navigateUsingPath(
                              path: selectedEventListScreenPath,
                              context: context,
                              params: SelectedEventListScreenParameter(
                                categoryId:
                                    ListingCategoryId.highlights.eventId,
                                listHeading:
                                    AppLocalizations.of(context).highlights,
                                onFavChange: () {
                                  ref
                                      .read(homeScreenProvider.notifier)
                                      .getHighlights();
                                },
                              ));
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            state.highlightsList.length,
                            (index) => InkWell(
                              onTap: () {
                                ref.read(navigationProvider).navigateUsingPath(
                                    context: context,
                                    path: eventDetailScreenPath,
                                    params: EventDetailScreenParams(
                                        event: state.highlightsList[index]));
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.circle,
                                    size: currentIndex == index ? 11 : 8,
                                    color: currentIndex == index
                                        ? Theme.of(context).primaryColor
                                        : Theme.of(context)
                                            .primaryColor
                                            .withAlpha(130),
                                  ),
                                  if (index != state.highlightsList.length - 1)
                                    4.horizontalSpace
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
          10.verticalSpace,
          isLoading
              ? highlightCardShimmerEffect()
              : SizedBox(
                  height: 315.h,
                  child: PageView.builder(
                    controller: PageController(
                        viewportFraction:
                            317.w / MediaQuery.of(context).size.width * .9),
                    scrollDirection: Axis.horizontal,
                    padEnds: false,
                    itemCount: state.highlightsList.length,
                    itemBuilder: (context, index) {
                      final listing = state.highlightsList[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.h.w),
                        child: HighlightsCard(
                          imageUrl: listing.logo ?? '',
                          date: listing.createdAt ?? "",
                          heading: listing.title ?? "",
                          description: listing.description ?? "",
                          errorImagePath: imagePath['kusel_map_image'],
                          isFavourite: listing.isFavorite ?? false,
                          onPress: () {
                            ref.read(navigationProvider).navigateUsingPath(
                                  context: context,
                                  path: eventDetailScreenPath,
                                  params: EventDetailScreenParams(
                                    event: listing,
                                    onFavClick: () {
                                      ref
                                          .read(homeScreenProvider.notifier)
                                          .getEvents();
                                    },
                                  ),
                                );
                          },
                          onFavouriteIconClick: () {
                            ref
                                .watch(favoritesProvider.notifier)
                                .toggleFavorite(listing,
                                    success: ({required bool isFavorite}) {
                              ref
                                  .read(homeScreenProvider.notifier)
                                  .setIsFavoriteHighlight(
                                      isFavorite, listing.id);
                            }, error: ({required String message}) {
                              showErrorToast(
                                  message: message, context: context);
                            });
                          },
                          isFavouriteVisible: !ref
                              .watch(homeScreenProvider)
                              .isSignInButtonVisible,
                          sourceId: listing.sourceId!,
                        ),
                      );
                    },
                    onPageChanged: (index) {
                      ref
                          .read(homeScreenProvider.notifier)
                          .updateCardIndex(index);
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
