import 'package:flutter/material.dart';
import 'package:very_good_slide_puzzle/presentation/widgets/shimmer/shimmer_loading.dart';

class ShimmerLoadingItem extends StatefulWidget {
  const ShimmerLoadingItem({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _ShimmerLoadingItemState createState() => _ShimmerLoadingItemState();
}

class _ShimmerLoadingItemState extends State<ShimmerLoadingItem> {
  Listenable? _shimmerChanges;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_shimmerChanges != null) {
      _shimmerChanges!.removeListener(_onShimmerChange);
    }
    _shimmerChanges = ShimmerLoading.of(context)?.shimmerChanges;
    if (_shimmerChanges != null) {
      _shimmerChanges!.addListener(_onShimmerChange);
    }
  }

  @override
  void dispose() {
    _shimmerChanges?.removeListener(_onShimmerChange);
    super.dispose();
  }

  void _onShimmerChange() {
    setState(() {
      // update the shimmer painting.
    });
  }

  @override
  Widget build(BuildContext context) {
    // Collect ancestor shimmer info.
    final shimmer = ShimmerLoading.of(context)!;
    if (!shimmer.isSized) {
      // The ancestor Shimmer widget has not laid
      // itself out yet. Return an empty box.
      return const SizedBox();
    }
    final shimmerSize = shimmer.size;
    final gradient = shimmer.gradient;

    if (context.findRenderObject() == null) return const SizedBox();

    final offsetWithinShimmer = shimmer.getDescendantOffset(
      descendant: context.findRenderObject() as RenderBox,
    );

    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(
          -offsetWithinShimmer.dx,
          -offsetWithinShimmer.dy,
          shimmerSize.width,
          shimmerSize.height,
        ),
      ),
      child: widget.child,
    );
  }
}
