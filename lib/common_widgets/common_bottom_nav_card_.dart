import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonBottomNavCard extends ConsumerStatefulWidget {
  final void Function() onBackPress;
  final void Function()? onFavChange;
  bool isFavVisible;
  bool isFav;

  CommonBottomNavCard(
      {super.key,
      required this.onBackPress,
      required this.isFavVisible,
      this.onFavChange,
      required this.isFav});

  @override
  ConsumerState<CommonBottomNavCard> createState() =>
      _CommonBottomNavCardState();
}

class _CommonBottomNavCardState extends ConsumerState<CommonBottomNavCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      height: 50.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          color: Theme.of(context).colorScheme.secondary),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 48.h,
            width: 48.w,
            child: IconButton(
                onPressed: widget.onBackPress,
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).canvasColor,
                )),
          ),
          Visibility(
            visible: widget.isFavVisible,
            child: GestureDetector(
              onTap: widget.onFavChange,
              child: SizedBox(
                height: 30.h,
                width: 30.w,
                child: Icon(
                  widget.isFav ? Icons.favorite_sharp : Icons.favorite_border,
                  color: !widget.isFav
                      ? Theme.of(context).canvasColor
                      : Theme.of(context).colorScheme.onTertiaryFixed,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
