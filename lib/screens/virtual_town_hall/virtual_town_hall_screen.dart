import 'dart:ui';

import 'package:domain/model/response_model/virtual_town_hall/virtual_town_hall_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/downstream_wave_clipper.dart';
import 'package:kusel/common_widgets/feedback_card_widget.dart';
import 'package:kusel/common_widgets/image_utility.dart';
import 'package:kusel/common_widgets/network_image_text_service_card.dart';
import 'package:kusel/common_widgets/town_hall_map_widget.dart';
import 'package:kusel/navigation/navigation.dart';
import 'package:kusel/screens/municipal_party_detail/widget/municipal_detail_screen_params.dart';
import 'package:kusel/screens/virtual_town_hall/virtual_town_hall_provider.dart';
import 'package:kusel/screens/virtual_town_hall/virtual_town_hall_state.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common_widgets/common_background_clipper_widget.dart';
import '../../common_widgets/common_event_card.dart';
import '../../common_widgets/event_list_section_widget.dart';
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
            backgroundColor: Theme.of(context).colorScheme.onSecondary,
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
          _buildClipper(),
          _buildTownHallDetailsUi(state),
          _buildServicesList(onlineServicesList: state.onlineServiceList ?? []),
          _customPageViewer(municipalityList: state.municipalitiesList ?? []),
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
                        categoryId: null));
              },
              eventCardBuilder: (item) => CommonEventCard(
                isFavorite: item.isFavorite ?? false,
                onFavorite: () {},
                imageUrl: item.logo ?? "",
                date: item.startDate ?? "",
                title: item.title ?? "",
                location: item.address ?? "",
                onCardTap: () {},
                isFavouriteVisible: false,
                sourceId: item.sourceId!,
              ),
              onHeadingTap: () {
                ref.read(navigationProvider).navigateUsingPath(
                    path: selectedEventListScreenPath,
                    context: context,
                    params: SelectedEventListScreenParameter(
                        cityId: 1,
                        listHeading: AppLocalizations.of(context).news,
                        categoryId: null));
              },
            ),
          if (state.eventList != null && state.eventList!.isNotEmpty)
            EventsListSectionWidget(
              context: context,
              eventsList: state.eventList ?? [],
              heading: AppLocalizations.of(context).current_events,
              maxListLimit: 5,
              buttonText: AppLocalizations.of(context).all_events,
              buttonIconPath: imagePath['calendar'] ?? "",
              isLoading: false,
              onButtonTap: () {
                ref.read(navigationProvider).navigateUsingPath(
                    path: selectedEventListScreenPath,
                    context: context,
                    params: SelectedEventListScreenParameter(
                        cityId: 1,
                        listHeading: AppLocalizations.of(context).news,
                        categoryId: null));
              },
              eventCardBuilder: (item) => CommonEventCard(
              isFavorite: item.isFavorite ?? false,
              onFavorite: () {},
              imageUrl: item.logo ?? "",
              date: item.startDate ?? "",
              title: item.title ?? "",
              location: item.address ?? "",
              onCardTap: () {},
              isFavouriteVisible: false,
              sourceId: item.sourceId!,
            ),
            onHeadingTap: () {
              ref.read(navigationProvider).navigateUsingPath(
                  path: selectedEventListScreenPath,
                  context: context,
                  params: SelectedEventListScreenParameter(
                      cityId: 1,
                      listHeading: AppLocalizations.of(context).events,
                      categoryId: null)
              );
            },
          ),
          FeedbackCardWidget(
              height: 270.h,
              onTap: () {
            ref
                .read(navigationProvider)
                .navigateUsingPath(path: feedbackScreenPath, context: context);
          })
        ],
      ),
    );
  }

  Widget _buildClipper() {
    final imageUrl = ref.watch(virtualTownHallProvider).imageUrl;
    return Stack(
      children: [
        SizedBox(
          height: 250.h,
          child: CommonBackgroundClipperWidget(
            clipperType: DownstreamCurveClipper(),
            imageUrl: imagePath['background_image'] ?? "",
            height: 210.h,
            blurredBackground: true,
            isStaticImage: true,
            customWidget1:                 Positioned(
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
          ),
        ),
        Positioned(
          top: 120.h,
          left: 0.w,
          right: 0.w,
          child: Container(
            height: 120.h,
            width: 70.w,
            padding: EdgeInsets.all(25.w),
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Colors.white),
            child: ImageUtil.loadNetworkImage(
              imageUrl:
              imageUrl ?? '',
              sourceId: 1,
              svgErrorImagePath: imagePath['virtual_town_hall_map_image']!,
              context: context,
            ),
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
              return NetworkImageTextServiceCard(
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
                        text: AppLocalizations.of(context).associated_municipalities,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.bodyLarge?.color),
                    12.horizontalSpace,
                    ImageUtil.loadSvgImage(
                      imageUrl : imagePath['arrow_icon'] ?? "",
                      context: context,
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
                    isVisible: false,
                    sourceId: 1,
                    imageFit: BoxFit.contain,
                  ),
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

}
