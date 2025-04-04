import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kusel/common_widgets/highlights_card.dart';
import 'package:kusel/common_widgets/upstream_wave_clipper.dart';
import 'package:kusel/common_widgets/weather_widget.dart';
import 'package:kusel/screens/home/home_screen_provider.dart';
import 'package:kusel/screens/home/home_screen_state.dart';

import '../../../images_path.dart';
import '../../app_router.dart';
import '../../common_widgets/category_grid_card_view.dart';
import '../../common_widgets/feedback_card_widget.dart';
import '../../common_widgets/search_widget.dart';
import '../../common_widgets/text_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../navigation/navigation.dart';
import '../../theme_manager/colors.dart';

class HomeScreen extends ConsumerStatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeScreenProvider.notifier).getHighlights();
      ref.read(homeScreenProvider.notifier).getEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    HomeScreenState state = ref.watch(homeScreenProvider);
    CarouselController carouselController = CarouselController(initialItem: 0);
    carouselController.addListener(() {
      ref
          .watch(homeScreenProvider.notifier)
          .addCarouselListener(carouselController);
    });

    return Scaffold(
      backgroundColor: lightThemeScaffoldBackgroundColor,
      body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: buildUi(carouselController)),
    );
  }

  Widget buildUi(CarouselController carouselController) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Stack(
            children: [
              ClipPath(
                clipper: UpstreamWaveClipper(),
                child: Container(
                  height: 272.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage(imagePath['home_screen_background'] ?? ''),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 70.h,
                left: 20.w,
                right: 20.w,
                child: Column(
                  children: [
                    textBoldPoppins(
                      fontSize: 20,
                      color: lightThemeSecondaryColor,
                      textAlign: TextAlign.center,
                      text: "Hey Lukas!",
                    ),
                    textBoldPoppins(
                      fontSize: 20,
                      color: lightThemeSecondaryColor,
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
                              color: lightThemeSecondaryColor),
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
            ],
          ),
          customCarouselView(carouselController),
          20.verticalSpace,
          WeatherWidget(),
          FeedbackCardWidget(),
          100.verticalSpace
        ],
      ),
    );
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
                        color: lightThemeSecondaryColor),
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
                                  ? lightThemeHighlightDotColor
                                  : lightThemeHighlightDotColor.withAlpha(130),
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
                ref
                    .read(navigationProvider)
                    .navigateUsingPath(context: context, path: eventScreenPath);
              },
              scrollDirection: Axis.horizontal,
              itemExtent: 317,
              shrinkExtent: 317,
              padding: EdgeInsets.all(6.h.w),
              children: state.highlightsList.map((listing) {
                return HighlightsCard(
                    imageUrl: imagePath['highlight_card_image'] ?? '', // need to be fixed
                    date: listing.startDate ?? "",
                    heading: listing.title ?? "",
                    description: listing.description ?? "",
                    isFavourite: false,
                    onPress: (){},
                    onFavouriteIconClick: (){});
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
