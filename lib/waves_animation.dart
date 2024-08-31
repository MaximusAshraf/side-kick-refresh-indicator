import 'package:flutter/material.dart';

class ColorWaveShimmer extends StatefulWidget {
  final List<Color> colors;
  final Widget child;
  final Duration? duration;
  final Curve? curve;
  final bool isRepeating;
  const ColorWaveShimmer({
    required this.colors,
    required this.child,
    this.duration,
    this.curve,
    this.isRepeating = true,
    super.key,
  });

  @override
  State<ColorWaveShimmer> createState() => _ColorWaveShimmerState();
}

class _ColorWaveShimmerState extends State<ColorWaveShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  _updateAnimation() {
    if (widget.isRepeating) {
      _controller.repeat();
    } else {
      _controller.forward();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration ??
          Duration(seconds: widget.colors.length.clamp(1, 3)),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve ?? Curves.linear, // Choose the curve you want
      ),
    );
  }

  @override
  void didUpdateWidget(covariant ColorWaveShimmer oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spots = List<double>.generate(widget.colors.length, (index) {
      return index / (widget.colors.length - 1);
    });
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: widget.colors,
              stops: spots,
              begin: Alignment(-1 + 4 * _animation.value, 0),
              end: Alignment(1 + 4 * _animation.value, 0),
              tileMode: TileMode.mirror, // Repeat the gradient
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcIn,
          child: widget.child,
        );
      },
      child: widget.child,
    );
  }
}
