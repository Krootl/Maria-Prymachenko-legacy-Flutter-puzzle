import 'package:flutter/widgets.dart';
import 'package:very_good_slide_puzzle/presentation/enums/layout_size.dart';

typedef ResponsiveLayoutWidgetBuilder = Widget Function(BuildContext, Widget?);

class ResponsiveLayoutBuilder extends StatelessWidget {
  const ResponsiveLayoutBuilder({
    Key? key,
    required this.extraSmall,
    required this.small,
    required this.medium,
    required this.large,
    this.child,
  }) : super(key: key);

  final ResponsiveLayoutWidgetBuilder extraSmall;
  final ResponsiveLayoutWidgetBuilder small;
  final ResponsiveLayoutWidgetBuilder medium;
  final ResponsiveLayoutWidgetBuilder large;

  /// Optional child widget builder based on the current layout size
  /// which will be passed to the `small`, `medium` and `large` builders
  /// as a way to share/optimize shared layout.
  final Widget Function(LayoutSize currentSize)? child;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = MediaQuery.of(context).size.width;
          if (screenWidth <= PuzzleBreakpoints.extraSmall) {
            return extraSmall(context, child?.call(LayoutSize.extraSmall));
          }
          if (screenWidth <= PuzzleBreakpoints.small) {
            return small(context, child?.call(LayoutSize.small));
          }
          if (screenWidth <= PuzzleBreakpoints.medium) {
            return medium(context, child?.call(LayoutSize.medium));
          }
          if (screenWidth <= PuzzleBreakpoints.large) {
            return large(context, child?.call(LayoutSize.large));
          }

          return large(context, child?.call(LayoutSize.large));
        },
      );
}

abstract class PuzzleBreakpoints {
  static const double extraSmall = 320;
  static const double small = 576;
  static const double medium = 1200;
  static const double large = 1440;
}
