class EventListScreenParameter {
  int? categoryId;
  int? subCategoryId;
  String? listHeading;
  double? centerLatitude;
  double? centerLongitude;
  int? radius;

  EventListScreenParameter({
    required this.categoryId,
    this.subCategoryId,
    required this.listHeading,
    this.centerLatitude,
    this.centerLongitude,
    this.radius,
  });
}

