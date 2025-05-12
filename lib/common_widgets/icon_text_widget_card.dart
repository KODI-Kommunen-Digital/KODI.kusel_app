import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/images_path.dart';

class IconTextWidgetCard extends ConsumerStatefulWidget {
  final Function() onTap;
  final String imageUrl;
  final String text;
  final String? description;

  const IconTextWidgetCard(
      {super.key,
      required this.onTap,
      required this.imageUrl,
      required this.text,
      this.description});

  @override
  ConsumerState<IconTextWidgetCard> createState() => _IconTextWidgetCardState();
}

class _IconTextWidgetCardState extends ConsumerState<IconTextWidgetCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding:
              EdgeInsets.only(left: 2.w, right: 14.w, top: 20.h, bottom: 20.h),
          decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.circular(15.r)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex: 3, child:
              SvgPicture.asset(imagePath[widget.imageUrl] ?? '')
                // CachedNetworkImage(imageUrl: widget.imageUrl
              ),
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textBoldMontserrat(
                        text: widget.text,
                        color: Theme.of(context).textTheme.bodyLarge?.color),
                    if(widget.description != null)
                        textRegularMontserrat(
                            text: widget.description ?? '',
                            fontSize: 11,
                            textOverflow: TextOverflow.visible,
                            textAlign: TextAlign.start)
                  ],
                ),
              ),
              Expanded(
                  flex: 1,
                  child:
                      SvgPicture.asset(imagePath["place_holder_icon"] ?? '')),
            ],
          ),
        ),
      ),
    );
  }
}
