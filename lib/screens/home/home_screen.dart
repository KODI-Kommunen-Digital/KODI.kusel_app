import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kusel/common_widgets/custom_button_widget.dart';
import 'package:kusel/common_widgets/highlights_card.dart';
import 'package:kusel/common_widgets/upstream_wave_clipper.dart';
import 'package:kusel/common_widgets/weather_widget.dart';
import 'package:kusel/screens/home/home_screen_provider.dart';
import 'package:kusel/screens/home/home_screen_state.dart';

import '../../../images_path.dart';
import '../../app_router.dart';
import '../../common_widgets/common_event_card.dart';
import '../../common_widgets/feedback_card_widget.dart';
import '../../common_widgets/search_widget.dart';
import '../../common_widgets/text_styles.dart';
import '../../navigation/navigation.dart';
import '../events_listing/event_list_screen_parameter.dart';

class HomeScreen extends ConsumerStatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(homeScreenProvider.notifier).getLoginStatus();
    });
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeScreenProvider.notifier).getUserDetails();
      ref.read(homeScreenProvider.notifier).getHighlights();
      ref.read(homeScreenProvider.notifier).getEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    CarouselController carouselController = CarouselController(initialItem: 0);
    carouselController.addListener(() {
      ref
          .watch(homeScreenProvider.notifier)
          .addCarouselListener(carouselController);
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: buildUi(carouselController)),
    );
  }

  Widget buildUi(CarouselController carouselController) {
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
                ClipPath(
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
                      textBoldPoppins(
                        fontSize: 20,
                        color: Theme.of(context).textTheme.labelLarge?.color,
                        textAlign: TextAlign.center,
                        text: ref.watch(homeScreenProvider).userName,
                      ),
                      textBoldPoppins(
                        fontSize: 20,
                        color: Theme.of(context).textTheme.labelLarge?.color,
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
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Visibility(
                  visible: ref.watch(homeScreenProvider).isSignupButtonVisible,
                    child: Positioned(
                        left: 210.w,
                        top: 30.h,
                        child: GestureDetector(
                          onTap: () {
                            ref.read(navigationProvider).navigateUsingPath(
                                context: context, path: signInScreenPath);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.r),
                                border: Border.all(
                                    width: 2.w,
                                    color: Theme.of(context).primaryColor)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 5.h),
                            child: textBoldPoppins(
                                text:
                                    AppLocalizations.of(context).log_in_sign_up,
                                fontSize: 12.sp,
                                color: Theme.of(context).primaryColor),
                          ),
                        )))
              ],
            ),
            customCarouselView(carouselController),
            20.verticalSpace,
            WeatherWidget(),
            eventsView(),
            FeedbackCardWidget(),
            100.verticalSpace
          ],
        ),
      ),
    );
  }

  Widget eventsView() {
    HomeScreenState state = ref.watch(homeScreenProvider);
    if (state.eventsList.isNotEmpty) {
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
                        centerLatitude: 49.53838,
                        centerLongitude: 7.40647,
                        categoryId: 3,
                        listHeading: AppLocalizations.of(context).all_events));
              },
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: textRegularPoppins(
                        text: AppLocalizations.of(context).events,
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
            itemCount:
                state.eventsList.length > 3 ? 3 : state.eventsList.length,
            itemBuilder: (context, index) {
              final item = state.eventsList[index];
              return CommonEventCard(
                imageUrl:
                    "https://fastly.picsum.photos/id/452/200/200.jpg?hmac=f5vORXpRW2GF7jaYrCkzX3EwDowO7OXgUaVYM2NNRXY",
                date: item.startDate ?? "",
                title: item.title ?? "",
                location: item.address ?? "",
                onTap: () {
                  ref.read(navigationProvider).navigateUsingPath(
                      context: context, path: eventScreenPath, params: item);
                },
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                        listHeading: AppLocalizations.of(context).all_events));
              },
              text: AppLocalizations.of(context).all_events,
              icon: imagePath['calendar'] ?? "",
            ),
          ),
          20.verticalSpace
        ],
      );
    }
    return Container();
  }

  Widget customCarouselView(CarouselController carouselController) {
    HomeScreenState state = ref.watch(homeScreenProvider);
    int currentIndex = state.highlightCount;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Column(
        children: [
          40.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: textRegularPoppins(
                        text: AppLocalizations.of(context).highlights,
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
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 5.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      state.highlightsList.length,
                      (index) => InkWell(
                        onTap: () {
                          ref.read(navigationProvider).navigateUsingPath(
                              context: context, path: eventScreenPath);
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
              ),
            ],
          ),
          10.verticalSpace,
          SizedBox(
            height: 350.h,
            child: CarouselView(
              controller: carouselController,
              onTap: (index) {
                ref.read(navigationProvider).navigateUsingPath(
                    context: context,
                    path: eventScreenPath,
                    params: state.highlightsList[index]);
              },
              scrollDirection: Axis.horizontal,
              itemExtent: 317,
              shrinkExtent: 317,
              padding: EdgeInsets.all(6.h.w),
              children: state.highlightsList.map((listing) {
                return HighlightsCard(
                  imageUrl: imagePath['highlight_card_image'] ?? '',
                  // need to be fixed
                  date: listing.createdAt ?? "",
                  heading: listing.title ?? "",
                  description: listing.description ?? "",
                  isFavourite: false,
                  onPress: () {},
                  onFavouriteIconClick: () {},
                  isVisible: !ref.read(homeScreenProvider).isSignupButtonVisible,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
