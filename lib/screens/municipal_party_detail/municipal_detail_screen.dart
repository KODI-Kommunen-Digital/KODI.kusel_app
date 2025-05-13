import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kusel/common_widgets/custom_button_widget.dart';
import 'package:kusel/common_widgets/downstream_wave_clipper.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/screens/events_listing/selected_event_list_screen_parameter.dart';
import 'package:kusel/screens/municipal_party_detail/widget/municipal_detail_location_widget.dart';
import 'package:kusel/screens/municipal_party_detail/widget/municipal_detail_screen_params.dart';
import 'package:kusel/screens/municipal_party_detail/widget/place_of_another_community_card.dart';
import 'package:kusel/screens/ort_detail/ort_detail_screen_params.dart';
import 'package:kusel/screens/utility/image_loader_utility.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_router.dart';
import '../../common_widgets/arrow_back_widget.dart';
import '../../common_widgets/common_event_card.dart';
import '../../common_widgets/feedback_card_widget.dart';
import '../../common_widgets/icon_text_widget_card.dart';
import '../../images_path.dart';
import '../../navigation/navigation.dart';
import '../../providers/favorites_list_notifier.dart';
import '../event/event_detail_screen_controller.dart';
import 'municipal_detail_controller.dart';

class MunicipalDetailScreen extends ConsumerStatefulWidget {
  MunicipalDetailScreenParams municipalDetailScreenParams;

  MunicipalDetailScreen({super.key, required this.municipalDetailScreenParams});

  @override
  ConsumerState<MunicipalDetailScreen> createState() =>
      _CityDetailScreenState();
}

class _CityDetailScreenState extends ConsumerState<MunicipalDetailScreen> {
  @override
  void initState() {
    Future.microtask(() {
      final id = widget.municipalDetailScreenParams.municipalId;

      ref
          .read(municipalDetailControllerProvider.notifier)
          .getMunicipalPartyDetailUsingId(id: id);
      ref
          .read(municipalDetailControllerProvider.notifier)
          .getEventsUsingCityId(municipalId: id);
      ref
          .read(municipalDetailControllerProvider.notifier)
          .getNewsUsingCityId(municipalId: id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
        municipalDetailControllerProvider.select((state) => state.isLoading));

    return SafeArea(
      child: Scaffold(
          body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(child: _buildBody(context)),
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
      )),
    );
  }

  _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildClipper(context),
          _buildDescription(context),
          32.verticalSpace,

          _buildServicesList(context),

          32.verticalSpace,
          _buildLocationCard(),
          32.verticalSpace,
          _buildPlacesOfTheCommunity(context),
          32.verticalSpace,
          if (ref.watch(municipalDetailControllerProvider).eventList.isNotEmpty)
            _buildEvents(context),
          32.verticalSpace,
          if (ref.watch(municipalDetailControllerProvider).newsList.isNotEmpty)
            _buildNews(context),
          32.verticalSpace,
          FeedbackCardWidget(
            onTap: () {
              ref.read(navigationProvider).navigateUsingPath(
                  path: feedbackScreenPath, context: context);
            },
          ),
        ],
      ),
    );
  }

  _buildClipper(context) {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(municipalDetailControllerProvider);

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
                          imagePath['city_background_image'] ?? "",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 30.h,
                    left: 15.w,
                    child: ArrowBackWidget(
                      onTap: () {
                        ref
                            .read(navigationProvider)
                            .removeTopPage(context: context);
                      },
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
                      child:
                          (state.municipalPartyDetailDataModel?.image != null)
                              ? CachedNetworkImage(
                                  imageUrl: imageLoaderUtility(
                                      image: state
                                          .municipalPartyDetailDataModel!
                                          .image!,
                                      sourceId: 1),
                                  errorWidget: (context, val, _) {
                                    return Image.asset(imagePath['crest']!);
                                  },
                                  progressIndicatorBuilder: (context, val, _) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                )
                              : Center(
                                  child: Image.asset(
                                    imagePath['crest']!,
                                    height: 120.h,
                                    width: 100.w,
                                  ),
                                ),
                    ),
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }

  _buildDescription(context) {
    return Consumer(builder: (context, ref, _) {
      final state = ref.watch(municipalDetailControllerProvider);
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textBoldPoppins(
              text: state.municipalPartyDetailDataModel?.name ??
                  'Kusel-Altenglan',
              fontSize: 18,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
            16.verticalSpace,
            textRegularMontserrat(
                maxLines: 20,
                textAlign: TextAlign.start,
                textOverflow: TextOverflow.ellipsis,
                color: Theme.of(context).textTheme.bodyLarge?.color,
                text: state.municipalPartyDetailDataModel?.description ??
                    "Die Verbandsgemeinde Kusel-Altenglan ist eine Gebietskörperschaft im Landkreis Kusel  in Rheinland-Pfalz. Sie ist zum 1. Januar 2018 aus dem freiwilligen Zusammenschluss der  Verbandsgemeinden Altenglan und Kusel entstanden. Ihr gehören die Stadt Kusel sowie 33 weitere Ortsgemeinden an, der Verwaltungssitz ist in Kusel."),
            32.verticalSpace,
            textBoldPoppins(
                text:
                    "${state.municipalPartyDetailDataModel?.name ?? ""} ${AppLocalizations.of(context).municipality}",
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 13)
          ],
        ),
      );
    });
  }

  _buildLocationCard() {
    return Consumer(builder: (context, ref, _) {
      final state = ref.watch(municipalDetailControllerProvider);

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: CityDetailLocationWidget(
          phoneNumber:
              state.municipalPartyDetailDataModel?.phone ?? '+49 6381 424-0',
          webUrl: state.municipalPartyDetailDataModel?.websiteUrl ??
              'https://google.com',
          address: state.municipalPartyDetailDataModel?.address ??
              'Trierer Str. 49-51, 66869 Kusel',
          long: (state.municipalPartyDetailDataModel?.longitude != null)
              ? double.parse(state.municipalPartyDetailDataModel!.longitude!)
              : 7.4065,
          lat: (state.municipalPartyDetailDataModel?.latitude != null)
              ? double.parse(state.municipalPartyDetailDataModel!.latitude!)
              : 49.5384,
          websiteText: 'https://www.landkreis-kusel.de/',
          calendarText:
              state.municipalPartyDetailDataModel?.openUntil ?? "16:00:00",
        ),
      );
    });
  }

  _buildPlacesOfTheCommunity(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Baseline(
                baseline: 16, // Adjust based on your text size
                baselineType: TextBaseline.alphabetic,
                child: textRegularPoppins(
                  text: AppLocalizations.of(context).places_of_the_community,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              10.horizontalSpace, // spacing between text and icon
              Baseline(
                baseline: 16,
                baselineType: TextBaseline.alphabetic,
                child: SvgPicture.asset(
                  imagePath['arrow_icon'] ?? "",
                  height: 10.h,
                  width: 16.w,
                ),
              ),
            ],
          ),
          16.verticalSpace,
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: (ref
                          .read(municipalDetailControllerProvider)
                          .cityList
                          .length >
                      5)
                  ? 5
                  : ref.read(municipalDetailControllerProvider).cityList.length,
              itemBuilder: (context, index) {
                final item =
                    ref.read(municipalDetailControllerProvider).cityList[index];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  child: PlaceOfAnotherCommunityCard(
                    onTap: () {
                      ref.read(navigationProvider).navigateUsingPath(
                          path: ortDetailScreenPath,
                          context: context,
                          params: OrtDetailScreenParams(
                              ortId: item.id!.toString()));
                    },
                    imageUrl: item.image!,
                    text: item.name ?? '',
                    isFav: false,
                    sourceId: 1,
                  ),
                );
              }),
          16.verticalSpace,
          CustomButton(
              onPressed: () {
                ref.read(navigationProvider).navigateUsingPath(
                    path: allCityScreenPath, context: context);
              },
              text: AppLocalizations.of(context).show_all_locations)
        ],
      ),
    );
  }

  _buildEvents(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Baseline(
                baseline: 16, // Adjust based on your text size
                baselineType: TextBaseline.alphabetic,
                child: textRegularPoppins(
                  text: AppLocalizations.of(context).events,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              10.horizontalSpace, // spacing between text and icon
              Visibility(
                visible: ref
                    .watch(municipalDetailControllerProvider)
                    .eventList
                    .isNotEmpty,
                child: Baseline(
                  baseline: 16,
                  baselineType: TextBaseline.alphabetic,
                  child: SvgPicture.asset(
                    imagePath['arrow_icon'] ?? "",
                    height: 10.h,
                    width: 16.w,
                  ),
                ),
              ),
            ],
          ),
        ),
        16.verticalSpace,
        Consumer(builder: (context, ref, _) {
          final state = ref.watch(municipalDetailControllerProvider);

          return (state.showEventLoading)
              ? SizedBox(
                  height: 20.h,
                  width: 20.w,
                  child: CircularProgressIndicator(),
                )
              : (state.eventList.isEmpty)
                  ? textRegularPoppins(
                      text: AppLocalizations.of(context).no_data,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.bodyLarge?.color)
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: state.eventList.length % 5,
                      itemBuilder: (context, index) {
                        final item = state.eventList[index];

                        return CommonEventCard(
                          imageUrl: item.logo ?? "",
                          date: item.startDate ?? "",
                          title: item.title ?? "",
                          location: item.address ?? "",
                          onFavorite: () {
                            // ref.read(favoritesProvider.notifier).toggleFavorite(
                            //     item, success: ({required bool isFavorite}) {
                            //   ref
                            //       .read(allEventScreenProvider.notifier)
                            //       .setIsFavorite(isFavorite, item.id);
                            // }, error: ({required String message}) {});
                          },
                          isFavorite: item.isFavorite ?? false,
                          onTap: () {
                            ref.read(navigationProvider).navigateUsingPath(
                                  context: context,
                                  path: eventScreenPath,
                                  params:
                                      EventDetailScreenParams(eventId: item.id),
                                );
                          },
                          isFavouriteVisible: ref
                              .watch(favoritesProvider.notifier)
                              .showFavoriteIcon(),
                          sourceId: item.sourceId!,
                        );
                      });
        }),
        Visibility(
          visible:
              ref.watch(municipalDetailControllerProvider).eventList.isNotEmpty,
          child: Column(
            children: [
              16.verticalSpace,
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: CustomButton(
                      icon: imagePath['calendar'] ?? "",
                      onPressed: () {
                        final categoryId = 3;
                        final municipalId = 1 ??
                            ref
                                .watch(municipalDetailControllerProvider)
                                .municipalPartyDetailDataModel
                                ?.id;

                        ref.read(navigationProvider).navigateUsingPath(
                            path: selectedEventListScreenPath,
                            context: context,
                            params: SelectedEventListScreenParameter(
                                cityId: 1,
                                listHeading:
                                    AppLocalizations.of(context).events,
                                categoryId: null));
                      },
                      text: AppLocalizations.of(context).all_events))
            ],
          ),
        )
      ],
    );
  }

  _buildNews(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Baseline(
                baseline: 16, // Adjust based on your text size
                baselineType: TextBaseline.alphabetic,
                child: textRegularPoppins(
                  text: AppLocalizations.of(context).news,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              10.horizontalSpace, // spacing between text and icon
              Visibility(
                visible: ref
                    .watch(municipalDetailControllerProvider)
                    .newsList
                    .isNotEmpty,
                child: Baseline(
                  baseline: 16,
                  baselineType: TextBaseline.alphabetic,
                  child: SvgPicture.asset(
                    imagePath['arrow_icon'] ?? "",
                    height: 10.h,
                    width: 16.w,
                  ),
                ),
              ),
            ],
          ),
        ),
        16.verticalSpace,
        Consumer(builder: (context, ref, _) {
          final state = ref.watch(municipalDetailControllerProvider);

          return (state.showNewsLoading)
              ? SizedBox(
                  height: 20.h,
                  width: 20.w,
                  child: CircularProgressIndicator(),
                )
              : (state.newsList.isEmpty)
                  ? textRegularPoppins(
                      text: AppLocalizations.of(context).no_data,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.bodyLarge?.color)
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: state.newsList.length % 5,
                      itemBuilder: (context, index) {
                        final item = state.newsList[index];

                        return CommonEventCard(
                          imageUrl: item.logo ?? "",
                          date: item.startDate ?? "",
                          title: item.title ?? "",
                          location: item.address ?? "",
                          onFavorite: () {
                            // ref.read(favoritesProvider.notifier).toggleFavorite(
                            //     item, success: ({required bool isFavorite}) {
                            //   ref
                            //       .read(allEventScreenProvider.notifier)
                            //       .setIsFavorite(isFavorite, item.id);
                            // }, error: ({required String message}) {});
                          },
                          isFavorite: item.isFavorite ?? false,
                          onTap: () {
                            ref.read(navigationProvider).navigateUsingPath(
                                  context: context,
                                  path: eventScreenPath,
                                  params:
                                      EventDetailScreenParams(eventId: item.id),
                                );
                          },
                          isFavouriteVisible: ref
                              .watch(favoritesProvider.notifier)
                              .showFavoriteIcon(),
                          sourceId: item.sourceId!,
                        );
                      });
        }),
        Visibility(
          visible:
              ref.watch(municipalDetailControllerProvider).newsList.isNotEmpty,
          child: Column(
            children: [
              16.verticalSpace,
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: CustomButton(
                      onPressed: () {
                        final categoryId = 1;
                        final municipalId = ref
                            .watch(municipalDetailControllerProvider)
                            .municipalPartyDetailDataModel
                            ?.id;

                        ref.read(navigationProvider).navigateUsingPath(
                            path: selectedEventListScreenPath,
                            context: context,
                            params: SelectedEventListScreenParameter(
                                cityId: 1,
                                listHeading: AppLocalizations.of(context).news,
                                categoryId: null));
                      },
                      text: AppLocalizations.of(context).all_news))
            ],
          ),
        )
      ],
    );
  }

  Widget _buildServicesList(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(municipalDetailControllerProvider);

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount:
                    state.municipalPartyDetailDataModel?.onlineServices?.length ?? 0,
                itemBuilder: (context, index) {
                  if(state.municipalPartyDetailDataModel?.onlineServices!=null)
                    {
                      final item = state
                          .municipalPartyDetailDataModel!.onlineServices![index];
                      return _customTextIconCard(
                          onTap: () async {
                            final Uri uri = Uri.parse(
                                item.linkUrl ?? "https://www.landkreis-kusel.de");
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                            }
                          },
                          imageUrl: item.iconUrl!, //??item.iconUrl
                          text: item.title ?? '',
                          description: item.description ?? '');
                    }else{
                    return SizedBox.shrink();
                  }

                },
              ),
            ],
          ),
        );
      },
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
                  CachedNetworkImage(
                    height: 35.h,
                    width: 35.w,
                    progressIndicatorBuilder: (context, value, _) => Center(
                      child: CircularProgressIndicator(),
                    ),
                    imageUrl: imageLoaderUtility(image: imageUrl, sourceId: 3),
                    errorWidget: (context, error, stackTrace) =>
                        Icon(Icons.broken_image, size: 40.w.h),
                    fit: BoxFit.cover,
                  ),
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
                  child:
                  Image.asset(imagePath["link_icon"] ?? '',
                    height: 40.h,
                    width: 40.w,)),
            ],
          ),
        ),
      ),
    );
  }
}
