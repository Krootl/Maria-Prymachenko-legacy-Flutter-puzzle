import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:very_good_slide_puzzle/presentation/blocs/puzzle_bloc/bloc.dart';
import 'package:very_good_slide_puzzle/presentation/blocs/theme_bloc/bloc.dart';
import 'package:very_good_slide_puzzle/presentation/enums/puzzle_lifecycle.dart';
import 'package:very_good_slide_puzzle/presentation/widgets/puzzle/rotated_shuffle_icon.dart';

class PuzzleActionButton extends StatefulWidget {
  const PuzzleActionButton({
    Key? key,
    required PuzzleLifecycle puzzleLifecycle,
  })  : _puzzleLifecycle = puzzleLifecycle,
        super(key: key);

  final PuzzleLifecycle _puzzleLifecycle;

  @override
  State<PuzzleActionButton> createState() => _PuzzleActionButtonState();
}

class _PuzzleActionButtonState extends State<PuzzleActionButton> {
  @override
  Widget build(BuildContext context) {
    final theme = BlocProvider.of<ThemeBloc>(context).state.currentPuzzleTheme;
    return ElevatedButton(
      //TODO: implement style
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          primary: widget._puzzleLifecycle.getActionButtonColor(theme: theme)),

      onPressed: () {
        if (widget._puzzleLifecycle == PuzzleLifecycle.onShuffle) return;
        if (widget._puzzleLifecycle == PuzzleLifecycle.onCreate) {
          BlocProvider.of<PuzzleBloc>(context).add(SplitPuzzle());
        } else if (widget._puzzleLifecycle == PuzzleLifecycle.onStart) {
          BlocProvider.of<PuzzleBloc>(context).add(ShufflePuzzle());
        } else if (widget._puzzleLifecycle == PuzzleLifecycle.onRunning) {
          BlocProvider.of<PuzzleBloc>(context).add(const RestartPuzzle());
        }
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Row(
          key: ValueKey(widget._puzzleLifecycle),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget._puzzleLifecycle == PuzzleLifecycle.onStart ||
                widget._puzzleLifecycle == PuzzleLifecycle.onShuffle) ...[
              RotatedShuffleIcon(puzzleLifecycle: widget._puzzleLifecycle),
              const SizedBox(width: 8),
            ],
            Text(
              widget._puzzleLifecycle.getActionButtonTitle(context),
              style:
                  TextStyle(color: widget._puzzleLifecycle.getActionButtonTitleColor(theme: theme)),
            ),
          ],
        ),
      ),
    );
  }
}
