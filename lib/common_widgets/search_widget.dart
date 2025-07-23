import 'dart:async';
import 'dart:convert';

import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kusel/common_widgets/device_helper.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/images_path.dart';

import '../utility/kusel_date_utils.dart';
import 'image_utility.dart';

class SearchWidget extends ConsumerStatefulWidget {
  String hintText;
  TextEditingController searchController;
  FutureOr<List<Listing>?> Function(String) suggestionCallback;
  Function(Listing) onItemClick;
  VerticalDirection? verticalDirection;
  bool isPaddingEnabled;

  SearchWidget(
      {super.key,
      required this.hintText,
      required this.searchController,
      required this.suggestionCallback,
      required this.onItemClick,
      this.verticalDirection,
      required this.isPaddingEnabled
      });

  @override
  ConsumerState<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends ConsumerState<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      width: 350.w,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(width: 1, color: Theme.of(context).dividerColor)),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.0.w),
          child: Row(
            children: [
              ImageUtil.loadSvgImage(
                height: DeviceHelper.isMobile(context) ? null : 15.h,
                  width: DeviceHelper.isMobile(context) ? null : 15.h,
                  imageUrl: imagePath['search_icon'] ?? '', context: context),
              8.horizontalSpace,
              Expanded(
                child: TypeAheadField<Listing>(
                  hideOnEmpty: true,
                  hideOnUnfocus: true,
                  hideOnSelect: true,
                  hideWithKeyboard: false,
                  direction: widget.verticalDirection ?? VerticalDirection.down,
                  debounceDuration: Duration(milliseconds: 1000),
                  controller: widget.searchController,
                  suggestionsCallback: widget.suggestionCallback,
                  decorationBuilder: (context,widget){
                    return Container(
                      padding: super.widget.isPaddingEnabled ? EdgeInsets.symmetric(vertical: 10.h,
                        horizontal: 5.w) : null,
                      constraints: BoxConstraints(
                        maxHeight: 250.h,
                        maxWidth: double.infinity// Set max height here as per your UI
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(10.r)
                      ),
                      child: widget,
                    );
                  },
                  builder: (context, controller, focusNode) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode, // Add this
                      decoration: InputDecoration(
                          hintText: widget.hintText,
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).hintColor,
                              fontStyle: FontStyle.italic)),
                    );
                  },
                  itemBuilder: (context, event) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2.0, vertical: 2.0),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        title: Align(
                          alignment: Alignment.centerLeft,
                          child: textRegularPoppins(
                            text: event.title ?? "",
                            fontSize: 16,
                            color: Colors.black87,
                            textAlign:
                                TextAlign.start, // Ensure text is left-aligned
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: textRegularPoppins(
                              text: KuselDateUtils.formatDate(
                                  event.startDate ?? ""),
                              fontSize: 14,
                              color: Colors.grey[600],
                              textAlign: TextAlign
                                  .start, // Ensure text is left-aligned
                            ),
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                        ),
                      ),
                    );
                  },
                  onSelected: (listing) {
                    widget.searchController.clear();
                    FocusScope.of(context).unfocus();
                    saveListingToPrefs(listing);
                    widget.onItemClick(listing);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  saveListingToPrefs(Listing newListing) {
    final existingJson =
        ref.read(sharedPreferenceHelperProvider).getString(searchListKey);

    List<Listing> currentListings = [];
    if (existingJson != null && existingJson.isNotEmpty) {
      final List<dynamic> decoded = jsonDecode(existingJson);
      currentListings = decoded.map((e) => Listing.fromJson(e)).toList();
    }

    currentListings.removeWhere((item) => item.id == newListing.id);
    currentListings.add(newListing);
    if (currentListings.length > 5) {
      currentListings.removeAt(0);
    }
    final updatedJson =
        jsonEncode(currentListings.map((e) => e.toJson()).toList());
    ref
        .read(sharedPreferenceHelperProvider)
        .setString(searchListKey, updatedJson);
  }
}
