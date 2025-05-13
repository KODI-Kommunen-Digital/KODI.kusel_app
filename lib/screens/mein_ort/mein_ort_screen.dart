import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:domain/model/response_model/mein_ort/mein_ort_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/feedback_card_widget.dart';
import 'package:kusel/navigation/navigation.dart';
import 'package:kusel/screens/all_municipality/all_municipality_provider.dart';
import 'package:kusel/screens/mein_ort/mein_ort_provider.dart';
import 'package:kusel/screens/mein_ort/mein_ort_state.dart';
import 'package:kusel/screens/municipal_party_detail/widget/municipal_detail_screen_params.dart';
import '../../common_widgets/common_event_card.dart';
import '../../common_widgets/custom_button_widget.dart';
import '../../common_widgets/custom_shimmer_widget.dart';
import '../../common_widgets/highlights_card.dart';
import '../../common_widgets/text_styles.dart';
import '../../common_widgets/upstream_wave_clipper.dart';
import '../../images_path.dart';

class MeinOrtScreen extends ConsumerStatefulWidget {
  const MeinOrtScreen({super.key});

  @override
  ConsumerState<MeinOrtScreen> createState() => _MeinOrtScreenState();
}

class _MeinOrtScreenState extends ConsumerState<MeinOrtScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(meinOrtProvider.notifier).getMeinOrtDetails();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        ref.watch(meinOrtProvider.select((state) => state.isLoading));

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
    final state = ref.read(meinOrtProvider);
    final isLoading = ref.watch(meinOrtProvider).isLoading;
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 155.h,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                _buildClipper(context),
                Positioned(top: 70, child: _buildInfoContainer(context)),
              ],
            ),
          ),
          _customPageViewer(municipalityList: state.municipalityList ?? []),
          ListView.builder(
              itemCount: state.municipalityList.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final item = state.municipalityList[index];
                return eventsView(
                    item.topFiveCities ?? [],
                    item.name ?? '',
                    5,
                    AppLocalizations.of(context).show_all_places,
                    imagePath['calendar'] ?? "",
                    isLoading,
                    0,
                    0, () {
                  ref.read(navigationProvider).navigateUsingPath(
                      path: allMunicipalityScreenPath,
                      context: context,
                      params: MunicipalityScreenParams(
                          municipalityId: item.id ?? 0));
                });
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
          height: MediaQuery.of(context).size.height * 0.15,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: 0.h,
                child: ClipPath(
                  clipper: UpstreamWaveClipper(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * .15,
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
                        text: AppLocalizations.of(context).my_place),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildInfoContainer(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 15.w),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width - 24.h * 2 + 12.h,
          padding: EdgeInsets.all(8.h), // Uniform padding
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: textRegularPoppins(
            text:
            AppLocalizations.of(context).mein_ort_display_message,
            textOverflow: TextOverflow.visible,
            fontSize: 13,
            textAlign: TextAlign.start,
          ),
        ),
      ),
    );
  }

  Widget _customPageViewer({required List<Municipality> municipalityList}) {
    MeinOrtState state = ref.watch(meinOrtProvider);
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
                        municipalities.image ?? "https://picsum.photos/200",
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
                  ),
                );
              },
              onPageChanged: (index) {
                ref.read(meinOrtProvider.notifier).updateCardIndex(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget eventsView(
      List<City> eventsList,
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
                // ref.read(navigationProvider).navigateUsingPath(
                //     path: selectedEventListScreenPath,
                //     context: context,
                //     params: SelectedEventListScreenParameter(
                //         radius: 1,
                //         centerLatitude: latitude,
                //         centerLongitude: longitude,
                //         categoryId: 3,
                //         listHeading: heading));
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
              return _buildImageTextCard(item.name, item.image);
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: CustomButton(
              onPressed: onPress,
              text: buttonText,
            ),
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

  _buildImageTextCard(String? text, String? imageUrl) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(8.h.w),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                errorWidget: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 80),
                width: 80,
                height: 80,
                progressIndicatorBuilder: (context, value, _) {
                  return Center(child: CircularProgressIndicator());
                },
                fit: BoxFit.fill,
                imageUrl: imageUrl ??
                    'https://images.unsplash.com/photo-1584713503693-bb386ec95cf2?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              ),
            ),
            SizedBox(width: 30.w),
            // Texts
            textRegularMontserrat(text: text ?? ''),
          ],
        ),
      ),
    );
  }
}
