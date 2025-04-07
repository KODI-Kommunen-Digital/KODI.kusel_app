import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/common_event_card.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/common_widgets/upstream_wave_clipper.dart';
import 'package:kusel/navigation/navigation.dart';
import 'package:kusel/screens/events_listing/event_list_screen_controller.dart';

import '../../common_widgets/arrow_back_widget.dart';
import '../../images_path.dart';
import '../../theme_manager/colors.dart';
import 'event_list_screen_paramaters.dart';
import 'event_list_screen_state.dart';

class EventListScreen extends ConsumerStatefulWidget {
  final EventListScreenParameters eventListScreenParameters;
  const EventListScreen({super.key, required this.eventListScreenParameters});

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
      physics: NeverScrollableScrollPhysics(),
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
              top: 25.h,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Row(
                    children: [
                      ArrowBackWidget(
                        onTap: () {
                          ref.read(navigationProvider).removeTopPage(context: context);
                        },
                        size: 15,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: 18.h),
                          child: textBoldPoppins(
                              color: lightThemeSecondaryColor,
                              fontSize: 16.sp,
                              textAlign: TextAlign.center,
                              text: widget.eventListScreenParameters.subCategoryHeading),
                        ),
                      )
                    ],
                  ),
                ),
              ),
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
