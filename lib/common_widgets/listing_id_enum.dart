enum ListingCategoryId {
  event(3),
  news(1);

  final int eventId;

  const ListingCategoryId(this.eventId);
}

enum SearchRadius {
  radius(40);

  final int value;

  const SearchRadius(this.value);
}
