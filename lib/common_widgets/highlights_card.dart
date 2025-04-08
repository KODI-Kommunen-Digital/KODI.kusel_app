import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/theme_manager/colors.dart';

import '../app_router.dart';
import '../navigation/navigation.dart';

class HighlightsCard extends ConsumerStatefulWidget {
  String imageUrl;
  String date;
  String heading;
  String description;
  bool isFavourite;
  Function() onPress;
  Function() onFavouriteIconClick;

  HighlightsCard(
      {super.key,
      required this.imageUrl,
      required this.date,
      required this.heading,
      required this.description,
      required this.isFavourite,
      required this.onPress,
      required this.onFavouriteIconClick});

  @override
  ConsumerState<HighlightsCard> createState() => _HighlightsCardState();
}

class _HighlightsCardState extends ConsumerState<HighlightsCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.46),
            offset: Offset(0, 4),
            blurRadius: 24,
          ),
        ],
      ),
      child: InkWell(
        onTap: (){
          widget.onPress;
        },
        child: Column(
          children: [
            SizedBox(
              height: 200.h,
              child: Stack(
                fit: StackFit.loose,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18.r),
                    child: SizedBox(
                      height: 200.h,
                      child: Image.asset(widget.imageUrl, fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    top: 5.h,
                    left: 195.w,
                    child: Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                      child: Icon(
                        Icons.favorite_border_sharp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            6.verticalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                4.verticalSpace,
                textSemiBoldMontserrat(
                  text:formatDate(widget.date), fontSize: 14),
                4.verticalSpace,
                textSemiBoldMontserrat(text: widget.heading, fontSize: 16),
                4.verticalSpace,
                textSemiBoldMontserrat(text: widget.description, fontSize: 14, textAlign: TextAlign.start, textOverflow: TextOverflow.visible, maxLines: 3)
              ],
            )
          ],
        ),
      ),
    );
  }

  String formatDate(String inputDate) {
    try {
      final DateTime parsedDate = DateTime.parse(inputDate);
      final DateFormat formatter = DateFormat('dd.MM.yyyy');
      return formatter.format(parsedDate);
    }
    catch(e){
      return inputDate;
    }
  }
}
