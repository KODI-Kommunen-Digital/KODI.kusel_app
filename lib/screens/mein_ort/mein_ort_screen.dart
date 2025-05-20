import 'dart:ui';

import 'package:domain/model/response_model/mein_ort/mein_ort_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/feedback_card_widget.dart';
import 'package:kusel/common_widgets/image_text_card_widget.dart';
import 'package:kusel/navigation/navigation.dart';
import 'package:kusel/screens/all_municipality/all_municipality_provider.dart';
import 'package:kusel/screens/mein_ort/mein_ort_provider.dart';
import 'package:kusel/screens/mein_ort/mein_ort_state.dart';
import 'package:kusel/screens/municipal_party_detail/widget/municipal_detail_screen_params.dart';
import 'package:kusel/screens/ort_detail/ort_detail_screen_params.dart';

import '../../common_widgets/common_background_clipper_widget.dart';
import '../../common_widgets/common_event_card.dart';
import '../../common_widgets/custom_button_widget.dart';
import '../../common_widgets/custom_shimmer_widget.dart';
import '../../common_widgets/downstream_wave_clipper.dart';
import '../../common_widgets/highlights_card.dart';
import '../../common_widgets/image_utility.dart';
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
                _buildClipper(),
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

  Widget _buildClipper() {
    return Stack(
      children: [
        SizedBox(
          height: 155.h,
          child: CommonBackgroundClipperWidget(
            clipperType: UpstreamWaveClipper(),
            imageUrl: imagePath['background_image'] ?? "",
            height: 120.h,
            blurredBackground: true,
            isStaticImage: true,
            customWidget1: Positioned(
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
                      text: AppLocalizations.of(context).my_town),
                ],
              ),
            ),
          ),
        ),
        Positioned(top: 70, child: _buildInfoContainer(context)),
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
            text: AppLocalizations.of(context).mein_ort_display_message,
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
                        text: AppLocalizations.of(context).associated_municipalities,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.bodyLarge?.color),
                    12.horizontalSpace,
                    ImageUtil.loadSvgImage(
                        imageUrl: imagePath['arrow_icon'] ?? "",
                        height: 10.h,
                        width: 16.w,
                        context: context)
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
                  ImageUtil.loadSvgImage(
                    imageUrl: imagePath['arrow_icon'] ?? "",
                    context: context,
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
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 12.w),
                child: ImageTextCardWidget(
                  text: item.name,
                  imageUrl: item.image,
                  onTap: () {
                    ref.read(navigationProvider).navigateUsingPath(
                        path: ortDetailScreenPath,
                        context: context,
                        params:
                            OrtDetailScreenParams(ortId: item.id!.toString()));
                  },
                ),
              );
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
}
