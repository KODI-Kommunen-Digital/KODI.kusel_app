import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/common_event_card.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/common_widgets/upstream_wave_clipper.dart';
import 'package:kusel/navigation/navigation.dart';
import 'package:kusel/providers/favorites_list_notifier.dart';
import 'package:kusel/screens/event/event_detail_screen_controller.dart';
import 'package:kusel/screens/events_listing/selected_event_list_screen_controller.dart';
import 'package:kusel/screens/events_listing/selected_event_list_screen_parameter.dart';

import '../../common_widgets/arrow_back_widget.dart';
import '../../images_path.dart';
import '../../theme_manager/colors.dart';
import 'selected_event_list_screen_state.dart';

class SelectedEventListScreen extends ConsumerStatefulWidget {
  final SelectedEventListScreenParameter eventListScreenParameter;

  const SelectedEventListScreen(
      {super.key, required this.eventListScreenParameter});

  @override
  ConsumerState<SelectedEventListScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<SelectedEventListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(selectedEventListScreenProvider.notifier)
          .getEventsList(widget.eventListScreenParameter);
    });
  }

  @override
  Widget build(BuildContext context) {
    final SelectedEventListScreenState categoryScreenState =
        ref.watch(selectedEventListScreenProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      body: categoryScreenState.loading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(categoryScreenState, context),
    );
  }

  Widget _buildBody(
      SelectedEventListScreenState categoryScreenState, BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          automaticallyImplyLeading: false,
          floating: true,
          pinned: false,
          expandedHeight: MediaQuery.of(context).size.height * 0.15,
          flexibleSpace: FlexibleSpaceBar(
            background: ClipPath(
              clipper: UpstreamWaveClipper(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  imagePath['background_image'] ?? "",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          title: Row(
            children: [
              ArrowBackWidget(
                onTap: () {
                  ref.read(navigationProvider).removeTopPage(context: context);
                },
                size: 15,
              ),
              Expanded(
                child: Center(
                  child: textBoldPoppins(
                    color: lightThemeSecondaryColor,
                    fontSize: 16.sp,
                    textAlign: TextAlign.center,
                    text: widget.eventListScreenParameter.listHeading ?? "",
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Theme.of(context).cardColor.withValues(alpha: 0.6),
        ),

        // If no events exist, show a message using a SliverFillRemaining
        categoryScreenState.eventsList.isEmpty
            ? SliverFillRemaining(
                child: Center(
                  child: textHeadingMontserrat(
                      text: AppLocalizations.of(context).no_data),
                ),
              )
            : SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = categoryScreenState.eventsList[index];
                    return CommonEventCard(
                      imageUrl: item.logo ?? "",
                      date: item.startDate ?? "",
                      title: item.title ?? "",
                      location: item.address ?? "",
                      onFavorite: () {
                        ref.read(favoritesProvider.notifier).toggleFavorite(
                            item, success: ({required bool isFavorite}) {
                          ref
                              .read(selectedEventListScreenProvider.notifier)
                              .setIsFavorite(isFavorite, item.id);
                        }, error: ({required String message}) {});
                      },
                      isFavorite: item.isFavorite ?? false,
                      onTap: () {
                        ref.read(navigationProvider).navigateUsingPath(
                              context: context,
                              path: eventScreenPath,
                              params: EventDetailScreenParams(eventId: item.id),
                            );
                      },
                      isFavouriteVisible: ref
                          .watch(favoritesProvider.notifier)
                          .showFavoriteIcon(),
                    );
                  },
                  childCount: categoryScreenState.eventsList.length,
                ),
              ),
      ],
    );
  }
}
