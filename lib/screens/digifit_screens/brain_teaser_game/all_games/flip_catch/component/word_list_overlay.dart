import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../../../../../common_widgets/text_styles.dart';

class WordListOverlayGame extends FlameGame with TapCallbacks {
  final String fullText;
  final Function(int) onWordSelected;
  final double width;
  final double height;
  final Color background;
  final Color selectedColor;
  final int? selectedIndex;
  final bool? isCorrect;
  final int? correctIndex;
  final bool isEnabled;
  final List<int>? ccompletedIndices;
  final int currentTargetIndex;
  final Color? textColor;

  WordListOverlayGame(
      {required this.fullText,
      required this.onWordSelected,
      required this.width,
      required this.height,
      required this.background,
      required this.selectedColor,
      this.selectedIndex,
      this.isCorrect,
      this.correctIndex,
      this.isEnabled = true,
      this.ccompletedIndices,
      required this.currentTargetIndex,
      required this.textColor});

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    camera.viewport = FixedResolutionViewport(
      resolution: Vector2(width, height),
    );
    _createParagraphWithClickableWords();
  }

  void _createParagraphWithClickableWords() {
    final horizontalScreenPadding = 14.0;
    final cardWidth = width - (horizontalScreenPadding * 2);
    final horizontalPaddingInside = 20.0;
    final verticalPaddingInside = 40.0;
    final fontSize = 20.0;
    final lineHeight = fontSize * 1.4;

    final words = fullText
        .split(' ')
        .where((word) => word.trim().isNotEmpty)
        .map((word) => word.trim())
        .toList();

    // Calculate exact content height with word wrapping
    final spaceWidth = _calculateSpaceWidth(fontSize);
    double currentX = 0;
    double currentY = 0;
    int lineCount = 1;

    for (int i = 0; i < words.length; i++) {
      final textWidget = textSemiBoldPoppins(
        text: words[i],
        fontSize: 20,
        color: textColor,
        fontWeight: FontWeight.w600,
      );

      final textStyle = textWidget.style!;

      final textPainter = TextPainter(
        text: TextSpan(
          text: words[i],
          style: textStyle,
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      if (currentX + textPainter.width >
              cardWidth - horizontalPaddingInside * 2 &&
          currentX > 0) {
        currentX = 0;
        currentY += lineHeight + 8;
        lineCount++;
      }

      currentX += textPainter.width + spaceWidth;
    }

    final actualContentHeight =
        (lineCount * lineHeight) + ((lineCount - 1) * 8);
    final cardHeight = actualContentHeight + (verticalPaddingInside * 2) + 20;

    final topMargin = 40.0;
    final container = WhiteContainerComponent(
      position: Vector2(width / 2, topMargin),
      size: Vector2(cardWidth, cardHeight),
    );
    add(container);

    final paragraph = ClickableParagraphComponent(
      fullText: fullText,
      words: words,
      position: Vector2(horizontalPaddingInside, verticalPaddingInside),
      size: Vector2(
        cardWidth - horizontalPaddingInside * 2,
        actualContentHeight + 20,
      ),
      fontSize: fontSize,
      selectedIndex: selectedIndex,
      isCorrect: isCorrect,
      correctIndex: correctIndex,
      isEnabled: isEnabled,
      ccompletedIndices: ccompletedIndices,
      currentTargetIndex: currentTargetIndex,
      color: textColor,
      onWordTap: (index) {
        if (isEnabled && selectedIndex == null) {
          onWordSelected(index);
        }
      },
    );

    container.add(paragraph);
  }

  double _calculateSpaceWidth(double fontSize) {
    final textWidget = textSemiBoldPoppins(
      text: ' ',
      fontSize: 20,
      color: textColor,
      fontWeight: FontWeight.w600,
    );

    final textStyle = textWidget.style!;

    final spacePainter = TextPainter(
      text: TextSpan(
        text: ' ',
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
    );
    spacePainter.layout();
    return spacePainter.width + 2;
  }
}

class WhiteContainerComponent extends PositionComponent {
  late RRect _containerRect;

  WhiteContainerComponent({
    required Vector2 position,
    required Vector2 size,
  }) : super(
          position: position,
          size: size,
          anchor: Anchor.topCenter,
        );

  @override
  Future<void> onLoad() async {
    _containerRect = RRect.fromRectAndRadius(
      size.toRect(),
      const Radius.circular(24),
    );
  }

  @override
  void render(Canvas canvas) {
    final bgPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawRRect(_containerRect, bgPaint);
  }
}

class ClickableParagraphComponent extends PositionComponent with TapCallbacks {
  final String fullText;
  final List<String> words;
  final double fontSize;
  final int? selectedIndex;
  final bool? isCorrect;
  final int? correctIndex;
  final bool isEnabled;
  final List<int>? ccompletedIndices;
  final int currentTargetIndex;
  final Function(int) onWordTap;
  final Color? color;

  late List<TextPainter> _wordPainters;
  late List<Rect> _wordRects;
  bool _processingTap = false;

  ClickableParagraphComponent(
      {required this.fullText,
      required this.words,
      required Vector2 position,
      required Vector2 size,
      required this.fontSize,
      required this.selectedIndex,
      required this.isCorrect,
      required this.correctIndex,
      required this.isEnabled,
      required this.onWordTap,
      required this.ccompletedIndices,
      required this.currentTargetIndex,
      required this.color})
      : super(
          position: position,
          size: size,
          anchor: Anchor.topLeft,
        );

  @override
  Future<void> onLoad() async {
    _wordPainters = [];
    _wordRects = [];

    double currentX = 0;
    double currentY = 0;
    final lineHeight = fontSize * 1.4;
    final spaceWidth = _calculateSpaceWidth();

    for (int i = 0; i < words.length; i++) {
      final word = words[i];
      Color wordColor = Colors.black;

      final isCompleted = ccompletedIndices?.contains(i) ?? false;

      if (isCompleted) {
        wordColor = const Color(0xFFAADB40).withOpacity(0.75);
      } else if (selectedIndex != null) {
        if (i == selectedIndex) {
          wordColor = (isCorrect == true)
              ? const Color(0xFFAADB40).withOpacity(0.75)
              : const Color(0xFFC92120).withOpacity(0.75);
        } else if (i == correctIndex && isCorrect == false) {
          wordColor = const Color(0xFFAADB40).withOpacity(0.75);
        }
      }

      final textWidget = textSemiBoldPoppins(
        text: word,
        fontSize: 20,
        color: color,
        fontWeight: FontWeight.w600,
      );

      final textStyle = textWidget.style!;

      final textPainter = TextPainter(
        text: TextSpan(text: word, style: textStyle),
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      if (currentX + textPainter.width > size.x && currentX > 0) {
        currentX = 0;
        currentY += lineHeight + 8;
      }

      _wordPainters.add(textPainter);
      _wordRects.add(Rect.fromLTWH(
        currentX,
        currentY,
        textPainter.width,
        textPainter.height,
      ));

      currentX += textPainter.width + spaceWidth;
    }
  }

  double _calculateSpaceWidth() {
    final spacePainter = TextPainter(
      text: TextSpan(
        text: ' ',
        style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
      ),
      textDirection: TextDirection.ltr,
    );
    spacePainter.layout();
    return spacePainter.width + 2;
  }

  @override
  void render(Canvas canvas) {
    for (int i = 0; i < _wordPainters.length; i++) {
      final isCompleted = ccompletedIndices?.contains(i) ?? false;

      if (isCompleted) {
        final bgPaint = Paint()
          ..color = const Color(0xFFAADB40).withOpacity(0.75)
          ..style = PaintingStyle.fill;
        final bgRect = RRect.fromRectAndRadius(
          _wordRects[i].inflate(6),
          const Radius.circular(8),
        );
        canvas.drawRRect(bgRect, bgPaint);
      } else if (selectedIndex != null && isCorrect != null) {
        if (i == selectedIndex) {
          if (isCorrect!) {
            final bgPaint = Paint()
              ..color = const Color(0xFFAADB40).withOpacity(0.75)
              ..style = PaintingStyle.fill;
            final bgRect = RRect.fromRectAndRadius(
              _wordRects[i].inflate(6),
              const Radius.circular(8),
            );
            canvas.drawRRect(bgRect, bgPaint);
          } else {
            final borderPaint = Paint()
              ..color = const Color(0xFFC92120).withOpacity(0.75)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 3;
            final bgRect = RRect.fromRectAndRadius(
              _wordRects[i].inflate(6),
              const Radius.circular(8),
            );
            canvas.drawRRect(bgRect, borderPaint);
          }
        } else if (i == correctIndex && isCorrect == false) {
          final bgPaint = Paint()
            ..color = const Color(0xFFAADB40).withOpacity(0.75)
            ..style = PaintingStyle.fill;
          final bgRect = RRect.fromRectAndRadius(
            _wordRects[i].inflate(6),
            const Radius.circular(8),
          );
          canvas.drawRRect(bgRect, bgPaint);
        }
      }

      final textWidget = textSemiBoldPoppins(
        text: words[i],
        fontSize: 20,
        color: color,
        fontWeight: FontWeight.w600,
      );

      final textStyle = textWidget.style!;

      _wordPainters[i].text = TextSpan(text: words[i], style: textStyle);
      _wordPainters[i].layout();
      _wordPainters[i].paint(
        canvas,
        Offset(_wordRects[i].left, _wordRects[i].top),
      );
    }
  }

  @override
  bool onTapDown(TapDownEvent event) {
    if (selectedIndex != null || !isEnabled || _processingTap) {
      return false;
    }

    final localPosition = event.localPosition;

    for (int i = 0; i < _wordRects.length; i++) {
      if (ccompletedIndices?.contains(i) ?? false) {
        continue;
      }

      final expandedRect = _wordRects[i].inflate(8);
      if (expandedRect.contains(localPosition.toOffset())) {
        _processingTap = true;
        onWordTap(i);

        Future.delayed(const Duration(milliseconds: 500), () {
          _processingTap = false;
        });
        return true;
      }
    }
    return false;
  }
}
