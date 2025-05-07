import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/providers/favorites_list_notifier.dart';
import 'package:kusel/screens/location/bottom_sheet_selected_ui_type.dart';
import 'package:kusel/screens/location/location_screen_provider.dart';
import 'package:kusel/screens/location/location_screen_state.dart';

import '../../../common_widgets/common_event_card.dart';
import '../../../common_widgets/search_widget.dart';
import '../../../common_widgets/toast_message.dart';

class SelectedFilterScreen extends ConsumerStatefulWidget {
  SelectedFilterScreenParams selectedFilterScreenParams;

  SelectedFilterScreen({super.key, required this.selectedFilterScreenParams});

  @override
  ConsumerState<SelectedFilterScreen> createState() =>
      _SelectedFilterScreenState();
}

class _SelectedFilterScreenState extends ConsumerState<SelectedFilterScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(locationScreenProvider.notifier).getAllEventListUsingCategoryId(
          widget.selectedFilterScreenParams.categoryId.toString());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _buildBody(context),
    ).loaderDialog(context,
        ref.watch(locationScreenProvider).isSelectedFilterScreenLoading);
  }

  _buildBody(BuildContext context) {
    LocationScreenState state = ref.watch(locationScreenProvider);
    return Column(
      children: [
        16.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                ref
                    .read(locationScreenProvider.notifier)
                    .updateBottomSheetSelectedUIType(
                        BottomSheetSelectedUIType.allEvent);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).textTheme.labelMedium!.color,
              ),
            ),
            80.horizontalSpace,
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 5.h,
                width: 100.w,
                decoration: BoxDecoration(
                    color: Theme.of(context).textTheme.labelMedium!.color,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        SearchWidget(
          onItemClick: (listing) {
            ref.read(locationScreenProvider.notifier).setEventItem(listing);
            ref
                .read(locationScreenProvider.notifier)
                .updateBottomSheetSelectedUIType(
                    BottomSheetSelectedUIType.eventDetail);
          },
          searchController: TextEditingController(),
          hintText: AppLocalizations.of(context).enter_search_term,
          suggestionCallback: (search) async {
            List<Listing>? list;
            if (search.isEmpty) return [];
            try {
              list = await ref.read(locationScreenProvider.notifier).searchList(
                  searchText: search, success: () {}, error: (err) {});
            } catch (e) {
              return [];
            }
            return list;
          },
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: textSemiBoldPoppins(
                text: "${state.selectedCategoryName}", fontSize: 16.sp),
          ),
        ),
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = state.allEventList[index];
                    return CommonEventCard(
                      isFavorite: item.isFavorite ?? false,
                      onFavorite: () {
                        ref.watch(favoritesProvider.notifier).toggleFavorite(
                            item, success: ({required bool isFavorite}) {
                          ref
                              .read(locationScreenProvider.notifier)
                              .setIsFavorite(isFavorite, item.id);
                        }, error: ({required String message}) {
                          showErrorToast(message: message, context: context);
                        });
                      },
                      imageUrl: item.logo ?? "",
                      date: item.startDate ?? "",
                      title: item.title ?? "",
                      location: item.address ?? "",
                      onTap: () {
                        ref
                            .read(locationScreenProvider.notifier)
                            .setEventItem(item);
                        ref
                            .read(locationScreenProvider.notifier)
                            .updateBottomSheetSelectedUIType(
                                BottomSheetSelectedUIType.eventDetail);
                      },
                      isFavouriteVisible: ref
                          .read(favoritesProvider.notifier)
                          .showFavoriteIcon(),
                    );
                  },
                  childCount: state.allEventList.length,
                ),
              ),
            ],
          ),
        ),
        60.verticalSpace,
      ],
    );
  }
}

class SelectedFilterScreenParams {
  int categoryId;

  SelectedFilterScreenParams({required this.categoryId});
}
