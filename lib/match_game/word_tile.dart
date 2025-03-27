

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_application_0/match_game/animation/flip_animation.dart';
import 'package:flutter_application_0/match_game/animation/matched_animation.dart';
import 'package:flutter_application_0/match_game/animation/spin_animation.dart';
import 'package:flutter_application_0/match_game/manager/game_manager.dart';
import 'package:flutter_application_0/match_game/models/word.dart';
import 'package:provider/provider.dart';

class WordTile extends StatefulWidget {
  const WordTile({
    required this.index,
    required this.word,
    required this.isMatched,
    Key? key,
  }) : super(key: key);

  final int index;
  final Word word;
  final bool isMatched;

  @override
  State<WordTile> createState() => _WordTileState();
}

class _WordTileState extends State<WordTile> {
  bool _isCardFlipped = false;

  @override
  Widget build(BuildContext context) {
    return SpinAnimation(
      key: ValueKey<int>(widget.index),
      child: Consumer<GameManager>(
        builder: (_, notifier, __) {
          if (widget.isMatched) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Icon(
                  Icons.check,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            );
          }

          bool animate = checkAnimationRun(notifier);

          return GestureDetector(
            onTap: () {
              if (!notifier.ignoreTaps &&
                  !notifier.answeredWords.contains(widget.index) &&
                  !notifier.tappedWords.containsKey(widget.index)) {
                notifier.tileTapped(index: widget.index, word: widget.word);
              }
            },
            onDoubleTap: () {
                if( widget.word.contents.isNotEmpty &&
                  _isCardFlipped) {
                _showFullImage(context, widget.word.contents);
              }
            },
            child: FlipAnimation(
              word: MatchedAnimation(
                numberOfWordsAnswered: notifier.answeredWords.length,
                animate: notifier.answeredWords.contains(widget.index),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: _buildImage(),
                ),
              ),
              animate: animate,
              reverse: notifier.reverseFlip,
              animationCompleted: (isForward) {
                notifier.onAnimationCompleted(isForward: isForward);
              },
              onFlipStateChanged: (isFront) {
                setState(() {
                  _isCardFlipped = isFront;
                });
              },
            ),
          );
        },
      ),
    );
  }

  void _showFullImage(BuildContext context, List<int> imageBytes) {
    showDialog(
      context: context,
      builder: (context) => ImageDialog(imageBytes: imageBytes),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Image.memory(
          Uint8List.fromList(widget.word.contents),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  bool checkAnimationRun(GameManager notifier) {
    bool animate = false;
    if (notifier.canFlip) {
      if (notifier.tappedWords.isNotEmpty &&
          notifier.tappedWords.keys.last == widget.index) {
        animate = true;
      }
      if (notifier.reverseFlip && !notifier.answeredWords.contains(widget.index)) {
        animate = true;
      }
    }
    return animate;
  }
}

class ImageDialog extends StatelessWidget {
  final List<int> imageBytes;
  const ImageDialog({super.key, required this.imageBytes});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 4.0,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: MemoryImage(Uint8List.fromList(imageBytes)),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}