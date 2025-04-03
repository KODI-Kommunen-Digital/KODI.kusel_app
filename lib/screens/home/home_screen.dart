import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kusel/common_widgets/upstream_wave_clipper.dart';
import 'package:kusel/common_widgets/weather_widget.dart';
import 'package:kusel/screens/home/home_screen_provider.dart';

import '../../../common_widgets/highlights_card.dart';
import '../../../images_path.dart';
import '../../common_widgets/feedback_card_widget.dart';
import '../../common_widgets/search_widget.dart';
import '../../common_widgets/text_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../theme_manager/colors.dart';

class HomeScreen extends ConsumerStatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    CarouselController carouselController = CarouselController(initialItem: 0);
    carouselController.addListener(() {
      ref
          .watch(homeScreenProvider.notifier)
          .addCarouselListener(carouselController);
    });
    List<Widget> highlightCards = [
      HighlightsCard(
        imageUrl: imagePath['highlight_card_image'] ?? "",
        date: '04.09.08',
        heading: 'Mittelatermarkt',
        description: 'Burg Lictenberg',
        isFavourite: false,
        onPress: () {},
        onFavouriteIconClick: () {},
      ),
      HighlightsCard(
        imageUrl: imagePath['highlight_card_image'] ?? "",
        date: '04.09.08',
        heading: 'Mittelatermarkt',
        description: 'Burg Lictenberg',
        isFavourite: false,
        onPress: () {},
        onFavouriteIconClick: () {},
      ),
      HighlightsCard(
        imageUrl: imagePath['highlight_card_image'] ?? "",
        date: '04.09.08',
        heading: 'Mittelatermarkt',
        description: 'Burg Lictenberg',
        isFavourite: false,
        onPress: () {},
        onFavouriteIconClick: () {},
      ),
      HighlightsCard(
        imageUrl: imagePath['highlight_card_image'] ?? "",
        date: '04.09.08',
        heading: 'Mittelatermarkt',
        description: 'Burg Lictenberg',
        isFavourite: false,
        onPress: () {},
        onFavouriteIconClick: () {},
      ),
    ];
    return Scaffold(
      backgroundColor: Color(0xFFE2EBF7),
      body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: buildUi(carouselController, highlightCards)),
    );
  }

  Widget buildUi(
      CarouselController carouselController, List<Widget> highlightCards) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Stack(
            children: [
              ClipPath(
                clipper: UpstreamWaveClipper(),
                child: Container(
                  height: 340,
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
                top: 70.h, // Adjust position to be below the clipped image
                left: 20,
                right: 20,
                child: Column(
                  children: [
                    textBoldPoppins(
                      fontSize: 20,
                      color: Color(0xFF18204F),
                      textAlign: TextAlign.center,
                      text: "Hey Lukas!",
                    ),
                    textBoldPoppins(
                      fontSize: 20,
                      color: Color(0xFF18204F),
                      textAlign: TextAlign.center,
                      text: "Heute wird's sonning!",
                    ),
                    32.verticalSpace,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: textRegularPoppins(
                              text: 'Suche',
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              color: lightThemeSecondaryColor),
                        ),
                        SearchWidget(
                          searchController: TextEditingController(),
                          hintText: "Suchbegriff eingeben",
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          customCarouselView(carouselController, highlightCards),
          SizedBox(
            height: 20,
          ),
          WeatherWidget(),
          FeedbackCardWidget(),
          SizedBox(
            height: 100,
          )
        ],
      ),
    );
  }

  Widget customCarouselView(
      CarouselController carouselController, List<Widget> highlightCards) {
    int currentIndex = ref.watch(homeScreenProvider).highlightCount;
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
                    padding: const EdgeInsets.only(left: 10.0),
                    child: textRegularPoppins(
                        text: AppLocalizations.of(context).highlights,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: lightThemeSecondaryColor),
                  ),
                  12.horizontalSpace,
                  SvgPicture.asset(
                    imagePath['arrow_icon'] ?? "",
                    height: 12,
                    width: 18,
                  )
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      highlightCards.length,
                      (index) => Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: currentIndex == index ? 11 : 8,
                            color: currentIndex == index
                                ? lightThemeHighlightDotColor
                                : lightThemeHighlightDotColor.withAlpha(130),
                          ),
                          if (index != highlightCards.length - 1)
                            4.horizontalSpace
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 350.h,
            child: CarouselView(
              controller: carouselController,
              scrollDirection: Axis.horizontal,
              itemExtent: 317,
              shrinkExtent: 317,
              padding: EdgeInsets.all(8),
              children: highlightCards ?? [],
            ),
          ),
        ],
      ),
    );
  }
}
