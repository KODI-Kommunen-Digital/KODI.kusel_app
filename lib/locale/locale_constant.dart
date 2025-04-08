enum LocaleConstant {
  english("English", "en", "GB"),
  german("German", "de", "DE");

  final String displayName;
  final String languageCode;
  final String region;

  const LocaleConstant(this.displayName, this.languageCode, this.region);
}
