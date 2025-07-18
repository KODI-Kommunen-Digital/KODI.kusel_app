import 'package:flutter/cupertino.dart';

import '../../l10n/app_localizations.dart';

class FilterCategory {
  final int categoryId;
  final String categoryName;
  final String imagePath;

  FilterCategory({
    required this.categoryId,
    required this.categoryName,
    required this.imagePath,
  });
}

List<FilterCategory> staticFilterCategoryList(BuildContext context) {
  final localization = AppLocalizations.of(context);

  return [
    FilterCategory(
      categoryId: 1,
      categoryName: localization.map_fav,
      imagePath: "fav_category_icon",
    ),
    FilterCategory(
      categoryId: 2,
      categoryName: localization.location_map_events,
      imagePath: "event_category_icon",
    ),
    FilterCategory(
      categoryId: 3,
      categoryName: localization.location_map_clubs,
      imagePath: "groups",
    ),
    FilterCategory(
      categoryId: 4,
      categoryName: localization.location_map_regional_products,
      imagePath: "shopping_category_icon",
    ),
    FilterCategory(
      categoryId: 5,
      categoryName: localization.location_map_offer,
      imagePath: "glass_icon",
    ),
    FilterCategory(
      categoryId: 6,
      categoryName: localization.location_map_new_citizen,
      imagePath: "cap_icon",
    ),
    FilterCategory(
      categoryId: 7,
      categoryName: localization.location_map_lost_and_found,
      imagePath: "paw_icon",
    ),
    FilterCategory(
      categoryId: 8,
      categoryName: localization.location_map_company_portraits,
      imagePath: "facilities_category_icon",
    ),
    FilterCategory(
      categoryId: 9,
      categoryName: localization.location_map_transport,
      imagePath: "transport_icon",
    ),
    FilterCategory(
      categoryId: 10,
      categoryName: localization.location_map_fitness,
      imagePath: "sports",
    ),
    FilterCategory(
      categoryId: 11,
      categoryName: localization.location_map_eat_drink,
      imagePath: "gastro_category_icon",
    ),
    FilterCategory(
      categoryId: 12,
      categoryName: localization.location_map_free_time,
      imagePath: "tourism_service_image",
    ),
    FilterCategory(
      categoryId: 13,
      categoryName: localization.location_map_highlights,
      imagePath: "tourism_service_image",
    ),
    FilterCategory(
      categoryId: 14,
      categoryName: localization.location_map_poi,
      imagePath: "place_holder_icon",
    ),
  ];
}