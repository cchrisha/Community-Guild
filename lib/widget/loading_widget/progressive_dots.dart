import 'package:community_guild/widget/loading_widget/util/animation_controller_utils.dart';
import 'package:flutter/material.dart';
import 'widgets/draw_dot.dart';

class ProgressiveDots extends StatefulWidget {
  final double size;
  final Color color;

  const ProgressiveDots({
    Key? key,
    required this.color,
    required this.size,
  }) : super(key: key);

  @override
  _ProgressiveDotsState createState() => _ProgressiveDotsState();
}

class _ProgressiveDotsState extends State<ProgressiveDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 800,
      ),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = widget.color;
    final double size = widget.size;
    final double dotSize = size * 0.17;
    final double negativeSpace = size - (4 * dotSize);
    final double gapBetweenDots = negativeSpace / 3;
    final double previousDotPosition = -(gapBetweenDots + dotSize);

    Widget translatingDot() => Transform.translate(
          offset: _animationController.eval(
            Tween<Offset>(
              begin: Offset.zero,
              end: Offset(previousDotPosition, 0),
            ),
            curve: const Interval(0.22, 0.82),
          ),
          child: DrawDot.circular(
            dotSize: dotSize,
            color: color,
          ),
        );

    Widget scalingDot(bool scaleDown, Interval interval) => Transform.scale(
          scale: _animationController.eval(
            Tween<double>(
              begin: scaleDown ? 1.0 : 0.0,
              end: scaleDown ? 0.0 : 1.0,
            ),
            curve: interval,
          ),
          child: DrawDot.circular(
            dotSize: dotSize,
            color: color,
          ),
        );

    return SizedBox(
      width: size,
      height: size,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (_, __) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              scalingDot(
                true,
                const Interval(
                  0.0,
                  0.4,
                ),
              ),
              translatingDot(),
              translatingDot(),
              Stack(
                children: <Widget>[
                  scalingDot(
                    false,
                    const Interval(
                      0.3,
                      0.7,
                    ),
                  ),
                  translatingDot(),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
