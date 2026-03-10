import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../locale/localization_manager.dart';

enum TtsButtonSize { small, medium, large }

class TextToSpeechButton extends ConsumerStatefulWidget {
  final List<String> texts;
  final TtsButtonSize size;
  final bool isDarkTheme;

  const TextToSpeechButton({
    super.key,
    required this.texts,
    this.size = TtsButtonSize.medium,
    this.isDarkTheme = false
  });

  @override
  ConsumerState<TextToSpeechButton> createState() => _TextToSpeechButtonState();
}

class _TextToSpeechButtonState extends ConsumerState<TextToSpeechButton>
    with SingleTickerProviderStateMixin {
  final FlutterTts _flutterTts = FlutterTts();

  bool _isPlaying = false;
  bool _isPaused = false;

  late AnimationController _controller;
  late Animation<double> _animation;

  double get _buttonSize {
    switch (widget.size) {
      case TtsButtonSize.small:
        return 26;
      case TtsButtonSize.medium:
        return 35;
      case TtsButtonSize.large:
        return 46;
    }
  }

  double get _iconSize {
    switch (widget.size) {
      case TtsButtonSize.small:
        return 14;
      case TtsButtonSize.medium:
        return 20;
      case TtsButtonSize.large:
        return 26;
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _animation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _initTts();
  }

  // void _initTts() {
  //   _flutterTts.setCompletionHandler(() {
  //     if (mounted) {
  //       _controller.stop();
  //       setState(() {
  //         _isPlaying = false;
  //         _isPaused = false;
  //       });
  //     }
  //   });
  //
  //   _flutterTts.setSpeechRate(0.5);
  // }

  void _initTts() {
    void resetState() {
      if (!mounted) return;

      _controller.stop();

      setState(() {
        _isPlaying = false;
        _isPaused = false;
      });
    }

    _flutterTts.setCompletionHandler(() {
      resetState();
    });

    _flutterTts.setCancelHandler(() {
      resetState();
    });

    _flutterTts.setErrorHandler((message) {
      resetState();
    });

    _flutterTts.setSpeechRate(0.5);
  }

  Future<void> _play() async {
    final locale = ref.watch(localeManagerProvider).currentLocale;

    await _flutterTts.setLanguage(locale.toLanguageTag());

    final combinedText =
    widget.texts.where((e) => e.trim().isNotEmpty).join(". ");

    await _flutterTts.speak(combinedText);

    _controller.repeat(reverse: true);

    setState(() {
      _isPlaying = true;
      _isPaused = false;
    });
  }

  Future<void> _pause() async {
    await _flutterTts.pause();
    _controller.stop();

    setState(() {
      _isPaused = true;
    });
  }

  Future<void> _resume() async {
    final combinedText =
    widget.texts.where((e) => e.trim().isNotEmpty).join(". ");

    await _flutterTts.speak(combinedText);

    _controller.repeat(reverse: true);

    setState(() {
      _isPaused = false;
      _isPlaying = true;
    });
  }

  Future<void> _stop() async {
    await _flutterTts.stop();
    _controller.stop();

    setState(() {
      _isPlaying = false;
      _isPaused = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.isDarkTheme
        ? Theme.of(context).canvasColor
        : Theme.of(context).colorScheme.primary;

    return Row(
      key: ValueKey(_isPlaying),
      mainAxisSize: MainAxisSize.min,
      children: [
        /// PLAY / STOP
        GestureDetector(
          onTap: () {
            if (_isPlaying) {
              _stop();
            } else {
              _play();
            }
          },
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _isPlaying ? _animation.value : 1,
                child: Container(
                  height: _buttonSize,
                  width: _buttonSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor.withOpacity(0.1),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    _isPlaying ? Icons.stop : Icons.volume_up,
                    color: primaryColor,
                    size: _iconSize,
                  ),
                ),
              );
            },
          ),
        ),

        /// PAUSE / RESUME
        if (_isPlaying) ...[
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              if (_isPaused) {
                _resume();
              } else {
                _pause();
              }
            },
            child: Container(
              height: _buttonSize,
              width: _buttonSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withOpacity(0.1),
              ),
              child: Icon(
                _isPaused ? Icons.play_arrow : Icons.pause,
                color: primaryColor,
                size: _iconSize,
              ),
            ),
          ),
        ],
      ],
    );
  }
}