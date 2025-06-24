import 'package:flutter/material.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/image_text_card_widget.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/providers/favourite_cities_notifier.dart';

import '../../app_router.dart';
import '../../common_widgets/common_background_clipper_widget.dart';
import '../../common_widgets/text_styles.dart';
import '../../common_widgets/toast_message.dart';
import '../../common_widgets/upstream_wave_clipper.dart';
import '../../images_path.dart';
import '../../navigation/navigation.dart';
import '../ort_detail/ort_detail_screen_params.dart';
import 'favourite_city_screen_controller.dart';

class FavouriteCityScreen extends ConsumerStatefulWidget {
  const FavouriteCityScreen({super.key});

  @override
  ConsumerState<FavouriteCityScreen> createState() =>
      _FavouriteCityScreenState();
}

class _FavouriteCityScreenState extends ConsumerState<FavouriteCityScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(favouriteCityScreenProvider.notifier).fetchFavouriteCities();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .scaffoldBackgroundColor,
      body: _buildBody(context),
    ).loaderDialog(context, ref
        .watch(favouriteCityScreenProvider)
        .isLoading);
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          children: [
            CommonBackgroundClipperWidget(
                clipperType: UpstreamWaveClipper(),
                imageUrl: imagePath['background_image'] ?? "",
                headingText: AppLocalizations
                    .of(context)
                    .favourite_city,
                height: 120.h,
                blurredBackground: true,
                isBackArrowEnabled: true,
                isStaticImage: true
            ),
            if(!ref
                .watch(favouriteCityScreenProvider)
                .isLoading && ref
                .watch(favouriteCityScreenProvider)
                .cityList
                .isNotEmpty)
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: ref
                      .read(favouriteCityScreenProvider)
                      .cityList
                      .length,
                  itemBuilder: (context, index) {
                    final item = ref
                        .read(favouriteCityScreenProvider)
                        .cityList[index];
                    return Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 5.h, horizontal: 12.w),
                      child: ImageTextCardWidget(
                        onTap: () {
                          ref.read(navigationProvider).navigateUsingPath(
                              path: ortDetailScreenPath,
                              context: context,
                              params: OrtDetailScreenParams(
                                  ortId: item.id.toString(),
                                  onFavSuccess: (isFav, id) {}
                              ));
                        },
                        imageUrl: item.image ??
                            'https://images.unsplash.com/photo-1584713503693-bb386ec95cf2?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                        text: item.name ?? '',
                        sourceId: 1,
                        isFavourite: true,
                        isFavouriteVisible: ref
                            .read(
                            favouriteCitiesNotifier.notifier)
                            .showFavoriteIcon(),
                        onFavoriteTap: () {
                          ref
                              .watch(favouriteCitiesNotifier.notifier)
                              .removeFavorite(
                            item.id ?? 0,
                                ({required bool isFavorite}) {
                              ref
                                  .read(favouriteCityScreenProvider.notifier)
                                  .fetchFavouriteCities();
                            },
                                ({required String message}) {
                              showErrorToast(
                                  message: message, context: context);
                            },
                          );
                        },),
                    );
                  }),

            if(!ref
                .watch(favouriteCityScreenProvider)
                .isLoading && ref
                .watch(favouriteCityScreenProvider)
                .cityList
                .isEmpty)
              Center(
                child: textHeadingMontserrat(
                    text: AppLocalizations.of(context).no_data,
                    fontSize: 18),
              )
          ],
        ),
      ),
    );
  }

// _updateList(bool isFav, int cityId) {
//   ref
//       .read(favouriteCitiesProvider.notifier)
//       .setIsFavoriteCity(isFav, cityId);
// }

}
