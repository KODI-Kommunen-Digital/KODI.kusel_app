import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        required this.onFavouriteIconClick
      });

  @override
  ConsumerState<HighlightsCard> createState() => _HighlightsCardState();
}

class _HighlightsCardState extends ConsumerState<HighlightsCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 380,
      width: 300,
      padding: EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF283583).withValues(alpha: 0.46),
            offset: Offset(0, 4),
            blurRadius: 24,
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: SizedBox(
                  height: 306,
                  child: Image.asset(
                    // height: 306,
                    fit: BoxFit.fill,
                      widget.imageUrl),
                ),
              ),
              Positioned(
                top: 5,
                left: 230,
                child: Container(
                  padding: EdgeInsets.all(8),
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                      color: Color(0xFF283583),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(Icons.favorite_border_sharp, color: Colors.white,),
                ),
              ),
            ],
          ),
          SizedBox(height: 6,),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.date,style: TextStyle(color: Color(0xFF6972A8), fontSize: 13),),
                  SizedBox(height: 4,),
                  Text(widget.heading, style: TextStyle(color: Color(0xFF18204F), fontSize: 15)),
                  SizedBox(height: 4,),
                  Text(widget.description, style: TextStyle(color: Color(0xFF6972A8), fontSize: 13))
                ],
              ),
            ),
          )

        ],
      ),
    );
  }
}
