import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kusel/common_widgets/custom_button_widget.dart';
import 'package:kusel/common_widgets/custom_shimmer_widget.dart';
import 'package:kusel/common_widgets/highlights_card.dart';
import 'package:kusel/common_widgets/upstream_wave_clipper.dart';
import 'package:kusel/common_widgets/weather_widget.dart';
import 'package:kusel/providers/favorites_list_notifier.dart';
import 'package:kusel/screens/event/event_screen_controller.dart';
import 'package:kusel/screens/home/home_screen_provider.dart';
import 'package:kusel/screens/home/home_screen_state.dart';

import '../../../images_path.dart';
import '../../app_router.dart';
import '../../common_widgets/common_event_card.dart';
import '../../common_widgets/feedback_card_widget.dart';
import '../../common_widgets/search_widget.dart';
import '../../common_widgets/text_styles.dart';
import '../../common_widgets/toast_message.dart';
import '../../navigation/navigation.dart';
import '../events_listing/event_list_screen_parameter.dart';
import 'package:core/sign_in_status/sign_in_status_controller.dart';

class HomeScreen extends ConsumerStatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(homeScreenProvider.notifier).getLocation();
      ref.read(homeScreenProvider.notifier).getUserDetails();
      ref.read(homeScreenProvider.notifier).getHighlights();
      ref.read(homeScreenProvider.notifier).getEvents();
      ref.read(homeScreenProvider.notifier).getNearbyEvents();
      ref.read(signInStatusProvider.notifier).getLoginStatus();
      ref.watch(homeScreenProvider.notifier).getWeather();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        body: SizedBox(
            height: MediaQuery.of(context).size.height, child: buildUi()),
      ),
    );
  }

  Widget buildUi() {
    final isLoading = ref.watch(homeScreenProvider).loading;
    HomeScreenState state = ref.watch(homeScreenProvider);
    final latitude = ref.watch(homeScreenProvider).latitude;
    final longitude = ref.watch(homeScreenProvider).longitude;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Stack(
              children: [
                isLoading
                    ? Container(
                        height: 285.h,
                      )
                    : ClipPath(
                        clipper: UpstreamWaveClipper(),
                        child: Container(
                          height: 285.h,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  imagePath['home_screen_background'] ?? ''),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                Positioned(
                  top: 85.h,
                  left: 20.w,
                  right: 20.w,
                  child: Column(
                    children: [
                      isLoading
                          ? CustomShimmerWidget.rectangular(
                              height: 20.h,
                              width: 150.w,
                              shapeBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r)))
                          : textBoldPoppins(
                              fontSize: 20,
                              color:
                                  Theme.of(context).textTheme.labelLarge?.color,
                              textAlign: TextAlign.center,
                              text: ref.watch(homeScreenProvider).userName,
                            ),
                      isLoading ? 10.verticalSpace : 0.verticalSpace,
                      isLoading
                          ? CustomShimmerWidget.rectangular(
                              height: 20.h,
                              width: 200.w,
                              shapeBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r)))
                          : textBoldPoppins(
                              fontSize: 20,
                              color:
                                  Theme.of(context).textTheme.labelLarge?.color,
                              textAlign: TextAlign.center,
                              text: "Heute wird's sonning!",
                            ),
                      32.verticalSpace,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 15.w),
                            child: textRegularPoppins(
                                text: AppLocalizations.of(context).search,
                                fontSize: 12.sp,
                                fontStyle: FontStyle.italic,
                                color: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.color),
                          ),
                          SearchWidget(
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
                              return list;
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Visibility(
                    visible:
                        ref.watch(signInStatusProvider).isSignupButtonVisible,
                    child: Positioned(
                        left: 210.w,
                        top: 30.h,
                        child: isLoading
                            ? CustomShimmerWidget.circular(
                                width: 120.w,
                                height: 30.h,
                                shapeBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.r)),
                              )
                            : GestureDetector(
                                onTap: () {
                                  ref
                                      .read(navigationProvider)
                                      .removeAllAndNavigate(
                                          context: context,
                                          path: signInScreenPath);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.r),
                                      border: Border.all(
                                          width: 2.w,
                                          color:
                                              Theme.of(context).primaryColor)),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.w, vertical: 5.h),
                                  child: textBoldPoppins(
                                      text: AppLocalizations.of(context)
                                          .log_in_sign_up,
                                      fontSize: 12.sp,
                                      color: Theme.of(context).primaryColor),
                                ),
                              )))
              ],
            ),
            customPageViewer(isLoading),
            20.verticalSpace,
            WeatherWidget(weatherResponseModel: ref.watch(homeScreenProvider).weatherResponseModel,),
            eventsView(
                state.eventsList,
                AppLocalizations.of(context).near_you,
                5,
                AppLocalizations.of(context).to_map_view,
                imagePath['map_icon'] ?? "",
                isLoading,
                latitude,
                longitude),
            eventsView(
                state.nearbyEventsList,
                AppLocalizations.of(context).all_events,
                3,
                AppLocalizations.of(context).all_events,
                imagePath['calendar'] ?? "",
                isLoading,
                latitude,
                longitude),
            FeedbackCardWidget(),
            100.verticalSpace
          ],
        ),
      ),
    );
  }

  Widget eventsView(
      List<Listing> eventsList,
      String heading,
      int maxListLimit,
      String buttonText,
      String buttonIconPath,
      bool isLoading,
      double? latitude,
      double? longitude) {
    if (isLoading) {
      return Column(
        children: [
          Padding(
              padding: EdgeInsets.fromLTRB(12.w, 16.w, 12.w, 0),
              child: CustomShimmerWidget.rectangular(
                  height: 15.h,
                  shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r)))),
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 4,
              itemBuilder: (_, index) {
                return eventCartShimmerEffect();
              }),
        ],
      );
    } else if (eventsList.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(8.w, 16.w, 0, 0),
            child: InkWell(
              onTap: () {
                ref.read(navigationProvider).navigateUsingPath(
                    path: eventListScreenPath,
                    context: context,
                    // Need to be replaced with actual lat-long value
                    params: EventListScreenParameter(
                        radius: 1,
                        centerLatitude: latitude,
                        centerLongitude: longitude,
                        categoryId: 3,
                        listHeading: heading));
              },
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: textRegularPoppins(
                        text: heading,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.labelLarge?.color),
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
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: eventsList.length > maxListLimit
                ? maxListLimit
                : eventsList.length,
            itemBuilder: (context, index) {
              final item = eventsList[index];
              return CommonEventCard(
                isFavorite: item.isFavorite ?? false,
                onFavorite: () {
                  ref.watch(favoritesProvider.notifier).toggleFavorite(item,
                      success: ({required bool isFavorite}) {
                    ref
                        .read(homeScreenProvider.notifier)
                        .setIsFavoriteEvent(isFavorite, item.id);
                  }, error: ({required String message}) {
                    showErrorToast(message: message, context: context);
                  });
                },
                imageUrl:
                    "https://fastly.picsum.photos/id/452/200/200.jpg?hmac=f5vORXpRW2GF7jaYrCkzX3EwDowO7OXgUaVYM2NNRXY",
                date: item.startDate ?? "",
                title: item.title ?? "",
                location: item.address ?? "",
                onTap: () {
                  ref.read(navigationProvider).navigateUsingPath(
                      context: context,
                      path: eventScreenPath,
                      params: EventScreenParams(eventId: item.id));
                },
                isFavouriteVisible:
                    ref.watch(favoritesProvider.notifier).showFavoriteIcon(),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: CustomButton(
                onPressed: () {
                  ref.read(navigationProvider).navigateUsingPath(
                      path: eventListScreenPath,
                      context: context,
                      // Need to be replaced with actual lat-long value
                      params: EventListScreenParameter(
                          radius: 1,
                          centerLatitude: 49.53838,
                          centerLongitude: 7.40647,
                          categoryId: 3,
                          listHeading: heading));
                },
                text: buttonText,
                icon: buttonIconPath),
          ),
          15.verticalSpace
        ],
      );
    }
    return Container();
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
                      Row(
                        children: [
                          textRegularPoppins(
                              text: AppLocalizations.of(context).highlights,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.color),
                          12.horizontalSpace,
                          SvgPicture.asset(
                            imagePath['arrow_icon'] ?? "",
                            height: 10.h,
                            width: 16.w,
                          )
                        ],
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
                                    path: eventScreenPath,
                                    params: EventScreenParams(
                                        eventId:
                                            state.highlightsList[index].id));
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
          SizedBox(
            height: 350.h,
            child: PageView.builder(
              controller: PageController(
                  viewportFraction: 317 / MediaQuery.of(context).size.width),
              scrollDirection: Axis.horizontal,
              padEnds: false,
              itemCount: state.highlightsList.length,
              itemBuilder: (context, index) {
                final listing = state.highlightsList[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.h.w),
                  child: HighlightsCard(
                    imageUrl: imagePath['highlight_card_image'] ?? '',
                    date: listing.createdAt ?? "",
                    heading: listing.title ?? "",
                    description: listing.description ?? "",
                    isFavourite: listing.isFavorite ?? false,
                    onPress: () {
                      ref.read(navigationProvider).navigateUsingPath(
                            context: context,
                            path: eventScreenPath,
                            params: EventScreenParams(eventId: listing.id),
                          );
                    },
                    onFavouriteIconClick: () {
                      ref.watch(favoritesProvider.notifier).toggleFavorite(listing,
                          success: ({required bool isFavorite}) {
                            ref
                                .read(homeScreenProvider.notifier)
                                .setIsFavoriteHighlight(isFavorite, listing.id);
                          }, error: ({required String message}) {
                            showErrorToast(message: message, context: context);
                          });
                    },
                    isVisible:
                        !ref.read(signInStatusProvider).isSignupButtonVisible,
                  ),
                );
              },
              onPageChanged: (index) {
                ref.read(homeScreenProvider.notifier).updateCardIndex(index);
              },
            ),
          ),
        ],
      ),
    );
  }
}
