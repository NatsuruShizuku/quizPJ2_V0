
import 'dart:math';

import 'package:flutter/material.dart';

class FlipAnimation extends StatefulWidget {
  const FlipAnimation({
    required this.word,
    required this.animate,
    required this.reverse,
    required this.animationCompleted,
    required this.onFlipStateChanged,
    this.delay = 0,
    Key? key,
  }) : super(key: key);

  final Widget word;
  final bool animate;
  final bool reverse;
  final Function(bool) animationCompleted;
  final ValueChanged<bool> onFlipStateChanged;
  final int delay;

  @override
  State<FlipAnimation> createState() => _FlipAnimationState();
}

class _FlipAnimationState extends State<FlipAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFront = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )
      ..addListener(() {
        final isFront = _controller.value >= 0.5;
        if (isFront != _isFront) {
          _isFront = isFront;
          widget.onFlipStateChanged(_isFront);
        }
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.animationCompleted(true);
        }
        if (status == AnimationStatus.dismissed) {
          widget.animationCompleted(false);
        }
      });

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }
@override
void didUpdateWidget(covariant FlipAnimation oldWidget) {
  if (widget.animate != oldWidget.animate || widget.reverse != oldWidget.reverse) {
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted && widget.animate) {
        if (widget.reverse) {
          if (_controller.status != AnimationStatus.dismissed) {
            _controller.reverse();
          }
        } else {
          if (_controller.status != AnimationStatus.completed) {
            _controller.forward();
          }
        }
      }
    });
  }
  super.didUpdateWidget(oldWidget);
}

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..rotateY(_animation.value * pi)
          ..setEntry(3, 2, 0.005),

        child: _controller.value >= 0.50
    ? Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(pi),
        child: widget.word,
      )
    : 

    Container(
  decoration: BoxDecoration(
    image: DecorationImage(
      image: AssetImage("assets/images/starcard.png"),
      fit: BoxFit.cover,
    ),
    borderRadius: BorderRadius.circular(8),
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 6,
        offset: Offset(0, 3),
      ),
    ],
  ),
)
      ),
    );
  }
}