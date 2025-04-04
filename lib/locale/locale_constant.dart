enum LocaleConstant {
  english("English", "en", "GB"),
  german("Germany", "de", "DE");

  final String displayName;
  final String languageCode;
  final String region;

  const LocaleConstant(this.displayName, this.languageCode, this.region);
}
