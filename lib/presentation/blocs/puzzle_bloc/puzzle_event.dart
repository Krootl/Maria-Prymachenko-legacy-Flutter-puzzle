import 'package:equatable/equatable.dart';
import 'package:very_good_slide_puzzle/presentation/models/tile.dart';

abstract class PuzzleEvent extends Equatable {
  const PuzzleEvent();

  @override
  List<Object> get props => [];
}

class CreatePuzzle extends PuzzleEvent {
  const CreatePuzzle({
    required this.imagePath,
  });

  final String imagePath;
}

class SplitPuzzle extends PuzzleEvent {}

class ShufflePuzzle extends PuzzleEvent {}

class StartPuzzle extends PuzzleEvent {}

class ShowArtPuzzle extends PuzzleEvent {}

class ShowSimplePuzzle extends PuzzleEvent {}

class ShowTileNumber extends PuzzleEvent {}

class HideTileNumber extends PuzzleEvent {}

class TapTile extends PuzzleEvent {
  const TapTile({
    required this.tile,
  });

  final Tile tile;

  @override
  List<Object> get props => [tile];
}

class DragTile extends PuzzleEvent {
  const DragTile({
    required this.tile,
    required this.isDrag,
    required this.dragTiles,
    required this.dragPower,
    required this.isHorizontal,
  });

  final Tile tile;
  final bool isDrag;
  final List<Tile> dragTiles;
  final double dragPower;
  final bool isHorizontal;

  @override
  List<Object> get props => [
        tile,
        isDrag,
        dragTiles,
        dragPower,
        isHorizontal,
      ];
}

class RestartPuzzle extends PuzzleEvent {
  const RestartPuzzle();
}
