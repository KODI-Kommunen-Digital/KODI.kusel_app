import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class CustomShimmerWidget extends ConsumerStatefulWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const CustomShimmerWidget.rectangular({super.key, this.width = double
      .infinity, required this.height, this.shapeBorder = const RoundedRectangleBorder()});

  const CustomShimmerWidget.circular(
      {super.key,
      required this.width,
      required this.height,
      this.shapeBorder = const CircleBorder()});

  @override
  ConsumerState<CustomShimmerWidget> createState() =>
      _CustomShimmerWidgetState();
}

class _CustomShimmerWidgetState extends ConsumerState<CustomShimmerWidget> {
  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
      baseColor: Colors.grey[400]!,
      highlightColor: Colors.grey[200]!,
      period: Duration(milliseconds: 500),
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: ShapeDecoration(
            shape: widget.shapeBorder, color: Colors.grey[400]!),
      ));
}
