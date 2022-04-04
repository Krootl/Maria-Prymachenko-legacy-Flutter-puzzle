import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:very_good_slide_puzzle/presentation/blocs/puzzle_bloc/bloc.dart';
import 'package:very_good_slide_puzzle/presentation/models/tile.dart';
import 'package:very_good_slide_puzzle/presentation/widgets/puzzle/puzzle_tile.dart';
import 'package:very_good_slide_puzzle/presentation/widgets/response_layout_builder.dart';

abstract class BoardSize {
  static double extraSmall = 250;
  static double small = 340;
  static double medium = 424;
  static double large = 472;
}

class PuzzleBoard extends StatefulWidget {
  const PuzzleBoard({
    Key? key,
    required this.tiles,
    required this.puzzleState,
    required this.hasArt,
    required this.showTileNumber,
  }) : super(key: key);

  final List<Tile> tiles;
  final PuzzleState puzzleState;
  final bool hasArt;
  final bool showTileNumber;

  @override
  State<PuzzleBoard> createState() => _PuzzleBoardState();
}

class _PuzzleBoardState extends State<PuzzleBoard> {
  Timer? _completePuzzleTimer;

  @override
  void dispose() {
    _completePuzzleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ResponsiveLayoutBuilder(
        extraSmall: (_, child) => SizedBox.square(
          key: const Key('puzzle_board_small'),
          dimension: BoardSize.extraSmall,
          child: child,
        ),
        small: (_, child) => SizedBox.square(
          key: const Key('puzzle_board_small'),
          dimension: BoardSize.small,
          child: child,
        ),
        medium: (_, child) => SizedBox.square(
          key: const Key('puzzle_board_medium'),
          dimension: BoardSize.medium,
          child: child,
        ),
        large: (_, child) => SizedBox.square(
          key: const Key('puzzle_board_large'),
          dimension: BoardSize.large,
          child: child,
        ),
        child: (layout) => Stack(
          children: widget.tiles
              .map(
                (tile) => PuzzleTile(
                  key: Key('puzzle_tile_${tile.value.toString()}'),
                  tile: tile,
                  image: widget.puzzleState.images[tile.value - 1],
                  puzzleState: widget.puzzleState,
                  hasArt: widget.hasArt,
                  layout: layout,
                  showTileNumber: widget.showTileNumber,
                ),
              )
              .toList(),
        ),
      );
}
