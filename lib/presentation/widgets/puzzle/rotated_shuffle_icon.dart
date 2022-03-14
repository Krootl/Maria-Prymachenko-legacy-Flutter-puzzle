import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:very_good_slide_puzzle/presentation/blocs/puzzle_bloc/bloc.dart';
import 'package:very_good_slide_puzzle/presentation/blocs/theme_bloc/bloc.dart';
import 'package:very_good_slide_puzzle/presentation/enums/puzzle_lifecycle.dart';

class RotatedShuffleIcon extends StatefulWidget {
  const RotatedShuffleIcon({
    Key? key,
    required PuzzleLifecycle puzzleLifecycle,
  })  : _puzzleLifecycle = puzzleLifecycle,
        super(key: key);

  final PuzzleLifecycle _puzzleLifecycle;

  @override
  _RotatedShuffleIconState createState() => _RotatedShuffleIconState();
}

class _RotatedShuffleIconState extends State<RotatedShuffleIcon> with SingleTickerProviderStateMixin {
  late final _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  @override
  void initState() {
    super.initState();
    if (widget._puzzleLifecycle == PuzzleLifecycle.onShuffle) {
      _animationController.forward().then(
            (_) => BlocProvider.of<PuzzleBloc>(context).add(StartPuzzle()),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = BlocProvider.of<ThemeBloc>(context).state.currentPuzzleTheme;
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) => Transform.rotate(
        angle: _animationController.value * 6.3,
        child: child,
      ),
      child: SvgPicture.asset(theme.shuffleAsset),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
