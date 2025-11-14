import 'dart:ui' as ui;
import 'dart:math';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Common Grid Widget with Timer
class CommonGridWidgets extends FlameGame {
  final CommonGridParamss params;

  CommonGridWidgets({required this.params});

  @override
  ui.Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    images.prefix = '';
    super.onLoad();

    camera.viewport = FixedResolutionViewport(
      resolution: Vector2(
        params.width,
        params.height,
      ),
    );

    _buildGridCells();

    // Add grid lines overlay with timer
    add(CommonGridLinesComponent(
      params: params,
    ));
  }

  void _buildGridCells() {
    for (int row = 0; row < params.rows; row++) {
      for (int col = 0; col < params.columns; col++) {
        final x = col * params.tileWidth + params.tileWidth / 2;
        final y = row * params.tileHeight + params.tileHeight / 2;

        final cell = CommonGridCell(
          position: Vector2(x, y),
          size: Vector2(params.tileWidth, params.tileHeight),
          borderRadius: _getBorderRadius(row, col),
          row: row,
          col: col,
          onTap: params.onCellTapped,
          params: params,
        );
        add(cell);
      }
    }
  }

  BorderRadius? _getBorderRadius(int row, int col) {
    final radius = 16.r;
    final isTopLeft = row == 0 && col == 0;
    final isTopRight = row == 0 && col == params.columns - 1;
    final isBottomLeft = row == params.rows - 1 && col == 0;
    final isBottomRight = row == params.rows - 1 && col == params.columns - 1;

    if (isTopLeft || isTopRight || isBottomLeft || isBottomRight) {
      return BorderRadius.only(
        topLeft: isTopLeft ? Radius.circular(radius) : Radius.zero,
        topRight: isTopRight ? Radius.circular(radius) : Radius.zero,
        bottomLeft: isBottomLeft ? Radius.circular(radius) : Radius.zero,
        bottomRight: isBottomRight ? Radius.circular(radius) : Radius.zero,
      );
    }

    return null;
  }
}

class CommonGridCell extends PositionComponent
    with TapCallbacks, HasGameReference<CommonGridWidgets> {
  BorderRadius? borderRadius;
  int row;
  int col;
  Function(int, int)? onTap;
  final CommonGridParamss params;

  CommonGridCell({
    required super.position,
    required super.size,
    this.borderRadius,
    required this.row,
    required this.col,
    this.onTap,
    required this.params,
  }) {
    anchor = Anchor.center;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final rect = size.toRect();

    // Draw base white background
    final whiteFillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    if (borderRadius != null) {
      canvas.drawRRect(borderRadius!.toRRect(rect), whiteFillPaint);
    } else {
      canvas.drawRect(rect, whiteFillPaint);
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    onTap?.call(row, col);
  }
}

class CommonGridLinesComponent extends Component {
  final CommonGridParamss params;

  CommonGridLinesComponent({
    required this.params,
  });

  @override
  void render(Canvas canvas) {
    final radius = 16.r;
    final outerRect = Rect.fromLTWH(0, 0, params.width, params.height);
    final outerRRect =
    RRect.fromRectAndRadius(outerRect, Radius.circular(radius));

    // Draw static grey border first
    final greyBorderPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    canvas.drawRRect(outerRRect, greyBorderPaint);

    // ✅ CRITICAL: Only draw timer if showTimer is true
    if (params.showTimer) {
      final currentTime = params.currentTime;
      final maxTime = params.maxTime;
      final showTimerLine = currentTime < maxTime && currentTime >= 0;

      if (showTimerLine) {
        final progress = maxTime > 0 ? currentTime / maxTime : 0.0;

        Color timerColor;
        if (progress > 0.5) {
          timerColor = const Color(0xFF4CAF50); // Green
        } else if (progress > 0.16) {
          timerColor = const Color(0xFFFF9800); // Orange
        } else {
          timerColor = const Color(0xFFC92120); // Red
        }

        _drawTimerLine(canvas, outerRect, radius, progress, timerColor);
      }
    }

    // Draw inner grid lines
    final innerPaint = Paint()
      ..color = params.borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Vertical lines
    for (int col = 1; col < params.columns; col++) {
      final x = col * params.tileWidth;
      canvas.drawLine(Offset(x, 0), Offset(x, params.height), innerPaint);
    }

    // Horizontal lines
    for (int row = 1; row < params.rows; row++) {
      final y = row * params.tileHeight;
      canvas.drawLine(Offset(0, y), Offset(params.width, y), innerPaint);
    }
  }

  void _drawTimerLine(
      Canvas canvas, Rect rect, double radius, double progress, Color color) {
    // ... existing _drawTimerLine code (no changes needed)
    final width = rect.width;
    final height = rect.height;

    final cornerCircumference = 2 * pi * radius;
    final totalPerimeter = (width - 2 * radius) * 2 +
        (height - 2 * radius) * 2 +
        cornerCircumference;

    final traveledDistance = totalPerimeter * (1.0 - progress);

    final timerPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(radius, 0);

    double accumulatedDistance = 0;

    // Top edge
    final topEdgeLength = width - 2 * radius;
    if (traveledDistance <= accumulatedDistance + topEdgeLength) {
      final lineEnd = traveledDistance - accumulatedDistance;
      path.lineTo(radius + lineEnd, 0);
      canvas.drawPath(path, timerPaint);
      return;
    }
    path.lineTo(width - radius, 0);
    accumulatedDistance += topEdgeLength;

    // Top-right corner
    final topRightArcLength = cornerCircumference / 4;
    if (traveledDistance <= accumulatedDistance + topRightArcLength) {
      final arcProgress =
          (traveledDistance - accumulatedDistance) / topRightArcLength;
      path.arcTo(
        Rect.fromLTWH(width - 2 * radius, 0, 2 * radius, 2 * radius),
        -pi / 2,
        (pi / 2) * arcProgress,
        false,
      );
      canvas.drawPath(path, timerPaint);
      return;
    }
    path.arcTo(
      Rect.fromLTWH(width - 2 * radius, 0, 2 * radius, 2 * radius),
      -pi / 2,
      pi / 2,
      false,
    );
    accumulatedDistance += topRightArcLength;

    // Right edge
    final rightEdgeLength = height - 2 * radius;
    if (traveledDistance <= accumulatedDistance + rightEdgeLength) {
      final lineEnd = traveledDistance - accumulatedDistance;
      path.lineTo(width, radius + lineEnd);
      canvas.drawPath(path, timerPaint);
      return;
    }
    path.lineTo(width, height - radius);
    accumulatedDistance += rightEdgeLength;

    // Bottom-right corner
    final bottomRightArcLength = cornerCircumference / 4;
    if (traveledDistance <= accumulatedDistance + bottomRightArcLength) {
      final arcProgress =
          (traveledDistance - accumulatedDistance) / bottomRightArcLength;
      path.arcTo(
        Rect.fromLTWH(
            width - 2 * radius, height - 2 * radius, 2 * radius, 2 * radius),
        0,
        (pi / 2) * arcProgress,
        false,
      );
      canvas.drawPath(path, timerPaint);
      return;
    }
    path.arcTo(
      Rect.fromLTWH(
          width - 2 * radius, height - 2 * radius, 2 * radius, 2 * radius),
      0,
      pi / 2,
      false,
    );
    accumulatedDistance += bottomRightArcLength;

    // Bottom edge
    final bottomEdgeLength = width - 2 * radius;
    if (traveledDistance <= accumulatedDistance + bottomEdgeLength) {
      final lineEnd = traveledDistance - accumulatedDistance;
      path.lineTo(width - radius - lineEnd, height);
      canvas.drawPath(path, timerPaint);
      return;
    }
    path.lineTo(radius, height);
    accumulatedDistance += bottomEdgeLength;

    // Bottom-left corner
    final bottomLeftArcLength = cornerCircumference / 4;
    if (traveledDistance <= accumulatedDistance + bottomLeftArcLength) {
      final arcProgress =
          (traveledDistance - accumulatedDistance) / bottomLeftArcLength;
      path.arcTo(
        Rect.fromLTWH(0, height - 2 * radius, 2 * radius, 2 * radius),
        pi / 2,
        (pi / 2) * arcProgress,
        false,
      );
      canvas.drawPath(path, timerPaint);
      return;
    }
    path.arcTo(
      Rect.fromLTWH(0, height - 2 * radius, 2 * radius, 2 * radius),
      pi / 2,
      pi / 2,
      false,
    );
    accumulatedDistance += bottomLeftArcLength;

    // Left edge
    final leftEdgeLength = height - 2 * radius;
    if (traveledDistance <= accumulatedDistance + leftEdgeLength) {
      final lineEnd = traveledDistance - accumulatedDistance;
      path.lineTo(0, height - radius - lineEnd);
      canvas.drawPath(path, timerPaint);
      return;
    }
    path.lineTo(0, radius);
    accumulatedDistance += leftEdgeLength;

    // Top-left corner
    final topLeftArcLength = cornerCircumference / 4;
    if (traveledDistance <= accumulatedDistance + topLeftArcLength) {
      final arcProgress =
          (traveledDistance - accumulatedDistance) / topLeftArcLength;
      path.arcTo(
        Rect.fromLTWH(0, 0, 2 * radius, 2 * radius),
        pi,
        (pi / 2) * arcProgress,
        false,
      );
      canvas.drawPath(path, timerPaint);
      return;
    }

    canvas.drawPath(path, timerPaint);
  }
}
class CommonGridParamss {
  final double width;
  final double height;
  final double tileHeight;
  final double tileWidth;
  final int rows;
  final int columns;
  final Function(int, int) onCellTapped;
  final Color borderColor;
  final bool useInnerPadding;
  int currentTime;
  final int maxTime;
  final bool showTimer;

  CommonGridParamss({
    required this.width,
    required this.height,
    required this.tileHeight,
    required this.tileWidth,
    required this.rows,
    required this.columns,
    required this.onCellTapped,
    required this.borderColor,
    this.useInnerPadding = true,
    this.currentTime = 60,
    this.maxTime = 60,
    this.showTimer = true,
  });
}

