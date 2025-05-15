import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:domain/model/response_model/virtual_town_hall/virtual_town_hall_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/downstream_wave_clipper.dart';
import 'package:kusel/common_widgets/feedback_card_widget.dart';
import 'package:kusel/common_widgets/image_utility.dart';
import 'package:kusel/common_widgets/town_hall_map_widget.dart';
import 'package:kusel/navigation/navigation.dart';
import 'package:kusel/screens/municipal_party_detail/widget/municipal_detail_screen_params.dart';
import 'package:kusel/screens/utility/image_loader_utility.dart';
import 'package:kusel/screens/virtual_town_hall/virtual_town_hall_provider.dart';
import 'package:kusel/screens/virtual_town_hall/virtual_town_hall_state.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common_widgets/common_event_card.dart';
import '../../common_widgets/custom_button_widget.dart';
import '../../common_widgets/custom_shimmer_widget.dart';
import '../../common_widgets/highlights_card.dart';
import '../../common_widgets/text_styles.dart';
import '../../common_widgets/upstream_wave_clipper.dart';
import '../../images_path.dart';
import '../events_listing/selected_event_list_screen_parameter.dart';

class VirtualTownHallScreen extends ConsumerStatefulWidget {
  const VirtualTownHallScreen({super.key});

  @override
  ConsumerState<VirtualTownHallScreen> createState() =>
      _VirtualTownHallScreenState();
}

class _VirtualTownHallScreenState extends ConsumerState<VirtualTownHallScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(virtualTownHallProvider.notifier).getVirtualTownHallDetails();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        ref.watch(virtualTownHallProvider.select((state) => state.loading));

    return SafeArea(
        child: Scaffold(
            body: Stack(
      children: [
        _buildBody(context),
        if (isLoading)
          Center(
              child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
            ),
            height: 100.h,
            width: 100.w,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )),
      ],
    )));
  }

  Widget _buildBody(BuildContext context) {
    final state = ref.read(virtualTownHallProvider);
    final isLoading = ref.watch(virtualTownHallProvider).loading;
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildClipper(context),
          _buildTownHallDetailsUi(state),
          _buildServicesList(onlineServicesList: state.onlineServiceList ?? []),
          _customPageViewer(municipalityList: state.municipalitiesList ?? []),
          if (state.newsList != null && state.newsList!.isNotEmpty)
            eventsView(
                state.newsList ?? [],
                AppLocalizations.of(context).news,
                5,
                AppLocalizations.of(context).all_news,
                imagePath['calendar'] ?? "",
                isLoading,
                0,
                0, () {
              ref.read(navigationProvider).navigateUsingPath(
                  path: selectedEventListScreenPath,
                  context: context,
                  params: SelectedEventListScreenParameter(
                      cityId: 1,
                      listHeading: AppLocalizations.of(context).news,
                      categoryId: null));
            }),
          if (state.eventList != null && state.eventList!.isNotEmpty)
            eventsView(
                state.eventList ?? [],
                AppLocalizations.of(context).event_text,
                5,
                AppLocalizations.of(context).all_events,
                imagePath['calendar'] ?? "",
                isLoading,
                0,
                0, () {
              ref.read(navigationProvider).navigateUsingPath(
                  path: selectedEventListScreenPath,
                  context: context,
                  params: SelectedEventListScreenParameter(
                      cityId: 1,
                      listHeading: AppLocalizations.of(context).events,
                      categoryId: null));
            }),
          FeedbackCardWidget(onTap: () {
            ref
                .read(navigationProvider)
                .navigateUsingPath(path: feedbackScreenPath, context: context);
          })
        ],
      ),
    );
  }

  Widget _buildClipper(context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.35,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image at the top
              Positioned(
                top: 0.h,
                child: ClipPath(
                  clipper: DownstreamCurveClipper(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * .3,
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset(
                      imagePath['background_image'] ?? "",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              // Blurred overlay
              Positioned(
                top: 0.h,
                child: ClipPath(
                  clipper: UpstreamWaveClipper(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * .3,
                    width: MediaQuery.of(context).size.width,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 0),
                      child: Container(
                        color:
                            Theme.of(context).cardColor.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0.r,
                top: 15.h,
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          ref
                              .read(navigationProvider)
                              .removeTopPage(context: context);
                        },
                        icon: Icon(Icons.arrow_back)),
                    16.horizontalSpace,
                    textBoldPoppins(
                        color: Theme.of(context).textTheme.labelLarge?.color,
                        fontSize: 18,
                        text: AppLocalizations.of(context).virtual_town_hall),
                  ],
                ),
              ),

              Positioned(
                top: MediaQuery.of(context).size.height * .15,
                left: 0.w,
                right: 0.w,
                child: Card(
                  color: Colors.red,
                  shape: const CircleBorder(),
                  elevation: 10,
                  child: Container(
                    height: 115.h,
                    width: 115.w,
                    padding: EdgeInsets.all(5.h.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).canvasColor,
                    ),
                    child: FittedBox(
                        fit: BoxFit.contain,
                        child: Image.asset(imagePath['map_image'] ?? "",
                            height: 20.h, width: 15.w)),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildTownHallDetailsUi(VirtualTownHallState state) {
    return Padding(
      padding: EdgeInsets.all(12.h.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textBoldPoppins(
              text: state.cityName ?? "",
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontSize: 16),
          15.verticalSpace,
          TownHallMapWidget(
            address: state.address ?? "",
            websiteText: AppLocalizations.of(context).visit_website,
            websiteUrl: state.websiteUrl ?? "www.google.com",
            latitude: state.latitude ?? 49.53603477650214,
            longitude: state.longitude ?? 7.392734870386151,
            phoneNumber: state.phoneNumber ?? '',
            email: state.email ?? '',
            calendarText: 'Geöffnet',
          ),
        ],
      ),
    );
  }

  Widget _buildServicesList({required List<OnlineService> onlineServicesList}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: onlineServicesList.length,
            itemBuilder: (context, index) {
              final item = onlineServicesList[index];
              return _customTextIconCard(
                  onTap: () async {
                    final Uri uri = Uri.parse(
                        item.linkUrl ?? "https://www.landkreis-kusel.de");
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    }
                  },
                  imageUrl: item.iconUrl!,
                  text: item.title ?? '',
                  description: item.description ?? '');
            },
          ),
        ],
      ),
    );
  }

  Widget _customPageViewer({required List<Municipality> municipalityList}) {
    VirtualTownHallState state = ref.watch(virtualTownHallProvider);
    int currentIndex = state.highlightCount;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Column(
        children: [
          20.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    textRegularPoppins(
                        text: AppLocalizations.of(context).our_communities,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.bodyLarge?.color),
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
                      municipalityList.length,
                      (index) => InkWell(
                        onTap: () {
                          // ref.read(navigationProvider).navigateUsingPath(
                          //     context: context,
                          //     path: eventScreenPath,
                          //     params: EventDetailScreenParams(
                          //         eventId:
                          //         state.highlightsList[index].id));
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
                            // if (index != state.highlightsList.length - 1)
                            if (index != municipalityList.length - 1)
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
            height: 315.h,
            child: PageView.builder(
              controller: PageController(
                  viewportFraction: 317.w / MediaQuery.of(context).size.width),
              scrollDirection: Axis.horizontal,
              padEnds: false,
              itemCount: municipalityList.length,
              itemBuilder: (context, index) {
                final municipalities = municipalityList[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.h.w),
                  child: HighlightsCard(
                    imageUrl:
                        municipalities.mapImage ?? "https://picsum.photos/200",
                    date: municipalities.createdAt ?? "",
                    heading: municipalities.name ?? "",
                    description: municipalities.description ?? "",
                    isFavourite: false,
                    errorImagePath: imagePath['kusel_map_image'],
                    onPress: () {
                      ref.read(navigationProvider).navigateUsingPath(
                            context: context,
                            path: municipalDetailScreenPath,
                            params: MunicipalDetailScreenParams(
                                municipalId: municipalities.id!.toString()),
                          );
                    },
                    onFavouriteIconClick: () {},
                    // isVisible:
                    // !ref.watch(homeScreenProvider).isSignupButtonVisible,
                    isVisible: false,
                    sourceId: 1,
                  ),
                  // TODO: need to change source id
                );
              },
              onPageChanged: (index) {
                ref
                    .read(virtualTownHallProvider.notifier)
                    .updateCardIndex(index);
              },
            ),
          ),
        ],
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
      double? longitude,
      void Function() onPress) {
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
                    path: selectedEventListScreenPath,
                    context: context,
                    params: SelectedEventListScreenParameter(
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
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.bodyLarge?.color),
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
                  // ref.watch(favoritesProvider.notifier).toggleFavorite(item,
                  //     success: ({required bool isFavorite}) {
                  //       ref
                  //           .read(homeScreenProvider.notifier)
                  //           .setIsFavoriteEvent(isFavorite, item.id);
                  //     }, error: ({required String message}) {
                  //       showErrorToast(message: message, context: context);
                  //     });
                },
                imageUrl: item.logo ?? "",
                date: item.startDate ?? "",
                title: item.title ?? "",
                location: item.address ?? "",
                onTap: () {
                  // ref.read(navigationProvider).navigateUsingPath(
                  //     context: context,
                  //     path: eventScreenPath,
                  //     params: EventDetailScreenParams(eventId: item.id));
                },
                // isFavouriteVisible:
                // ref.watch(favoritesProvider.notifier).showFavoriteIcon(),
                isFavouriteVisible: false,
                sourceId: item.sourceId!,
              );
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: CustomButton(
                onPressed: onPress, text: buttonText, icon: buttonIconPath),
          ),
          15.verticalSpace
        ],
      );
    }
    return Padding(
      padding: EdgeInsets.only(left: 16.w),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: textRegularPoppins(
                text: heading,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge?.color),
          ),
          16.verticalSpace,
          textRegularPoppins(
              text: AppLocalizations.of(context).no_data,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyLarge?.color),
          20.verticalSpace
        ],
      ),
    );
  }

  Widget _customTextIconCard(
      {required Function() onTap,
      required String imageUrl,
      required String text,
      String? description}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding:
              EdgeInsets.only(left: 2.w, right: 14.w, top: 20.h, bottom: 20.h),
          decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.circular(15.r)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  20.horizontalSpace,
                  ImageUtil.loadNetworkImage(
                      height: 35.h,
                      width: 35.w,
                      imageUrl: imageLoaderUtility(image: imageUrl, sourceId: 3),
                      context: context),
                  10.horizontalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textBoldMontserrat(
                          text: text,
                          color: Theme.of(context).textTheme.bodyLarge?.color),
                      if (description != null)
                        textRegularMontserrat(
                            text: description ?? '',
                            fontSize: 11,
                            textOverflow: TextOverflow.visible,
                            textAlign: TextAlign.start)
                    ],
                  ),
                ],
              ),
              Align(
                  alignment: Alignment.centerRight,
                  child: Image.asset(
                    imagePath["link_icon"] ?? '',
                    height: 40.h,
                    width: 40.w,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
