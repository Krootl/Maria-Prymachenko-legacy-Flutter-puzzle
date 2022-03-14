import 'package:flutter/widgets.dart';
import 'package:very_good_slide_puzzle/presentation/enums/puzzle_lifecycle.dart';
import 'package:very_good_slide_puzzle/presentation/models/puzzle.dart';
import 'package:very_good_slide_puzzle/presentation/models/tile.dart';

enum PuzzleStatus { incomplete, complete }

enum TileMovementStatus { nothingTapped, cannotBeMoved, moved }

class PuzzleState {
  const PuzzleState({
    this.puzzle = const Puzzle(tiles: []),
    this.draggablePuzzles = const Puzzle(tiles: []),
    this.puzzleStatus = PuzzleStatus.incomplete,
    this.tileMovementStatus = TileMovementStatus.nothingTapped,
    this.numberOfCorrectTiles = 0,
    this.numberOfMoves = 0,
    this.lastTappedTile,
    this.images = const [],
    this.puzzleLifecycle = PuzzleLifecycle.onCreate,
    this.hasArtPuzzle = true,
    this.isDrag = false,
    this.showTileNumber = false,
  });

  final Puzzle puzzle;

  final Puzzle draggablePuzzles;

  final PuzzleStatus puzzleStatus;

  final PuzzleLifecycle puzzleLifecycle;

  final TileMovementStatus tileMovementStatus;

  final Tile? lastTappedTile;

  final int numberOfCorrectTiles;

  int get numberOfTilesLeft => puzzle.tiles.length - numberOfCorrectTiles - 1;

  final int numberOfMoves;

  final List<MemoryImage> images;

  final bool hasArtPuzzle;

  final bool isDrag;

  final bool showTileNumber;

  PuzzleState copyWith({
    Puzzle? puzzle,
    Puzzle? draggablePuzzles,
    PuzzleStatus? puzzleStatus,
    TileMovementStatus? tileMovementStatus,
    int? numberOfCorrectTiles,
    int? numberOfMoves,
    Tile? lastTappedTile,
    List<MemoryImage>? images,
    PuzzleLifecycle? puzzleLifecycle,
    bool? hasArtPuzzle,
    bool? isDrag,
    bool? showTileNumber,
  }) =>
      PuzzleState(
        puzzle: puzzle ?? this.puzzle,
        draggablePuzzles: draggablePuzzles ?? this.draggablePuzzles,
        puzzleStatus: puzzleStatus ?? this.puzzleStatus,
        tileMovementStatus: tileMovementStatus ?? this.tileMovementStatus,
        numberOfCorrectTiles: numberOfCorrectTiles ?? this.numberOfCorrectTiles,
        numberOfMoves: numberOfMoves ?? this.numberOfMoves,
        lastTappedTile: lastTappedTile ?? this.lastTappedTile,
        images: images ?? this.images,
        puzzleLifecycle: puzzleLifecycle ?? this.puzzleLifecycle,
        hasArtPuzzle: hasArtPuzzle ?? this.hasArtPuzzle,
        isDrag: isDrag ?? this.isDrag,
        showTileNumber: showTileNumber ?? this.showTileNumber,
      );
}
