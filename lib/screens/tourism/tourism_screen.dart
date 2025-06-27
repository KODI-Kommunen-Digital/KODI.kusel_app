import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/feedback_card_widget.dart';
import 'package:kusel/common_widgets/highlights_card.dart';
import 'package:kusel/common_widgets/image_utility.dart';
import 'package:kusel/common_widgets/listing_id_enum.dart';
import 'package:kusel/common_widgets/local_image_text_service_card.dart';
import 'package:kusel/screens/all_event/all_event_screen_param.dart';
import 'package:kusel/screens/event/event_detail_screen_controller.dart';
import 'package:kusel/screens/events_listing/selected_event_list_screen_parameter.dart';
import 'package:kusel/screens/tourism/tourism_screen_controller.dart';
import 'package:kusel/utility/url_launcher_utility.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common_widgets/arrow_back_widget.dart';
import '../../common_widgets/common_background_clipper_widget.dart';
import '../../common_widgets/common_text_arrow_widget.dart';
import '../../common_widgets/event_list_section_widget.dart';
import '../../common_widgets/location_const.dart';
import '../../common_widgets/map_widget/custom_flutter_map.dart';
import '../../common_widgets/text_styles.dart';
import '../../common_widgets/toast_message.dart';
import '../../common_widgets/upstream_wave_clipper.dart';
import '../../common_widgets/web_view_page.dart';
import '../../images_path.dart';
import '../../navigation/navigation.dart';
import '../../providers/favorites_list_notifier.dart';

class TourismScreen extends ConsumerStatefulWidget {
  const TourismScreen({super.key});

  @override
  ConsumerState<TourismScreen> createState() => _TourismScreenState();
}

class _TourismScreenState extends ConsumerState<TourismScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref
          .read(tourismScreenControllerProvider.notifier)
          .getRecommendationListing();
      ref.read(tourismScreenControllerProvider.notifier).getAllEvents();
      ref.read(tourismScreenControllerProvider.notifier).getNearByListing();

      ref.read(tourismScreenControllerProvider.notifier).isUserLoggedIn();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          (ref.watch(tourismScreenControllerProvider).isRecommendationLoading)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    final state = ref.watch(tourismScreenControllerProvider);
    return SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonBackgroundClipperWidget(
                    clipperType: UpstreamWaveClipper(),
                    imageUrl: imagePath['background_image'] ?? "",
                    headingText: AppLocalizations.of(context).tourism_and_leisure,
                    height: 150.h,
                    blurredBackground: true,
                    isBackArrowEnabled: false,
                    isStaticImage: true),
                _buildRecommendation(context),
                32.verticalSpace,
                _buildLocationWidget(context),
                16.verticalSpace,
                if (state.nearByList.isNotEmpty)
                  EventsListSectionWidget(
                    context: context,
                    eventsList: state.nearByList,
                    heading: AppLocalizations.of(context).near_you,
                    maxListLimit: 5,
                    buttonText: AppLocalizations.of(context).near_you,
                    buttonIconPath: imagePath['map_icon'] ?? "",
                    isLoading: false,
                    onButtonTap: () {
                      final searchRadius = SearchRadius.radius.value;
                      ref.read(navigationProvider).navigateUsingPath(
                          path: selectedEventListScreenPath,
                          context: context,
                          params: SelectedEventListScreenParameter(
                              listHeading: AppLocalizations.of(context).near_you,
                              centerLongitude: state.long,
                              centerLatitude: state.lat,
                              radius: searchRadius,
                              onFavChange: () {
                                ref
                                    .read(tourismScreenControllerProvider.notifier)
                                    .getNearByListing();
                              }));
                    },
                    onHeadingTap: () {
                      final searchRadius = SearchRadius.radius.value;
                      ref.read(navigationProvider).navigateUsingPath(
                          path: selectedEventListScreenPath,
                          context: context,
                          params: SelectedEventListScreenParameter(
                              listHeading: AppLocalizations.of(context).near_you,
                              centerLongitude: state.long,
                              centerLatitude: state.lat,
                              radius: searchRadius,
                              onFavChange: () {
                                ref
                                    .read(tourismScreenControllerProvider.notifier)
                                    .getNearByListing();
                              }));
                    },
                    isFavVisible: state.isUserLoggedIn,
                    onSuccess: (bool isFav, int? id) {
                      ref
                          .read(tourismScreenControllerProvider.notifier)
                          .updateNearByIsFav(isFav, id);
                    },
                  ),
                LocalSvgImageTextServiceCard(
                  onTap: () => ref.read(navigationProvider).navigateUsingPath(
                      path: webViewPagePath,
                      params: WebViewParams(url: "https://www.landkreis-kusel.de"),
                      context: context),
                  imageUrl: 'tourism_service_image',
                  text: AppLocalizations.of(context).hiking_trails,
                  description: AppLocalizations.of(context).discover_kusel_on_foot,
                ),
                if (state.allEventList.isNotEmpty)
                  EventsListSectionWidget(
                    context: context,
                    eventsList: state.allEventList,
                    heading: AppLocalizations.of(context).all_events,
                    maxListLimit: 5,
                    buttonText: AppLocalizations.of(context).all_events,
                    buttonIconPath: imagePath['calendar'] ?? "",
                    isLoading: false,
                    onButtonTap: () {
                      ref.read(navigationProvider).navigateUsingPath(
                          path: selectedEventListScreenPath,
                          context: context,
                          params: SelectedEventListScreenParameter(
                              listHeading: AppLocalizations.of(context).all_events,
                              categoryId: ListingCategoryId.event.eventId,
                              onFavChange: () {
                                ref
                                    .read(tourismScreenControllerProvider.notifier)
                                    .getAllEvents();
                              }));
                    },
                    onHeadingTap: () {
                      ref.read(navigationProvider).navigateUsingPath(
                          path: selectedEventListScreenPath,
                          context: context,
                          params: SelectedEventListScreenParameter(
                              listHeading: AppLocalizations.of(context).all_events,
                              categoryId: ListingCategoryId.event.eventId,
                              onFavChange: () {
                                ref
                                    .read(tourismScreenControllerProvider.notifier)
                                    .getAllEvents();
                              }));
                    },
                    isFavVisible: state.isUserLoggedIn,
                    onSuccess: (bool isFav, int? id) {
                      ref
                          .read(tourismScreenControllerProvider.notifier)
                          .updateEventIsFav(isFav, id);
                    },
                  ),
                32.verticalSpace,
                FeedbackCardWidget(
                    height: 270.h,
                    onTap: () {
                  ref
                      .read(navigationProvider)
                      .navigateUsingPath(path: feedbackScreenPath, context: context);
                })
              ],
            ),
          ),
          Positioned(
            top: 30.h,
            left: 12.h,
            child: ArrowBackWidget(
              onTap: () {
                ref.read(navigationProvider).removeTopPage(context: context);
              },
            ),
          ),
        ],
      ),
    );
  }

  _buildRecommendation(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(tourismScreenControllerProvider);
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              32.verticalSpace,
              CommonTextArrowWidget(
                text: AppLocalizations.of(context).recommendations,
                onTap: () {
                  ref.read(navigationProvider).navigateUsingPath(
                      path: allEventScreenPath,
                      context: context,
                      params: AllEventScreenParam(onFavChange: () {
                        ref
                            .read(tourismScreenControllerProvider.notifier)
                            .getRecommendationListing();
                      }));
                },
              ),
              16.verticalSpace,
              SizedBox(
                height: 315.h,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: (state.recommendationList.isNotEmpty)
                        ? min(state.recommendationList.length, 5)
                        : 0,
                    itemBuilder: (context, index) {
                      final item = state.recommendationList[index];

                      return Padding(
                        padding: EdgeInsets.only(right: 16.w),
                        child: HighlightsCard(
                            date: item.startDate,
                            cardWidth: 280.w,
                            sourceId: item.sourceId ?? 3,
                            imageUrl: item.logo ?? "",
                            heading: item.title ?? "",
                            description: item.description ?? "",
                            isFavourite: item.isFavorite ?? false,
                            onPress: () {
                              ref.read(navigationProvider).navigateUsingPath(
                                  path: eventDetailScreenPath,
                                  context: context,
                                  params: EventDetailScreenParams(
                                      event: item));
                            },
                            onFavouriteIconClick: () {
                              ref
                                  .watch(favoritesProvider.notifier)
                                  .toggleFavorite(item,
                                  success: ({required bool isFavorite}) {
                                    ref
                                        .read(tourismScreenControllerProvider.notifier)
                                        .updateRecommendationIsFav
                                      (
                                        isFavorite, item.id);
                                  }, error: ({required String message}) {
                                    showErrorToast(
                                        message: message, context: context);
                                  });
                            },
                            isFavouriteVisible: state.isUserLoggedIn),
                      );
                    }),
              )
            ],
          ),
        );
      },
    );
  }

  _buildLocationWidget(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final borderRadius = 10.r;
        final list = ref.watch(tourismScreenControllerProvider).nearByList;

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          height: 300.h,
          width: double.infinity,
          decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(borderRadius)),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                width: double.infinity,
                height: 50.h,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(borderRadius),
                        topLeft: Radius.circular(borderRadius))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined),
                        10.horizontalSpace,
                        textRegularPoppins(
                            text: AppLocalizations.of(context).near_you,
                            fontSize: 14)
                      ],
                    ),
                    SizedBox(
                      height: 18.h,
                      width: 18.w,
                      child: ImageUtil.loadLocalSvgImage(
                          imageUrl: 'expand_full',
                          context: context,
                          fit: BoxFit.contain),
                    )
                  ],
                ),
              ),
              CustomFlutterMap(
                latitude: EventLatLong.kusel.latitude,
                longitude: EventLatLong.kusel.longitude,
                height: 250.h,
                width: MediaQuery.of(context).size.width,
                initialZoom: 13,
                onMapTap: () {},
                markersList: (list.isNotEmpty)
                    ? list
                    .where((item) =>
                item.latitude != null &&
                    item.longitude != null)
                    .map((item) {
                  return Marker(
                      point:
                      LatLng(item.latitude!, item.longitude!),
                      child: Icon(Icons.location_pin,
                          color: Theme.of(context)
                              .colorScheme
                              .onTertiaryFixed));
                }).toList()
                    : [],
              )
            ],
          ),
        );
      },
    );
  }
}
