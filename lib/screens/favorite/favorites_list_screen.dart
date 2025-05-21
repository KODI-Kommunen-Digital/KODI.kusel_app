import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/common_widgets/upstream_wave_clipper.dart';

import '../../common_widgets/common_background_clipper_widget.dart';
import '../../common_widgets/event_list_section_widget.dart';
import '../../images_path.dart';
import 'favorites_list_screen_controller.dart';
import 'favorites_list_screen_state.dart';

class FavoritesListScreen extends ConsumerStatefulWidget {
  const FavoritesListScreen({super.key});

  @override
  ConsumerState<FavoritesListScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<FavoritesListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(favoritesListScreenProvider.notifier).getFavoritesList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final FavoritesListScreenState favScreenState =
        ref.watch(favoritesListScreenProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: favScreenState.loading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(favScreenState, context),
    );
  }

  Widget _buildBody(
      FavoritesListScreenState favScreenState, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CommonBackgroundClipperWidget(
            clipperType: UpstreamWaveClipper(),
            height: 130.h,
            imageUrl: imagePath['home_screen_background'] ?? '',
            isStaticImage: true,
            isBackArrowEnabled: true,
            headingText: AppLocalizations.of(context).favorites,
          ),

          // If no events exist, show a message using a SliverFillRemaining
          if (!favScreenState.loading)
            favScreenState.eventsList.isEmpty
                ? Center(
                  child: textHeadingMontserrat(
                      text: AppLocalizations.of(context).no_data,
                  fontSize: 18),
                )
                : EventsListSectionWidget(
                    eventsList: favScreenState.eventsList,
                    heading: null,
                    maxListLimit: favScreenState.eventsList.length,
                    buttonText: null,
                    buttonIconPath: null,
                    isLoading: false,
                    onButtonTap: () {},
                    context: context,
                    isFavVisible: true,
                    onHeadingTap: () {},
                    onSuccess: (bool isFav, int? id) {
                      ref
                          .read(favoritesListScreenProvider.notifier)
                          .removeFavorite(isFav,id);
                    },
                  ),
        ],
      ),
    );
  }
}

/*
 ref.watch(favoritesProvider.notifier).toggleFavorite(
                            item, success: ({required bool isFavorite}) {
                          ref
                              .read(favoritesListScreenProvider.notifier)
                              .removeFavorite(isFavorite, item.id);
                        }, error: ({required String message}) {
                          showErrorToast(message: message, context: context);
                        });
* */
