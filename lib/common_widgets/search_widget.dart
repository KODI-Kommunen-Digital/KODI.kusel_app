import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:domain/model/response_model/listings_model/search_listings_response_model.dart';
import 'package:domain/usecase/search/search_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/images_path.dart';
import 'package:data/params/listings_params.dart';
import 'package:kusel/screens/home/home_screen_provider.dart';

import '../app_router.dart';
import '../navigation/navigation.dart';
import '../theme_manager/colors.dart';

class SearchWidget extends ConsumerStatefulWidget {
  String hintText;
  TextEditingController searchController;

  SearchWidget(
      {super.key, required this.hintText, required this.searchController});

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
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(width: 1, color: Theme.of(context).dividerColor)),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.0.w),
          child: Row(
            children: [
              SvgPicture.asset(imagePath['search_icon'] ?? ''),
              8.horizontalSpace,
              Expanded(
                child: TypeAheadField<Listing>(
                  hideOnEmpty: true,
                  hideOnUnfocus: true,
                  hideOnSelect: true,
                  debounceDuration: const Duration(milliseconds: 500),
                  controller: widget.searchController,
                  // Ensures it's not behind your container
                  suggestionsCallback: (search) async {
                    if (search.isEmpty) return [];
                    try {
                      final list = await ref.read(homeScreenProvider.notifier).searchList(
                        searchText: search,
                        success: () {},
                        error: (err) {},
                      );
                      print(">>>> success ${list.length}");
                      return list;
                    } catch (e) {
                      print(">>>> error $e");
                      return [];
                    }
                  },
                  itemBuilder: (context, event) {
                    return ListTile(
                      title: Text(event.title ?? "", style: TextStyle(fontSize: 16)),
                      subtitle: Text(event.startDate ?? "", style: TextStyle(fontSize: 14)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                    );
                  },
                  onSelected: (listing) {
                    widget.searchController.clear();
                    FocusScope.of(context).unfocus();
                    ref.read(navigationProvider).navigateUsingPath(
                      context: context,
                      path: eventScreenPath,
                      params: listing,
                    );
                  },
                  builder: (context, controller, focusNode) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).hintColor,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    );
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
