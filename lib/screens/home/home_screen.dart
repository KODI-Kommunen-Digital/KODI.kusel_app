import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kusel/common_widgets/weather_widget.dart';
import 'package:kusel/screens/home/home_screen_provider.dart';

import '../../../common_widgets/highlights_card.dart';
import '../../../images_path.dart';
import '../../common_widgets/text_styles.dart';

class HomeScreen extends ConsumerStatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    CarouselController carouselController = CarouselController(initialItem: 0);
    carouselController.addListener((){
      ref.watch(homeScreenProvider.notifier).addCarouselListener(carouselController);

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
      body: Container(
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
          customCarouselView(carouselController, highlightCards),
          SizedBox(height: 20,),
          WeatherWidget()
        ],
      ),
    );
  }

  Widget customCarouselView(
      CarouselController carouselController, List<Widget> highlightCards) {
    int currentIndex = ref.watch(homeScreenProvider).highlightCount;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: textRegularPoppins(
                        text: "Highlights",
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF18204F)),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  SvgPicture.asset(
                    imagePath['arrow_icon'] ?? "", // Add a fallback if the path is null
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
                                ? Color(0xFF283583)
                                : Color(0xFF6972A8).withAlpha(130),
                          ),
                          if (index !=
                              highlightCards.length -
                                  1)
                            const SizedBox(width: 4),
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
            height: 418,
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
