import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/common_event_card.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/common_widgets/upstream_wave_clipper.dart';
import 'package:kusel/navigation/navigation.dart';
import 'package:kusel/screens/category/category_screen_controller.dart';
import 'package:kusel/screens/category/category_screen_state.dart';
import 'package:kusel/screens/events_listing/event_list_screen_controller.dart';
import 'package:kusel/screens/sub_category/sub_category_screen_parameter.dart';

import '../../common_widgets/category_grid_card_view.dart';
import '../../images_path.dart';
import 'event_list_screen_state.dart';

class EventListScreen extends ConsumerStatefulWidget {
  const EventListScreen({super.key});

  @override
  ConsumerState<EventListScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<EventListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(eventListScreenProvider.notifier).getEventsList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final EventListScreenState categoryScreenState =
        ref.watch(eventListScreenProvider);
    return SafeArea(
      child: Scaffold(
        body: _buildBody(categoryScreenState, context),
      ).loaderDialog(context, categoryScreenState.loading),
    );
  }

  _buildBody(EventListScreenState categoryScreenState, BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image at the top
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
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 0),
                child: Container(
                  color: Theme.of(context).cardColor.withValues(alpha: 0.6),
                ),
              ),
            ),

            Positioned(
              left: 16.r,
              top: 24.h,
              child: textBoldPoppins(
                  text: AppLocalizations.of(context).category_heading),
            ),

            Positioned.fill(
                top: MediaQuery.of(context).size.height * .10,
                child: categoryView(categoryScreenState, context))
          ],
        ),
      ),
    );
  }

  categoryView(EventListScreenState eventListState, BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        // final item = eventListState.eventsList[index];
        return CommonEventCard(
            imageUrl:"https://fastly.picsum.photos/id/452/200/200.jpg?hmac=f5vORXpRW2GF7jaYrCkzX3EwDowO7OXgUaVYM2NNRXY" ,
            date: "12-April-2024",
            title: "Europäischer Bauernmarkt",
            location: "Konken",
        onTap: (){
          ref.read(navigationProvider).navigateUsingPath(
            context: context,
            path: eventScreenPath,
          );
        },);
      },
    );
  }
}
