import 'dart:math' as math show sin, pi;

import 'package:flutter/material.dart';

enum WaveLoaderType { start, end, center }

class WaveLoader extends StatefulWidget {
  const WaveLoader({
    Key? key,
    this.color,
    this.type = WaveLoaderType.start,
    this.size = const Size(32, 8),
    this.itemCount = 5,
    this.duration = const Duration(milliseconds: 800),
    this.controller,
  })  : assert(itemCount >= 2, 'itemCount Cant be less then 2 '),
        super(key: key);

  final Color? color;
  final int itemCount;
  final Size size;
  final WaveLoaderType type;
  final Duration duration;
  final AnimationController? controller;

  @override
  _WaveLoaderState createState() => _WaveLoaderState();
}

class _WaveLoaderState extends State<WaveLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = (widget.controller ?? AnimationController(vsync: this, duration: widget.duration))
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<double> _bars = getAnimationDelay(widget.itemCount);
    return SizedBox.fromSize(
      size: widget.size,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
            _bars.length,
            (i) => ScaleYWidget(
                  scaleY: DelayTween(begin: .4, end: 1.0, delay: _bars[i]).animate(_controller),
                  child: SizedBox.fromSize(
                    size: Size(widget.size.width / widget.itemCount - 1, widget.size.height),
                    child: _itemBuilder(i),
                  ),
                )),
      ),
    );
  }

  List<double> getAnimationDelay(int itemCount) {
    switch (widget.type) {
      case WaveLoaderType.start:
        return _startAnimationDelay(itemCount);
      case WaveLoaderType.end:
        return _endAnimationDelay(itemCount);
      case WaveLoaderType.center:
      default:
        return _centerAnimationDelay(itemCount);
    }
  }

  List<double> _startAnimationDelay(int count) => <double>[
        ...List<double>.generate(count ~/ 2, (index) => -1.0 - (index * 0.1) - 0.1).reversed,
        if (count.isOdd) -1.0,
        ...List<double>.generate(
          count ~/ 2,
          (index) => -1.0 + (index * 0.1) + (count.isOdd ? 0.1 : 0.0),
        ),
      ];

  List<double> _endAnimationDelay(int count) => <double>[
        ...List<double>.generate(count ~/ 2, (index) => -1.0 + (index * 0.1) + 0.1).reversed,
        if (count.isOdd) -1.0,
        ...List<double>.generate(
          count ~/ 2,
          (index) => -1.0 - (index * 0.1) - (count.isOdd ? 0.1 : 0.0),
        ),
      ];

  List<double> _centerAnimationDelay(int count) => <double>[
        ...List<double>.generate(count ~/ 2, (index) => -1.0 + (index * 0.2) + 0.2).reversed,
        if (count.isOdd) -1.0,
        ...List<double>.generate(count ~/ 2, (index) => -1.0 + (index * 0.2) + 0.2),
      ];

  Widget _itemBuilder(int index) =>
      DecoratedBox(decoration: BoxDecoration(color: widget.color ?? Colors.grey));
}

class ScaleYWidget extends AnimatedWidget {
  const ScaleYWidget({
    Key? key,
    required Animation<double> scaleY,
    required this.child,
    this.alignment = Alignment.center,
  }) : super(key: key, listenable: scaleY);

  final Widget child;
  final Alignment alignment;

  Animation<double> get scale => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) => Transform(
      transform: Matrix4.identity()..scale(1.0, scale.value, 1.0),
      alignment: alignment,
      child: child);
}

class DelayTween extends Tween<double> {
  DelayTween({double? begin, double? end, required this.delay}) : super(begin: begin, end: end);

  final double delay;

  @override
  double lerp(double t) => super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}
