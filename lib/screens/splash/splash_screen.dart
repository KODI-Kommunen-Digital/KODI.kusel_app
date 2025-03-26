import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/common_widgets/common_event_card.dart';

import '../../common_widgets/text_styles.dart';
import '../../locale/localization_manager.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _State();
}

class _State extends ConsumerState<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: InkWell(
        onTap: () {
          ref
              .read(localeManagerProvider.notifier)
              .updateCurrentSelectedLocale(Locale('de'));
        },
        child:
        Column(
          children: [
            CommonEventCard(
              imageUrl: 'https://fastly.picsum.photos/id/452/200/200.jpg?hmac=f5vORXpRW2GF7jaYrCkzX3EwDowO7OXgUaVYM2NNRXY',
              date: '04.09.2024',
              title: 'Mittelaltermarkt',
              location: 'Burg Lichtenberg',
              onTap: () {
                print("Card tapped");
              },
              onFavorite: () {
                print("Favorite tapped");
              },
            ),
          ],
        ),
          )),
    );
  }
}
