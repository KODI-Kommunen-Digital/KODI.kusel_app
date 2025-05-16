import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/text_styles.dart';

import '../screens/utility/image_loader_utility.dart';
import 'image_utility.dart';

class ImageTextCardWidget extends ConsumerStatefulWidget {
  final String? text;
  final String? imageUrl;
  final int? sourceId;
  final Function()? onTap;

  const ImageTextCardWidget(
      {super.key, required this.text, required this.imageUrl, this.sourceId, this.onTap});

  @override
  ConsumerState<ImageTextCardWidget> createState() =>
      _ImageTextCardWidgetState();
}

class _ImageTextCardWidgetState extends ConsumerState<ImageTextCardWidget> {
  @override
  Widget build(BuildContext context) {
    return _buildImageTextCard(
        text: widget.text, imageUrl: widget.imageUrl, onTap: widget.onTap);
  }

  _buildImageTextCard({String? text, String? imageUrl, int? sourceId, Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(8.h.w),
          child: Row(
            children: [
              SizedBox(
                height: 50.h,
                width: 50.w,
                child: ImageUtil.loadNetworkImage(
                    fit: BoxFit.contain,
                    imageUrl:
                        imageLoaderUtility(image: imageUrl ?? '', sourceId: 1),
                    sourceId: sourceId,
                    context: context),
              ),
              SizedBox(width: 30.w),
              // Texts
              Flexible(
                  child: textRegularMontserrat(
                      textAlign: TextAlign.start,
                      text: text ?? '',
                      textOverflow: TextOverflow.visible,
                      fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
