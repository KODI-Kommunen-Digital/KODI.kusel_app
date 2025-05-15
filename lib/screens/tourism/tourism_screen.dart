import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/common_event_card.dart';
import 'package:kusel/common_widgets/custom_button_widget.dart';
import 'package:kusel/common_widgets/feedback_card_widget.dart';
import 'package:kusel/common_widgets/highlights_card.dart';
import 'package:kusel/common_widgets/image_utility.dart';
import 'package:kusel/common_widgets/listing_id_enum.dart';
import 'package:kusel/screens/event/event_detail_screen_controller.dart';
import 'package:kusel/screens/events_listing/selected_event_list_screen_parameter.dart';
import 'package:kusel/screens/tourism/tourism_screen_controller.dart';
import 'package:latlong2/latlong.dart';

import '../../common_widgets/arrow_back_widget.dart';
import '../../common_widgets/common_text_arrow_widget.dart';
import '../../common_widgets/text_styles.dart';
import '../../common_widgets/upstream_wave_clipper.dart';
import '../../navigation/navigation.dart';
import '../../theme_manager/colors.dart';

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
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _buildBody(context),
      ),
    );
  }

  _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildClipper(context),
          _buildRecommendation(context),
          32.verticalSpace,
          _buildLocationWidget(context),
          16.verticalSpace,
          _buildNearYou(context),
          _buildAllEvent(context),
          32.verticalSpace,
          FeedbackCardWidget(onTap: () {
            ref.read(navigationProvider).navigateUsingPath(
                path: feedbackScreenPath, context: context);
          })
        ],
      ),
    );
  }

  _buildClipper(context) {
    return Column(
      children: [
        SizedBox(
          height: 150.h,
          width: double.infinity,
          child: Stack(
            children: [
              ClipPath(
                clipper: UpstreamWaveClipper(),
                child: Container(
                  decoration: BoxDecoration(),
                  height: 150.h,
                  width: double.infinity,
                  child: ImageUtil.loadLocalAssetImage(
                    imageUrl: 'background_image',
                    context: context,
                  ),
                ),
              ),
              Positioned(
                top: 30.h,
                left: 15.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ArrowBackWidget(
                      onTap: () {
                        ref
                            .read(navigationProvider)
                            .removeTopPage(context: context);
                      },
                    ),
                    20.horizontalSpace,
                    textBoldPoppins(
                      color: lightThemeSecondaryColor,
                      fontSize: 18,
                      textAlign: TextAlign.center,
                      text: AppLocalizations.of(context).tourism_and_leisure,
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
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
                text: AppLocalizations.of(context).recommendation,
                onTap: () {
                  ref.read(navigationProvider).navigateUsingPath(
                      path: selectedEventListScreenPath,
                      context: context,
                      params: SelectedEventListScreenParameter(
                          listHeading:
                              AppLocalizations.of(context).recommendation));
                },
              ),
              16.verticalSpace,
              SizedBox(
                height: 320.h,
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
                            cardWidth: 250.w,
                            sourceId: item.sourceId ?? 3,
                            imageUrl: item.logo ?? "",
                            heading: item.title ?? "",
                            description: item.description ?? "",
                            isFavourite: false,
                            onPress: () {
                              ref.read(navigationProvider).navigateUsingPath(
                                  path: eventDetailScreenPath,
                                  context: context,
                                  params: EventDetailScreenParams(
                                      eventId: item.id));
                            },
                            onFavouriteIconClick: () {},
                            isVisible: false),
                      );
                    }),
              )
            ],
          ),
        );
      },
    );
  }

  _buildNearYou(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(tourismScreenControllerProvider);
        return (state.nearByList.isNotEmpty)
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    32.verticalSpace,
                    CommonTextArrowWidget(
                      text: AppLocalizations.of(context).near_you,
                      onTap: () {},
                    ),
                    16.verticalSpace,
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: (state.nearByList.isNotEmpty)
                            ? min(state.nearByList.length, 5)
                            : 0,
                        itemBuilder: (context, index) {
                          final item = state.nearByList[index];

                          return Padding(
                            padding: EdgeInsets.only(right: 16.w),
                            child: CommonEventCard(
                                imageUrl: item.logo ?? '',
                                date: item.startDate ?? '',
                                title: item.title ?? '',
                                location: '',
                                isFavouriteVisible: false,
                                isFavorite: false,
                                sourceId: item.sourceId ?? 3),
                          );
                        }),
                    16.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: CustomButton(
                          onPressed: () {},
                          text: AppLocalizations.of(context).all_news),
                    )
                  ],
                ),
              )
            : SizedBox.shrink();
      },
    );
  }

  _buildAllEvent(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(tourismScreenControllerProvider);
        return Column(
          children: [
            32.verticalSpace,
            Padding(
              padding: EdgeInsets.only(left: 16.w),
              child: CommonTextArrowWidget(
                text: AppLocalizations.of(context).all_events,
                onTap: () {},
              ),
            ),
            16.verticalSpace,
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: (state.allEventList.isNotEmpty)
                    ? min(state.allEventList.length, 5)
                    : 0,
                itemBuilder: (context, index) {
                  final item = state.allEventList[index];

                  return Padding(
                    padding: EdgeInsets.only(right: 16.w),
                    child: CommonEventCard(
                        imageUrl: item.logo ?? '',
                        date: item.startDate ?? '',
                        title: item.title ?? '',
                        location: '',
                        isFavouriteVisible: false,
                        isFavorite: false,
                        sourceId: item.sourceId ?? 3,
                    onTap: (){
                      ref.read(navigationProvider).navigateUsingPath(
                          path: eventDetailScreenPath,
                          context: context,
                          params: EventDetailScreenParams(
                              eventId: item.id));
                    },),
                  );
                }),
            16.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: CustomButton(
                  onPressed: () {
                    ref.read(navigationProvider).navigateUsingPath(
                        path: selectedEventListScreenPath,
                        context: context,
                        params: SelectedEventListScreenParameter(
                            listHeading:
                                AppLocalizations.of(context).all_events,
                            categoryId: ListingCategoryId.event.eventId));
                  },
                  text: AppLocalizations.of(context).all_events),
            )
          ],
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
              SizedBox(
                height: 250.h,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(borderRadius),
                      bottomLeft: Radius.circular(borderRadius)),
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: LatLng(49.5384, 7.4065),
                      onTap: (tapPosition, LatLng latLong) {
                        // onMapTap();
                      },
                      initialZoom: 13.0,
                      interactionOptions: InteractionOptions(),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                      ),
                      MarkerLayer(
                        markers: (list.isNotEmpty)
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
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
