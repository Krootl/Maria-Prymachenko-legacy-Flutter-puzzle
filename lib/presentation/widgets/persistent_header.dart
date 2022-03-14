import 'package:flutter/widgets.dart';

class PersistentHeader extends SliverPersistentHeaderDelegate {
  const PersistentHeader({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => child;

  @override
  double get maxExtent => 209;

  @override
  double get minExtent => 209;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
