import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:flutter/material.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/event_list_section_widget.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/screens/location/bottom_sheet_selected_ui_type.dart';
import 'package:kusel/screens/location/location_screen_provider.dart';
import 'package:kusel/screens/location/location_screen_state.dart';

import '../../../common_widgets/search_widget.dart';

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
    );
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
            final sortedList = ref
                .watch(locationScreenProvider.notifier)
                .sortSuggestionList(search, list);
            return sortedList;
            return sortedList;
          },
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: textSemiBoldPoppins(
                text: "${state.selectedCategoryName}", fontSize: 16),
          ),
        ),
        if (ref.watch(locationScreenProvider).isSelectedFilterScreenLoading)
          CircularProgressIndicator(),
        if (!ref.read(locationScreenProvider).isSelectedFilterScreenLoading)
          Expanded(
            child: SingleChildScrollView(
              child: EventsListSectionWidget(
                shrinkWrap: true,
                eventsList: state.allEventList,
                heading: null,
                maxListLimit: state.allEventList.length,
                buttonText: null,
                buttonIconPath: null,
                isLoading: false,
                onButtonTap: () {},
                context: context,
                isFavVisible: true,
                onHeadingTap: () {},
                onSuccess: (bool isFav, int? id) {
                  ref
                      .read(locationScreenProvider.notifier)
                      .updateIsFav(isFav, id);
                },
                onFavClickCallback: () {
                  ref.read(locationScreenProvider.notifier).getAllEventListUsingCategoryId(
                      widget.selectedFilterScreenParams.categoryId.toString());
                },
              ),
            ),
          ),
        40.verticalSpace,
      ],
    );
  }
}

class SelectedFilterScreenParams {
  int categoryId;

  SelectedFilterScreenParams({required this.categoryId});
}
