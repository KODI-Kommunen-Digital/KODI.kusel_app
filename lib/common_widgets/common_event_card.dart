import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kusel/common_widgets/text_styles.dart';

import '../theme_manager/colors.dart';

class CommonEventCard extends ConsumerStatefulWidget {
  final String imageUrl;
  final String date;
  final String title;
  final String location;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;

  const CommonEventCard({
    Key? key,
    required this.imageUrl,
    required this.date,
    required this.title,
    required this.location,
    this.onTap,
    this.onFavorite,
  }) : super(key: key);

  @override
  ConsumerState<CommonEventCard> createState() => _CommonEventCardState();
}

class _CommonEventCardState extends ConsumerState<CommonEventCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(widget.imageUrl,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 80),
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover),
              ),
              const SizedBox(width: 8),

              // Texts
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textRegularMontserrat(
                        text: formatDate(widget.date), color: Theme.of(context).textTheme.labelMedium?.color),
                    const SizedBox(height: 4),
                    textSemiBoldMontserrat(text: widget.title),
                    const SizedBox(height: 2),
                    textRegularMontserrat(
                        text: widget.location, color: Theme.of(context).textTheme.labelMedium?.color),
                  ],
                ),
              ),
              InkWell(
                onTap: widget.onFavorite,
                child: const Icon(
                  Icons.favorite_border,
                  color: Colors.black,
                ),
              ),
            ],
          ),
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
