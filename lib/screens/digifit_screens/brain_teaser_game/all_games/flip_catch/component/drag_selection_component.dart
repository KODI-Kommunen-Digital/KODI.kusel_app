import 'package:flutter/material.dart';

class DragSelectTextWidget extends StatefulWidget {
  final String fullText;
  final Function(String selectedText, int startIndex, int endIndex)
      onWordSelected;
  final int? selectedStartIndex;
  final int? selectedEndIndex;
  final bool? isCorrect;
  final int? correctStartIndex;
  final int? correctEndIndex;
  final bool isEnabled;
  final List<Map<String, int>>? completedRanges;
  final Color textColor;

  const DragSelectTextWidget({
    Key? key,
    required this.fullText,
    required this.onWordSelected,
    this.selectedStartIndex,
    this.selectedEndIndex,
    this.isCorrect,
    this.correctStartIndex,
    this.correctEndIndex,
    this.isEnabled = true,
    this.completedRanges,
    required this.textColor,
  }) : super(key: key);

  @override
  State<DragSelectTextWidget> createState() => _DragSelectTextWidgetState();
}

class _DragSelectTextWidgetState extends State<DragSelectTextWidget> {
  final GlobalKey _textKey = GlobalKey();
  int? _dragStartIndex;
  int? _dragCurrentIndex;
  bool _isDragging = false;

  List<Rect> _charRects = [];
  final double _fontSize = 20.0;
  final double _lineHeight = 28.0;

  static final Color _greenCorrect = Color(0xFFAADB40).withOpacity(0.75);
  static final Color _redWrong = Color(0xFFC92120).withOpacity(0.75);
  static final Color _blueDrag = Colors.blue.withOpacity(0.3);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _buildCharacterRects();
    });
  }

  @override
  void didUpdateWidget(DragSelectTextWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fullText != widget.fullText) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _buildCharacterRects();
      });
    }
  }

  void _buildCharacterRects() {
    if (!mounted) return;

    final renderBox = _textKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    setState(() {
      _charRects = [];
      double currentX = 0;
      double currentY = 0;
      final maxWidth = renderBox.size.width;

      for (int i = 0; i < widget.fullText.length; i++) {
        final char = widget.fullText[i];

        final textPainter = TextPainter(
          text: TextSpan(
            text: char,
            style: TextStyle(
              fontSize: _fontSize,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();

        if (currentX + textPainter.width > maxWidth && currentX > 0) {
          currentX = 0;
          currentY += _lineHeight;
        }

        _charRects.add(Rect.fromLTWH(
          currentX,
          currentY,
          textPainter.width,
          textPainter.height,
        ));

        currentX += textPainter.width;
      }
    });
  }

  int? _getCharIndexAtPosition(Offset localPosition) {
    for (int i = 0; i < _charRects.length; i++) {
      if (_charRects[i].inflate(6).contains(localPosition)) {
        return i;
      }
    }
    return null;
  }

  void _handlePanStart(DragStartDetails details) {
    if (!widget.isEnabled || _charRects.isEmpty) return;

    final renderBox = _textKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final localPosition = renderBox.globalToLocal(details.globalPosition);
    final charIndex = _getCharIndexAtPosition(localPosition);

    if (charIndex != null) {
      setState(() {
        _dragStartIndex = charIndex;
        _dragCurrentIndex = charIndex;
        _isDragging = true;
      });
    }
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (!_isDragging || !widget.isEnabled || _charRects.isEmpty) return;

    final renderBox = _textKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final localPosition = renderBox.globalToLocal(details.globalPosition);
    final charIndex = _getCharIndexAtPosition(localPosition);

    if (charIndex != null && charIndex != _dragCurrentIndex) {
      setState(() {
        _dragCurrentIndex = charIndex;
      });
    }
  }

  void _handlePanEnd(DragEndDetails details) {
    if (!_isDragging || !widget.isEnabled) return;

    if (_dragStartIndex != null && _dragCurrentIndex != null) {
      final start = _dragStartIndex! < _dragCurrentIndex!
          ? _dragStartIndex!
          : _dragCurrentIndex!;
      final end = _dragStartIndex! < _dragCurrentIndex!
          ? _dragCurrentIndex!
          : _dragStartIndex!;

      if (end - start + 1 >= 2) {
        final selectedText = widget.fullText.substring(start, end + 1);
        widget.onWordSelected(selectedText, start, end);
      } else {}
    }

    setState(() {
      _isDragging = false;
      _dragStartIndex = null;
      _dragCurrentIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
      child: GestureDetector(
        onPanStart: _handlePanStart,
        onPanUpdate: _handlePanUpdate,
        onPanEnd: _handlePanEnd,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return CustomPaint(
              key: _textKey,
              painter: _DragSelectTextPainter(
                fullText: widget.fullText,
                fontSize: _fontSize,
                charRects: _charRects,
                completedRanges: widget.completedRanges,
                selectedStartIndex: widget.selectedStartIndex,
                selectedEndIndex: widget.selectedEndIndex,
                isCorrect: widget.isCorrect,
                correctStartIndex: widget.correctStartIndex,
                correctEndIndex: widget.correctEndIndex,
                dragStartIndex: _dragStartIndex,
                dragCurrentIndex: _dragCurrentIndex,
                isDragging: _isDragging,
                textColor: widget.textColor,
                greenColor: _greenCorrect,
                redColor: _redWrong,
                blueColor: _blueDrag,
              ),
              size: Size(constraints.maxWidth, constraints.maxHeight),
            );
          },
        ),
      ),
    );
  }
}

class _DragSelectTextPainter extends CustomPainter {
  final String fullText;
  final double fontSize;
  final List<Rect> charRects;
  final List<Map<String, int>>? completedRanges;
  final int? selectedStartIndex;
  final int? selectedEndIndex;
  final bool? isCorrect;
  final int? correctStartIndex;
  final int? correctEndIndex;
  final int? dragStartIndex;
  final int? dragCurrentIndex;
  final bool isDragging;
  final Color textColor;
  final Color greenColor;
  final Color redColor;
  final Color blueColor;

  _DragSelectTextPainter({
    required this.fullText,
    required this.fontSize,
    required this.charRects,
    this.completedRanges,
    this.selectedStartIndex,
    this.selectedEndIndex,
    this.isCorrect,
    this.correctStartIndex,
    this.correctEndIndex,
    this.dragStartIndex,
    this.dragCurrentIndex,
    required this.isDragging,
    required this.textColor,
    required this.greenColor,
    required this.redColor,
    required this.blueColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (charRects.isEmpty) return;

    // Draw completed ranges with (GREEN background)
    if (completedRanges != null) {
      for (var range in completedRanges!) {
        final start = range['start'] ?? 0;
        final end = range['end'] ?? 0;
        _drawTextRange(canvas, start, end, greenColor, isFilled: true);
      }
    }

    // Draw active drag selection with (BLUE background)
    if (isDragging && dragStartIndex != null && dragCurrentIndex != null) {
      final start = dragStartIndex! < dragCurrentIndex!
          ? dragStartIndex!
          : dragCurrentIndex!;
      final end = dragStartIndex! < dragCurrentIndex!
          ? dragCurrentIndex!
          : dragStartIndex!;

      _drawTextRange(canvas, start, end, blueColor, isFilled: true);
    }

    // Draw confirmed selection
    if (selectedStartIndex != null && selectedEndIndex != null && !isDragging) {
      if (isCorrect == true) {
        _drawTextRange(
            canvas, selectedStartIndex!, selectedEndIndex!, greenColor,
            isFilled: true);
      } else {
        _drawTextRange(canvas, selectedStartIndex!, selectedEndIndex!, redColor,
            isFilled: false);
      }
    }

    // Draw correct answer hint with (GREEN background)
    if (isCorrect == false &&
        correctStartIndex != null &&
        correctEndIndex != null) {
      _drawTextRange(
        canvas,
        correctStartIndex!,
        correctEndIndex!,
        greenColor,
        isFilled: true,
      );
    }

    _drawText(canvas);
  }

  void _drawTextRange(Canvas canvas, int startIdx, int endIdx, Color color,
      {required bool isFilled}) {
    if (startIdx < 0 || endIdx >= charRects.length || startIdx > endIdx) return;

    final paint = Paint()
      ..color = color
      ..style = isFilled ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = isFilled ? 0 : 3;

    double? lineStartX;
    double? lineY;
    double? lineEndX;

    for (int i = startIdx; i <= endIdx; i++) {
      final rect = charRects[i];

      if (lineStartX == null) {
        lineStartX = rect.left;
        lineY = rect.top;
        lineEndX = rect.right;
      } else if ((rect.top - lineY!).abs() < 2) {
        lineEndX = rect.right;
      } else {
        final bgRect = RRect.fromRectAndRadius(
          Rect.fromLTRB(lineStartX, lineY, lineEndX!, lineY + fontSize * 1.4),
          const Radius.circular(4),
        );
        canvas.drawRRect(bgRect, paint);

        lineStartX = rect.left;
        lineY = rect.top;
        lineEndX = rect.right;
      }
    }

    if (lineStartX != null && lineY != null && lineEndX != null) {
      final bgRect = RRect.fromRectAndRadius(
        Rect.fromLTRB(lineStartX, lineY, lineEndX, lineY + fontSize * 1.4),
        const Radius.circular(4),
      );
      canvas.drawRRect(bgRect, paint);
    }
  }

  void _drawText(Canvas canvas) {
    for (int i = 0; i < fullText.length; i++) {
      final charPainter = TextPainter(
        text: TextSpan(
          text: fullText[i],
          style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              height: 1.4,
              color: textColor),
        ),
        textDirection: TextDirection.ltr,
      );
      charPainter.layout();
      charPainter.paint(canvas, Offset(charRects[i].left, charRects[i].top));
    }
  }

  @override
  bool shouldRepaint(_DragSelectTextPainter oldDelegate) {
    return oldDelegate.fullText != fullText ||
        oldDelegate.selectedStartIndex != selectedStartIndex ||
        oldDelegate.selectedEndIndex != selectedEndIndex ||
        oldDelegate.isCorrect != isCorrect ||
        oldDelegate.dragStartIndex != dragStartIndex ||
        oldDelegate.dragCurrentIndex != dragCurrentIndex ||
        oldDelegate.isDragging != isDragging ||
        oldDelegate.completedRanges != completedRanges;
  }
}
