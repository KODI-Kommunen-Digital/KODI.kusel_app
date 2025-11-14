import 'dart:async';
import 'dart:ui' as ui;
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:kusel/common_widgets/image_utility.dart';

/// Enum to specify which corner should be rounded
enum CornerRadius {
  none,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

/// Game to display images on specific cells
class PictureOverlayGame extends FlameGame {
  final List<PicturePosition> pictures;
  final double gridWidth;
  final double gridHeight;
  final double tileWidth;
  final double tileHeight;
  final int sourceId;
  final BaseCacheManager? cacheManager;

  final int gridRows;
  final int gridColumns;

  // Track loading state
  int _loadedCount = 0;
  int get totalImages => pictures.length;
  bool get allImagesLoaded => _loadedCount >= totalImages;

  PictureOverlayGame({
    required this.pictures,
    required this.gridWidth,
    required this.gridHeight,
    required this.tileWidth,
    required this.tileHeight,
    required this.gridRows,
    required this.gridColumns,
    this.sourceId = 3,
    this.cacheManager,
  });

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    images.prefix = '';
    camera.viewport = FixedResolutionViewport(
      resolution: Vector2(gridWidth, gridHeight),
    );

    for (final picture in pictures) {
      CornerRadius cornerToRound = CornerRadius.none;

      // Determine which specific corner to round
      if (picture.row == 0 && picture.col == 0) {
        cornerToRound = CornerRadius.topLeft;
      } else if (picture.row == 0 && picture.col == gridColumns - 1) {
        cornerToRound = CornerRadius.topRight;
      } else if (picture.row == gridRows - 1 && picture.col == 0) {
        cornerToRound = CornerRadius.bottomLeft;
      } else if (picture.row == gridRows - 1 &&
          picture.col == gridColumns - 1) {
        cornerToRound = CornerRadius.bottomRight;
      }

      final component = PictureComponent(
        row: picture.row,
        column: picture.col,
        imageUrl: picture.imageUrl,
        gridWidth: gridWidth,
        gridHeight: gridHeight,
        tileWidth: tileWidth,
        tileHeight: tileHeight,
        sourceId: sourceId,
        cacheManager: cacheManager,
        cornerToRound: cornerToRound,
        onImageLoaded: _onImageLoaded,
      );
      add(component);
    }
  }

  void _onImageLoaded() {
    _loadedCount++;
  }
}

/// Component to display a single picture on a cell (with shimmer effect)
class PictureComponent extends PositionComponent {
  final int row;
  final int column;
  final String imageUrl;
  final double gridWidth;
  final double gridHeight;
  final double tileWidth;
  final double tileHeight;
  final int sourceId;
  final BaseCacheManager? cacheManager;
  final CornerRadius cornerToRound;
  final VoidCallback? onImageLoaded;

  ui.Image? _loadedImage;
  bool _isLoading = true;
  bool _hasError = false;

  // Shimmer animation
  double _shimmerOffset = 0.0;
  static const _shimmerSpeed = 1.5;

  PictureComponent({
    required this.row,
    required this.column,
    required this.imageUrl,
    required this.gridWidth,
    required this.gridHeight,
    required this.tileWidth,
    required this.tileHeight,
    this.sourceId = 3,
    this.cacheManager,
    this.cornerToRound = CornerRadius.none,
    this.onImageLoaded,
  });

  @override
  Future<void> onLoad() async {
    final x = column * tileWidth + tileWidth / 2;
    final y = row * tileHeight + tileHeight / 2;

    position = Vector2(x, y);

    const padding = 3.0;
    size = Vector2(tileWidth - padding, tileHeight - padding);

    anchor = Anchor.center;

    // Start loading image asynchronously without blocking
    _loadCachedNetworkImage();
  }

  Future<void> _loadCachedNetworkImage() async {
    try {
      if (imageUrl.isEmpty) {
        _isLoading = false;
        _hasError = true;
        return;
      }

      debugPrint('Loading image URL: $imageUrl');

      final processedUrl = ImageUtil.getProcessedImageUrl(
        imageUrl: imageUrl,
        sourceId: 1,
      );

      final cacheManagerInstance = cacheManager ?? DefaultCacheManager();
      final file = await cacheManagerInstance.getSingleFile(processedUrl);
      final bytes = await file.readAsBytes();

      // Optimize image decoding with appropriate target size
      final targetSize = (tileWidth * 2).toInt(); // 2x for retina displays
      final codec = await ui.instantiateImageCodec(
        bytes,
        targetWidth: targetSize,
        targetHeight: targetSize,
      );
      final frameInfo = await codec.getNextFrame();
      _loadedImage = frameInfo.image;
      _isLoading = false;
      _hasError = false;

      // Notify parent game
      onImageLoaded?.call();
    } catch (e) {
      debugPrint('Error loading cached image: $e');
      _isLoading = false;
      _hasError = true;
      _loadedImage = null;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Animate shimmer effect while loading
    if (_isLoading) {
      _shimmerOffset += dt * _shimmerSpeed;
      if (_shimmerOffset > 2.0) {
        _shimmerOffset = 0.0;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    if (_isLoading) {
      _renderShimmer(canvas);
      return;
    }

    if (_hasError || _loadedImage == null) {
      _renderError(canvas);
      return;
    }

    _renderImage(canvas);
  }

  void _renderShimmer(Canvas canvas) {
    final rect = size.toRect();

    // Base background
    final basePaint = Paint()..color = Colors.grey[200]!;
    canvas.drawRect(rect, basePaint);

    // Shimmer gradient
    final shimmerGradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Colors.grey[200]!,
        Colors.grey[100]!,
        Colors.white,
        Colors.grey[100]!,
        Colors.grey[200]!,
      ],
      stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
      transform: GradientRotation(_shimmerOffset * 3.14159),
    );

    final shimmerPaint = Paint()
      ..shader = shimmerGradient.createShader(rect);

    // Animate shimmer position
    canvas.save();
    final translateX = (rect.width + 100) * (_shimmerOffset - 0.5);
    canvas.translate(translateX, 0);
    canvas.drawRect(
      Rect.fromLTWH(-50, 0, rect.width + 100, rect.height),
      shimmerPaint,
    );
    canvas.restore();

    // Add a subtle border
    final borderPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRect(rect, borderPaint);
  }

  void _renderError(Canvas canvas) {
    final errorPaint = Paint()..color = Colors.grey[300]!;
    canvas.drawRect(size.toRect(), errorPaint);

    final iconSize = 24.0;
    final iconRect = Rect.fromCenter(
      center: Offset(size.x / 2, size.y / 2),
      width: iconSize,
      height: iconSize,
    );

    final iconPaint = Paint()..color = Colors.grey[600]!;
    canvas.drawRect(iconRect, iconPaint);
  }

  void _renderImage(Canvas canvas) {
    final srcRect = Rect.fromLTWH(
      0,
      0,
      _loadedImage!.width.toDouble(),
      _loadedImage!.height.toDouble(),
    );

    final dstRect = size.toRect();

    // Create RRect with selective corner radius
    RRect rrect;
    const radius = 16.0;

    if (cornerToRound == CornerRadius.none) {
      rrect = RRect.fromRectAndRadius(dstRect, Radius.zero);
    } else {
      rrect = RRect.fromRectAndCorners(
        dstRect,
        topLeft: cornerToRound == CornerRadius.topLeft
            ? Radius.circular(radius)
            : Radius.zero,
        topRight: cornerToRound == CornerRadius.topRight
            ? Radius.circular(radius)
            : Radius.zero,
        bottomLeft: cornerToRound == CornerRadius.bottomLeft
            ? Radius.circular(radius)
            : Radius.zero,
        bottomRight: cornerToRound == CornerRadius.bottomRight
            ? Radius.circular(radius)
            : Radius.zero,
      );
    }

    canvas.save();
    canvas.clipRRect(rrect);
    canvas.drawImageRect(
      _loadedImage!,
      srcRect,
      dstRect,
      Paint()..filterQuality = FilterQuality.medium,
    );
    canvas.restore();
  }

  @override
  void onRemove() {
    _loadedImage?.dispose();
    super.onRemove();
  }
}

/// Game to display placeholder images on all cells
class PlaceholderOverlayGame extends FlameGame {
  final int rows;
  final int columns;
  final double gridWidth;
  final double gridHeight;
  final double tileWidth;
  final double tileHeight;

  PlaceholderOverlayGame({
    required this.rows,
    required this.columns,
    required this.gridWidth,
    required this.gridHeight,
    required this.tileWidth,
    required this.tileHeight,
  });

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    images.prefix = '';
    camera.viewport = FixedResolutionViewport(
      resolution: Vector2(gridWidth, gridHeight),
    );

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < columns; col++) {
        final component = PlaceholderComponent(
          row: row,
          column: col,
          gridWidth: gridWidth,
          gridHeight: gridHeight,
          tileWidth: tileWidth,
          tileHeight: tileHeight,
        );
        add(component);
      }
    }
  }
}

/// Component to display placeholder image
class PlaceholderComponent extends PositionComponent with HasGameRef {
  final int row;
  final int column;
  final double gridWidth;
  final double gridHeight;
  final double tileWidth;
  final double tileHeight;

  Sprite? placeholderSprite;

  PlaceholderComponent({
    required this.row,
    required this.column,
    required this.gridWidth,
    required this.gridHeight,
    required this.tileWidth,
    required this.tileHeight,
  });

  @override
  Future<void> onLoad() async {
    final x = column * tileWidth + tileWidth / 2;
    final y = row * tileHeight + tileHeight / 2;

    position = Vector2(x, y);
    const scaleFactor = 0.6;

    const padding = 8.0;
    size = Vector2(
      (tileWidth - (padding * 2)) * scaleFactor,
      (tileHeight - (padding * 2)) * scaleFactor,
    );

    anchor = Anchor.center;

    try {
      final placeholderImage = await gameRef.images.load(
        'assets/png/place_holder_image_pictures_game.png',
      );
      placeholderSprite = Sprite(placeholderImage);
    } catch (e) {
      debugPrint('Error loading placeholder image: $e');
      placeholderSprite = null;
    }
  }

  @override
  void render(Canvas canvas) {
    if (placeholderSprite == null) {
      final fallbackPaint = Paint()..color = Colors.grey[300]!;
      canvas.drawRect(size.toRect(), fallbackPaint);
      return;
    }

    final dstRect = Rect.fromLTWH(0, 0, size.x, size.y);
    placeholderSprite!.renderRect(canvas, dstRect);
  }
}

/// Game to display selection highlight
class SelectionHighlightGame extends FlameGame {
  final int row;
  final int column;
  final double gridWidth;
  final double gridHeight;
  final double tileWidth;
  final double tileHeight;
  final Color highlightColor;

  SelectionHighlightGame({
    required this.row,
    required this.column,
    required this.gridWidth,
    required this.gridHeight,
    required this.tileWidth,
    required this.tileHeight,
    this.highlightColor = Colors.blue,
  });

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    images.prefix = '';
    camera.viewport = FixedResolutionViewport(
      resolution: Vector2(gridWidth, gridHeight),
    );

    final component = SelectionHighlightComponent(
      row: row,
      column: column,
      tileWidth: tileWidth,
      tileHeight: tileHeight,
      highlightColor: highlightColor,
    );
    add(component);
  }
}

/// Component to show selection highlight
class SelectionHighlightComponent extends PositionComponent {
  final int row;
  final int column;
  final double tileWidth;
  final double tileHeight;
  final Color highlightColor;

  SelectionHighlightComponent({
    required this.row,
    required this.column,
    required this.tileWidth,
    required this.tileHeight,
    required this.highlightColor,
  });

  @override
  Future<void> onLoad() async {
    final x = column * tileWidth + tileWidth / 2;
    final y = row * tileHeight + tileHeight / 2;

    position = Vector2(x, y);
    size = Vector2(tileWidth, tileHeight);
    anchor = Anchor.center;
  }

  @override
  void render(Canvas canvas) {
    final rect = size.toRect();

    final fillPaint = Paint()
      ..color = highlightColor.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    const padding = 8.0;
    final paddedRect = Rect.fromLTRB(
      rect.left + padding,
      rect.top + padding,
      rect.right - padding,
      rect.bottom - padding,
    );

    final rrect = RRect.fromRectAndRadius(
      paddedRect,
      const Radius.circular(8.0),
    );

    canvas.drawRRect(rrect, fillPaint);

    final borderPaint = Paint()
      ..color = highlightColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawRRect(rrect, borderPaint);
  }
}

/// Data class for picture positions
class PicturePosition {
  final int row;
  final int col;
  final String imageUrl;

  const PicturePosition({
    required this.row,
    required this.col,
    required this.imageUrl,
  });
}

/// Helper function
String imageLoaderUtility({required String image, required int sourceId}) {
  return image;
}