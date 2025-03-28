import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/common_widgets/text_styles.dart';

class CategoryGridCardView extends ConsumerStatefulWidget {
  final String title;
  final String imageUrl;
  final VoidCallback? onTap;

  const CategoryGridCardView({
    Key? key,
    required this.imageUrl,
    required this.title,
    this.onTap,
  }) : super(key: key);

  @override
  ConsumerState<CategoryGridCardView> createState() => _CommonEventCardState();
}

class _CommonEventCardState extends ConsumerState<CategoryGridCardView> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 4,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8), // Adjust the radius as needed
            child: Image.network(
              widget.imageUrl,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.broken_image, size: 80),
              width: 175,
              height: 111,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: 175,
            height: 64,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: textRegularMontserrat(text: widget.title, fontSize: 16),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
