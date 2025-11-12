// import 'dart:ui' as ui;
//
// import 'package:flame/camera.dart';
// import 'package:flame/components.dart';
// import 'package:flame/events.dart';
// import 'package:flame/game.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:kusel/screens/digifit_screens/brain_teaser_game/boldi_finder/arrow_direction.dart';
// import 'package:kusel/screens/digifit_screens/brain_teaser_game/boldi_finder/boldi_component.dart';
// import 'package:kusel/screens/digifit_screens/brain_teaser_game/boldi_finder/pause_icon.dart';
//
// class GridViewUI extends FlameGame {
//   GridViewUIParams gridViewUIParams;
//
//   BoldiComponent? boldiComponent;
//   ArrowComponent? arrowComponent;
//   PauseIconComponent? pauseIconComponent;
//
//   bool isShowingBoldi = false;
//   bool isShowingArrows = false;
//   bool isShowingPause = false;
//   bool isGamePlayEnable = false;
//
//   GridViewUI({required this.gridViewUIParams});
//
//   @override
//   ui.Color backgroundColor() {
//     return Colors.transparent;
//   }
//
//   @override
//   Future<void> onLoad() async {
//     images.prefix = '';
//     await super.onLoad();
//
//     camera.viewport = FixedResolutionViewport(
//       resolution: Vector2(gridViewUIParams.width, gridViewUIParams.height),
//     );
//
//     // Add cards first
//     for (int row = 0; row < gridViewUIParams.rows; row++) {
//       for (int column = 0; column < gridViewUIParams.columns; column++) {
//         final x = column * (gridViewUIParams.tileWidth) +
//             gridViewUIParams.tileWidth / 2;
//         final y = row * (gridViewUIParams.tileHeight) +
//             gridViewUIParams.tileHeight / 2;
//
//         final card = GridViewCardUI(
//             gridViewUIParams: gridViewUIParams,
//             position: Vector2(x, y),
//             size: Vector2(
//                 gridViewUIParams.tileWidth, gridViewUIParams.tileHeight),
//             borderRadius: _getBorderRadius(row, column),
//             row: row,
//             column: column);
//         add(card);
//       }
//     }
//
//     // Add grid lines component on top
//     final gridLines = GridLinesComponent(gridViewUIParams: gridViewUIParams);
//     add(gridLines);
//
//     startGameFlow();
//   }
//
//   BorderRadius? _getBorderRadius(int row, int col) {
//     final radius = 16.r;
//
//     final isTopLeft = row == 0 && col == 0;
//     final isTopRight = row == 0 && col == gridViewUIParams.columns - 1;
//     final isBottomLeft = row == gridViewUIParams.rows - 1 && col == 0;
//     final isBottomRight =
//         row == gridViewUIParams.rows - 1 && col == gridViewUIParams.columns - 1;
//
//     if (isTopLeft || isTopRight || isBottomLeft || isBottomRight) {
//       return BorderRadius.only(
//         topLeft: isTopLeft ? Radius.circular(radius) : Radius.zero,
//         topRight: isTopRight ? Radius.circular(radius) : Radius.zero,
//         bottomLeft: isBottomLeft ? Radius.circular(radius) : Radius.zero,
//         bottomRight: isBottomRight ? Radius.circular(radius) : Radius.zero,
//       );
//     }
//     return null;
//   }
//
//   Future<void> startGameFlow() async {
//     int correctRow = gridViewUIParams.startPositionRow;
//     int correctColumn = gridViewUIParams.startPositionCol;
//
//     await showBoldi(correctRow, correctColumn);
//     await showArrowSequence();
//     await showPauseIcon();
//
//     enableGamePlay();
//   }
//
//   Future<void> showBoldi(int correctRow, int correctColumn) async {
//     isShowingBoldi = true;
//
//     boldiComponent = BoldiComponent(
//         gridViewUIParams: gridViewUIParams,
//         row: correctRow,
//         column: correctColumn);
//
//     add(boldiComponent!);
//
//     await Future.delayed(const Duration(seconds: 3));
//
//     remove(boldiComponent!);
//     boldiComponent = null;
//     isShowingBoldi = false;
//   }
//
//   Future<void> showArrowSequence() async {
//     isShowingArrows = true;
//
//     for (final stepString in gridViewUIParams.steps) {
//       final direction = ArrowDirection.fromString(stepString);
//
//       if (direction == null) {
//         debugPrint('Unknown direction: $stepString');
//         continue;
//       }
//
//       arrowComponent = ArrowComponent(
//         direction: direction,
//         gridViewUIParams: gridViewUIParams,
//       );
//       add(arrowComponent!);
//       await Future.delayed(const Duration(milliseconds: 500));
//
//       remove(arrowComponent!);
//       arrowComponent = null;
//     }
//
//     isShowingArrows = false;
//   }
//
//   // Show pause icon
//   Future<void> showPauseIcon() async {
//     isShowingPause = true;
//
//     pauseIconComponent = PauseIconComponent(
//       gridViewUIParams: gridViewUIParams,
//     );
//     add(pauseIconComponent!);
//
//     // Wait for 1 second
//     await Future.delayed(const Duration(seconds: 1));
//
//     // Remove pause icon
//     remove(pauseIconComponent!);
//     pauseIconComponent = null;
//     isShowingPause = false;
//   }
//
//   void enableGamePlay() {
//     isGamePlayEnable = true;
//     debugPrint('Game is now playable! Click on the correct cell.');
//   }
//
//   // Check if user clicked correct position
//   void checkAnswer(int row, int column) {
//     if (!isGamePlayEnable) return;
//
//     debugPrint('User clicked row: $row, column: $column nd ${gridViewUIParams.finalPositionRow} and col is ${gridViewUIParams.finalPositionCol}');
//
//
//     if (row == gridViewUIParams.finalPositionRow && column == gridViewUIParams.finalPositionCol) {
//       debugPrint('✅ CORRECT! User found the Boldi!');
//       // TODO: Show success card
//     } else {
//       debugPrint('❌ WRONG! User clicked wrong position.');
//       // TODO: Show error card
//     }
//
//     isGamePlayEnable = false;
//   }
// }
//
// class GridViewCardUI extends PositionComponent
//     with TapCallbacks, HasGameReference<GridViewUI> {
//   GridViewUIParams gridViewUIParams;
//   bool isFlipped = false;
//   BorderRadius? borderRadius;
//   int row;
//   int column;
//
//   GridViewCardUI({
//     required this.gridViewUIParams,
//     required super.position,
//     required super.size,
//     required this.row,
//     required this.column,
//     required this.borderRadius,
//   }) {
//     anchor = Anchor.center;
//   }
//
//   final borderPaint = Paint()
//     ..color = Colors.black
//     ..style = PaintingStyle.stroke
//     ..strokeWidth = 2;
//
//   @override
//   void render(Canvas canvas) {
//     final rect = size.toRect();
//
//     // Always draw white background first
//     final whiteFillPaint = Paint()
//       ..color = Colors.white
//       ..style = PaintingStyle.fill;
//
//     if (borderRadius != null) {
//       final rrect = borderRadius!.toRRect(rect);
//       canvas.drawRRect(rrect, whiteFillPaint);
//     } else {
//       canvas.drawRect(rect, whiteFillPaint);
//     }
//
//     // Green fill logic
//     if (isFlipped) {
//       RRect fillRRect;
//
//       if (gridViewUIParams.isError) {
//         debugPrint('inside what?? inside the isError if block');
//         const padding = 8.0;
//         final paddedRect = Rect.fromLTRB(
//           rect.left + padding,
//           rect.top + padding,
//           rect.right - padding,
//           rect.bottom - padding,
//         );
//         fillRRect = RRect.fromRectAndRadius(
//           paddedRect,
//           const Radius.circular(8.0),
//         );
//
//         final redFillPaint = Paint()
//           ..color = const Color(0xFFFF0000)
//           ..strokeWidth = 4
//           ..style = PaintingStyle.stroke;
//         canvas.drawRRect(fillRRect, redFillPaint);
//       } else {
//         debugPrint('inside what?? inside the isError else block');
//
//         if (gridViewUIParams.gameId == 3) {
//           debugPrint('inside what?? inside the gameId 3 if block');
//
//           const padding = 8.0;
//           final paddedRect = Rect.fromLTRB(
//             rect.left + padding,
//             rect.top + padding,
//             rect.right - padding,
//             rect.bottom - padding,
//           );
//
//           fillRRect = RRect.fromRectAndRadius(
//             paddedRect,
//             const Radius.circular(8.0),
//           );
//         } else {
//           debugPrint('inside what?? inside the gameId 3 else block');
//
//           fillRRect = borderRadius != null
//               ? borderRadius!.toRRect(rect)
//               : RRect.fromRectAndRadius(rect, Radius.zero);
//         }
//       }
//
//       final greenFillPaint = Paint()
//         ..color = const Color(0xFF00FF00)
//         ..style = PaintingStyle.fill;
//
//       canvas.drawRRect(fillRRect, greenFillPaint);
//     }
//
//     // Border at the end
//     if (borderRadius != null) {
//       final borderRRect = borderRadius!.toRRect(rect);
//       canvas.drawRRect(borderRRect, borderPaint);
//     } else {
//       canvas.drawRect(rect, borderPaint);
//     }
//   }
//
//   @override
//   void onTapDown(TapDownEvent event) {
//     if (game.isGamePlayEnable) {
//       game.checkAnswer(row, column);
//     }
//   }
// }
//
// class GridLinesComponent extends Component {
//   final GridViewUIParams gridViewUIParams;
//
//   GridLinesComponent({required this.gridViewUIParams});
//
//   @override
//   void render(Canvas canvas) {
//     final outerPaint = Paint()
//       ..color = gridViewUIParams.borderColor
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 3.0;
//
//     final innerPaint = Paint()
//       ..color = gridViewUIParams.borderColor
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2.0;
//
//     final radius = 16.r;
//
//     // Draw outer border with rounded corners
//     final outerRect =
//         Rect.fromLTWH(0, 0, gridViewUIParams.width, gridViewUIParams.height);
//     final outerRRect =
//         RRect.fromRectAndRadius(outerRect, Radius.circular(radius));
//     canvas.drawRRect(outerRRect, outerPaint);
//
//     // Draw inner vertical lines
//     for (int col = 1; col < gridViewUIParams.columns; col++) {
//       final x = col * gridViewUIParams.tileWidth;
//       canvas.drawLine(
//         Offset(x, 0),
//         Offset(x, gridViewUIParams.height),
//         innerPaint,
//       );
//     }
//
//     // Draw inner horizontal lines
//     for (int row = 1; row < gridViewUIParams.rows; row++) {
//       final y = row * gridViewUIParams.tileHeight;
//       canvas.drawLine(
//         Offset(0, y),
//         Offset(gridViewUIParams.width, y),
//         innerPaint,
//       );
//     }
//   }
// }
//
// class GridViewUIParams {
//   double width;
//   double height;
//   double tileHeight;
//   double tileWidth;
//   int rows;
//   int columns;
//   int startPositionRow;
//   int startPositionCol;
//   int finalPositionRow;
//   int finalPositionCol;
//   int gameId;
//   bool isError;
//   Color borderColor;
//   List<String> steps;
//   Color arrowColor;
//
//   GridViewUIParams({
//     required this.width,
//     required this.height,
//     required this.tileHeight,
//     required this.tileWidth,
//     required this.rows,
//     required this.columns,
//     required this.startPositionRow,
//     required this.startPositionCol,
//     required this.finalPositionRow,
//     required this.finalPositionCol,
//     required this.gameId,
//     required this.isError,
//     required this.borderColor,
//     required this.steps,
//     required this.arrowColor,
//   });
// }

import 'dart:ui' as ui;
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonGridWidget extends FlameGame {
  final CommonGridParams params;

  CommonGridWidget({required this.params});

  @override
  ui.Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    images.prefix = '';
    await super.onLoad();

    camera.viewport = FixedResolutionViewport(
      resolution: Vector2(params.width, params.height),
    );

    _buildGridCards();

    // Add grid lines on top
    final gridLines = GridLinesComponent(params: params);
    add(gridLines);
  }

  void _buildGridCards() {
    for (int row = 0; row < params.rows; row++) {
      for (int column = 0; column < params.columns; column++) {
        final x = column * params.tileWidth + params.tileWidth / 2;
        final y = row * params.tileHeight + params.tileHeight / 2;

        final card = GridCardComponent(
          params: params,
          position: Vector2(x, y),
          size: Vector2(params.tileWidth, params.tileHeight),
          borderRadius: _getBorderRadius(row, column),
          row: row,
          column: column,
        );
        add(card);
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

/// Individual grid cell/card component
class GridCardComponent extends PositionComponent
    with TapCallbacks, HasGameReference<CommonGridWidget> {
  final CommonGridParams params;
  final BorderRadius? borderRadius;
  final int row;
  final int column;

  bool isFlipped = false;
  bool _isCorrect = true;

  GridCardComponent({
    required this.params,
    required super.position,
    required super.size,
    required this.row,
    required this.column,
    required this.borderRadius,
  }) {
    anchor = Anchor.center;
  }

  final borderPaint = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

  @override
  void render(Canvas canvas) {
    final rect = size.toRect();

    final whiteFillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    if (borderRadius != null) {
      final rrect = borderRadius!.toRRect(rect);
      canvas.drawRRect(rrect, whiteFillPaint);
    } else {
      canvas.drawRect(rect, whiteFillPaint);
    }

    if (isFlipped) {
      _drawFlippedState(canvas, rect);
    }

    // Draw border
    if (borderRadius != null) {
      final borderRRect = borderRadius!.toRRect(rect);
      canvas.drawRRect(borderRRect, borderPaint);
    } else {
      canvas.drawRect(rect, borderPaint);
    }
  }

  void _drawFlippedState(Canvas canvas, Rect rect) {
    RRect fillRRect;

    if (!_isCorrect) {
      const padding = 8.0;
      final paddedRect = Rect.fromLTRB(
        rect.left + padding,
        rect.top + padding,
        rect.right - padding,
        rect.bottom - padding,
      );
      fillRRect = RRect.fromRectAndRadius(
        paddedRect,
        const Radius.circular(8.0),
      );

      final redStrokePaint = Paint()
        ..color = const Color(0xFFFF0000)
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke;
      canvas.drawRRect(fillRRect, redStrokePaint);
    } else {
      if (params.useInnerPadding) {
        const padding = 8.0;
        final paddedRect = Rect.fromLTRB(
          rect.left + padding,
          rect.top + padding,
          rect.right - padding,
          rect.bottom - padding,
        );
        fillRRect = RRect.fromRectAndRadius(
          paddedRect,
          const Radius.circular(8.0),
        );
      } else {
        fillRRect = borderRadius != null
            ? borderRadius!.toRRect(rect)
            : RRect.fromRectAndRadius(rect, Radius.zero);
      }

      final greenFillPaint = Paint()
        ..color = const Color(0xFF00FF00)
        ..style = PaintingStyle.fill;

      canvas.drawRRect(fillRRect, greenFillPaint);
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    params.onCellTapped?.call(row, column);
  }
}

/// Component to draw grid lines
class GridLinesComponent extends Component {
  final CommonGridParams params;

  GridLinesComponent({required this.params});

  @override
  void render(Canvas canvas) {
    final outerPaint = Paint()
      ..color = params.borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final innerPaint = Paint()
      ..color = params.borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final radius = 16.r;

    final outerRect = Rect.fromLTWH(0, 0, params.width, params.height);
    final outerRRect =
        RRect.fromRectAndRadius(outerRect, Radius.circular(radius));
    canvas.drawRRect(outerRRect, outerPaint);

    for (int col = 1; col < params.columns; col++) {
      final x = col * params.tileWidth;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, params.height),
        innerPaint,
      );
    }

    for (int row = 1; row < params.rows; row++) {
      final y = row * params.tileHeight;
      canvas.drawLine(
        Offset(0, y),
        Offset(params.width, y),
        innerPaint,
      );
    }
  }
}

class CommonGridParams {
  final double width;
  final double height;
  final double tileHeight;
  final double tileWidth;
  final int rows;
  final int columns;
  final Color borderColor;

  /// Whether to use inner padding for success state (game mode specific)
  final bool useInnerPadding;
  final Function(int row, int column)? onCellTapped;

  CommonGridParams({
    required this.width,
    required this.height,
    required this.tileHeight,
    required this.tileWidth,
    required this.rows,
    required this.columns,
    required this.borderColor,
    this.useInnerPadding = false,
    this.onCellTapped,
  });
}
