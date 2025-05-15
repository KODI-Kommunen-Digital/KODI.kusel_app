import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kusel/images_path.dart';
import 'package:kusel/screens/utility/image_loader_utility.dart';

class ImageUtil {
  static Widget loadNetworkImage(
      {required String imageUrl,
      String? svgErrorImagePath,
      required BuildContext context,
      double? height,
      double? width,
      BoxFit? fit,
      int? sourceId
      }) {
    return CachedNetworkImage(
      fit: fit ?? BoxFit.cover,
      height: height,
      width: width,
      imageUrl: imageLoaderUtility(image: imageUrl, sourceId: sourceId ?? 3),
      progressIndicatorBuilder: (context, value ,_) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
      errorWidget: (context, value, _) {
        return (svgErrorImagePath != null)
            ? SvgPicture.asset(svgErrorImagePath)
            : Icon(Icons.broken_image);
      },
    );
  }

  static Widget loadBase64Image(
      {required Uint8List bytes,
      required BuildContext context,
      double? height,
      double? width,
      BoxFit? fit}) {
    return Image.memory(
      bytes,
      fit: BoxFit.cover,
      height: height,
      width: width,
    );
  }

  static Widget loadAssetImage(
      {required String imageUrl,
      required BuildContext context,
      double? height,
      double? width,
      BoxFit? fit}) {
    return Image.asset(
      imageUrl,
      fit: fit ?? BoxFit.cover,
      height: height,
      width: width,
    );
  }

  static Widget loadLocalAssetImage(
      {required String imageUrl,
      required BuildContext context,
      double? height,
      double? width,
      BoxFit? fit}) {
    return Image.asset(
      imagePath[imageUrl]!,
      fit: fit ?? BoxFit.cover,
      height: height,
      width: width,
    );
  }

  static Widget loadSvgImage(
      {required String imageUrl,
      required BuildContext context,
      double? height,
      double? width,
      BoxFit? fit}) {
    return SvgPicture.asset(imageUrl,
        fit: fit ?? BoxFit.cover, height: height, width: width);
  }

  static Widget loadLocalSvgImage(
      {required String imageUrl,
      required BuildContext context,
      double? height,
      double? width,
      BoxFit? fit}) {
    return SvgPicture.asset(imagePath[imageUrl]!,
        fit: fit ?? BoxFit.cover, height: height, width: width);
  }
}
