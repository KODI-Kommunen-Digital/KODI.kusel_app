import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html/parser.dart' as html_parser;

class CommonHtmlWidget extends ConsumerStatefulWidget {
  final String data;
  final double? fontSize;
  final int? maxLines;

  const CommonHtmlWidget({super.key, required this.data, this.fontSize,
  this.maxLines});

  @override
  ConsumerState<CommonHtmlWidget> createState() => _CommonHtmlWidgetState();
}

class _CommonHtmlWidgetState extends ConsumerState<CommonHtmlWidget> {
  @override
  Widget build(BuildContext context) {
    return Html(data: widget.data, style: {
      "body": Style(
        fontSize: FontSize(widget.fontSize ?? 12.sp),
        color: Theme.of(context).textTheme.bodyLarge?.color,
        textAlign: TextAlign.left,
        backgroundColor: Colors.transparent,
        margin: Margins.zero,
        padding: HtmlPaddings.zero
      ),
    });
  }
}


String stripHtmlTags(String htmlString) {
  final document = html_parser.parse(htmlString);
  return document.body?.text ?? "";
}