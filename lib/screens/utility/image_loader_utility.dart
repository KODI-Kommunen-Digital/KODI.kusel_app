String imageLoaderUtility({required String image, required int sourceId}) {
  if (sourceId == 1) {
    return "https://kusel1heidi.obs.eu-de.otc.t-systems.com/$image";
  } else {
    return image;
  }
}
