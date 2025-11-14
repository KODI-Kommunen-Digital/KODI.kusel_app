import 'dart:ui' as ui;
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

/// Game to display cross marks on wrong matched cells with light red background
class CrossMarkOverlayGame extends FlameGame {
  final int wrongRow1;
  final int wrongCol1;
  final int wrongRow2;
  final int wrongCol2;
  final double gridWidth;
  final double gridHeight;
  final double tileWidth;
  final double tileHeight;

  CrossMarkOverlayGame({
    required this.wrongRow1,
    required this.wrongCol1,
    required this.wrongRow2,
    required this.wrongCol2,
    required this.gridWidth,
    required this.gridHeight,
    required this.tileWidth,
    required this.tileHeight,
  });

  @override
  ui.Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    images.prefix = '';
    camera.viewport = FixedResolutionViewport(
      resolution: Vector2(gridWidth, gridHeight),
    );

    // Add cross mark for first wrong cell
    final component1 = CrossMarkComponent(
      row: wrongRow1,
      column: wrongCol1,
      tileWidth: tileWidth,
      tileHeight: tileHeight,
    );
    add(component1);

    // Add cross mark for second wrong cell (if different from first)
    if (wrongRow2 != wrongRow1 || wrongCol2 != wrongCol1) {
      final component2 = CrossMarkComponent(
        row: wrongRow2,
        column: wrongCol2,
        tileWidth: tileWidth,
        tileHeight: tileHeight,
      );
      add(component2);
    }
  }
}

/// Component to display a small red cross mark with light red background on a cell
class CrossMarkComponent extends PositionComponent {
  final int row;
  final int column;
  final double tileWidth;
  final double tileHeight;

  CrossMarkComponent({
    required this.row,
    required this.column,
    required this.tileWidth,
    required this.tileHeight,
  });

  @override
  Future<void> onLoad() async {
    final x = column * tileWidth + tileWidth / 2;
    final y = row * tileHeight + tileHeight / 2;

    position = Vector2(x, y);

    // Use same padding as other overlays
    const padding = 3.0;
    size = Vector2(tileWidth - padding, tileHeight - padding);
    anchor = Anchor.center;
  }

  @override
  void render(Canvas canvas) {
    final rect = size.toRect();

    // Draw light red background without rounded corners
    final backgroundPaint = Paint()
      ..color = const Color(0xFFE01709).withOpacity(0.4) // Light red background
      ..style = PaintingStyle.fill;

    canvas.drawRect(rect, backgroundPaint);

    // Draw smaller red cross on the image
    const crossPadding = 44.0; // Padding to make cross smaller
    final crossPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    // Draw diagonal line from top-left to bottom-right
    canvas.drawLine(
      Offset(rect.left + crossPadding, rect.top + crossPadding),
      Offset(rect.right - crossPadding, rect.bottom - crossPadding),
      crossPaint,
    );

    // Draw diagonal line from top-right to bottom-left
    canvas.drawLine(
      Offset(rect.right - crossPadding, rect.top + crossPadding),
      Offset(rect.left + crossPadding, rect.bottom - crossPadding),
      crossPaint,
    );
  }

// @override
// void render(Canvas canvas) {
//   final rect = size.toRect();
//
//   // Draw light red background with rounded corners
//   final backgroundPaint = Paint()
//     ..color = const Color(0xFFE01709).withOpacity(0.4) // Light red background
//     ..style = PaintingStyle.fill;
//
//   final rrect = RRect.fromRectAndRadius(
//     rect,
//     const Radius.circular(8.0),
//   );
//   canvas.drawRRect(rrect, backgroundPaint);
//
//   // Draw smaller red cross on the image
//   const crossPadding = 44.0; // Increased padding to make cross smaller
//   final crossPaint = Paint()
//     ..color = Colors.white
//     ..style = PaintingStyle.stroke
//     ..strokeWidth = 3
//     ..strokeCap = StrokeCap.round;
//
//   // Draw diagonal line from top-left to bottom-right
//   canvas.drawLine(
//     Offset(rect.left + crossPadding, rect.top + crossPadding),
//     Offset(rect.right - crossPadding, rect.bottom - crossPadding),
//     crossPaint,
//   );
//
//   // Draw diagonal line from top-right to bottom-left
//   canvas.drawLine(
//     Offset(rect.right - crossPadding, rect.top + crossPadding),
//     Offset(rect.left + crossPadding, rect.bottom - crossPadding),
//     crossPaint,
//   );
// }
}
