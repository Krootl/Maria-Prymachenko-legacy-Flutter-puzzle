import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_slide_puzzle/presentation/blocs/puzzle_bloc/bloc.dart';
import 'package:very_good_slide_puzzle/presentation/enums/puzzle_lifecycle.dart';
import 'package:very_good_slide_puzzle/presentation/models/position.dart';
import 'package:very_good_slide_puzzle/presentation/models/puzzle.dart';
import 'package:very_good_slide_puzzle/presentation/models/tile.dart';
import 'package:image/image.dart' as imglib;
import 'package:very_good_slide_puzzle/presentation/utils/image_utils.dart';

class PuzzleBloc extends Bloc<PuzzleEvent, PuzzleState> {
  PuzzleBloc(this._size, {this.random}) : super(const PuzzleState()) {
    on<CreatePuzzle>(_onCreatePuzzle);
    on<SplitPuzzle>(_onSplitPuzzle);
    on<ShufflePuzzle>(_onShufflePuzzle);
    on<StartPuzzle>(_onStartPuzzle);
    on<TapTile>(_onTapTile);
    on<DragTile>(_onDragTile);
    on<RestartPuzzle>(_onRestartPuzzle);
    on<ShowArtPuzzle>(_onShowArtPuzzle);
    on<ShowSimplePuzzle>(_onShowSimplePuzzle);
    on<ShowTileNumber>(_onShowTileNumber);
    on<HideTileNumber>(_onHideTileNumber);
  }
  final double _size;

  final Random? random;

  final _correctPositions = <Position>[];
  final _currentPositions = <Position>[];

  void _onCreatePuzzle(
    CreatePuzzle event,
    Emitter<PuzzleState> emit,
  ) async {
    final images = await _splitImage(imagePath: event.imagePath) ?? [];
    final puzzle = _generatePuzzle(size: _size);
    emit(
      PuzzleState(
        puzzle: puzzle.sort(),
        numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
        images: images,
        puzzleLifecycle: PuzzleLifecycle.onCreate,
      ),
    );
  }

  void _onSplitPuzzle(
    SplitPuzzle event,
    Emitter<PuzzleState> emit,
  ) async {
    emit(state.copyWith(
      puzzleLifecycle: PuzzleLifecycle.onStart,
    ));
  }

  void _onShufflePuzzle(ShufflePuzzle event, Emitter<PuzzleState> emit) {
    final shuffledPuzzle = _shufflePuzzle(generatePuzzle: state.puzzle);
    emit(state.copyWith(
      puzzle: shuffledPuzzle,
      puzzleLifecycle: PuzzleLifecycle.onShuffle,
      numberOfCorrectTiles: shuffledPuzzle.getNumberOfCorrectTiles(),
      isDrag: false,
    ));
  }

  void _onStartPuzzle(StartPuzzle event, Emitter<PuzzleState> emit) {
    emit(state.copyWith(
      puzzleLifecycle: PuzzleLifecycle.onRunning,
      numberOfCorrectTiles: 0,
    ));
  }

  void _onTapTile(TapTile event, Emitter<PuzzleState> emit) {
    final tappedTile = event.tile;
    if (state.puzzleStatus == PuzzleStatus.incomplete) {
      if (state.puzzle.isTileMovable(tappedTile)) {
        final mutablePuzzle = Puzzle(tiles: [...state.puzzle.tiles]);
        final puzzle = mutablePuzzle.moveTiles(tile: tappedTile, tilesToSwap: []);
        if (puzzle.isComplete()) {
          emit(
            state.copyWith(
              puzzle: puzzle.sort(),
              puzzleStatus: PuzzleStatus.complete,
              tileMovementStatus: TileMovementStatus.moved,
              numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
              numberOfMoves: state.numberOfMoves + 1,
              lastTappedTile: tappedTile,
              isDrag: false,
            ),
          );
        } else {
          emit(
            state.copyWith(
              puzzle: puzzle.sort(),
              tileMovementStatus: TileMovementStatus.moved,
              numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
              numberOfMoves: state.numberOfMoves + 1,
              lastTappedTile: tappedTile,
              isDrag: false,
            ),
          );
        }
      } else {
        emit(
          state.copyWith(tileMovementStatus: TileMovementStatus.cannotBeMoved),
        );
      }
    } else {
      emit(
        state.copyWith(tileMovementStatus: TileMovementStatus.cannotBeMoved),
      );
    }
  }

  void _onDragTile(DragTile event, Emitter<PuzzleState> emit) {
    final draggedTile = event.tile;
    final isDrag = event.isDrag;
    if (state.puzzleStatus == PuzzleStatus.incomplete) {
      if (state.puzzle.isTileMovable(draggedTile)) {
        final mutablePuzzle = Puzzle(tiles: [...state.puzzle.tiles]);
        final puzzle = mutablePuzzle.moveTiles(
          tile: draggedTile,
          tilesToSwap: [],
          dragPower: event.dragPower,
          isHorizontal: event.isHorizontal,
          isDrag: true,
        );
        if (puzzle.isComplete()) {
          emit(
            state.copyWith(
              puzzle: isDrag ? state.puzzle.sort() : puzzle.sort(),
              draggablePuzzles: puzzle.sort(),
              puzzleStatus: PuzzleStatus.complete,
              tileMovementStatus: TileMovementStatus.moved,
              numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
              numberOfMoves: isDrag ? state.numberOfMoves : state.numberOfMoves + 1,
              lastTappedTile: draggedTile,
            ),
          );
        } else {
          emit(
            state.copyWith(
              puzzle: isDrag ? state.puzzle.sort() : puzzle.sort(),
              draggablePuzzles: puzzle.sort(),
              tileMovementStatus: TileMovementStatus.moved,
              numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
              numberOfMoves: isDrag ? state.numberOfMoves : state.numberOfMoves + 1,
              isDrag: isDrag,
              lastTappedTile: draggedTile,
            ),
          );
        }
      } else {
        emit(
          state.copyWith(tileMovementStatus: TileMovementStatus.cannotBeMoved),
        );
      }
    } else {
      emit(
        state.copyWith(tileMovementStatus: TileMovementStatus.cannotBeMoved),
      );
    }
  }

  void _onShowArtPuzzle(ShowArtPuzzle event, Emitter<PuzzleState> emit) {
    emit(state.copyWith(hasArtPuzzle: true));
  }

  void _onShowSimplePuzzle(ShowSimplePuzzle event, Emitter<PuzzleState> emit) {
    emit(state.copyWith(hasArtPuzzle: false));
  }

  void _onShowTileNumber(ShowTileNumber event, Emitter<PuzzleState> emit) {
    emit(state.copyWith(showTileNumber: true));
  }

  void _onHideTileNumber(HideTileNumber event, Emitter<PuzzleState> emit) {
    emit(state.copyWith(showTileNumber: false));
  }

  void _onRestartPuzzle(RestartPuzzle event, Emitter<PuzzleState> emit) {
    final puzzle = _generatePuzzle(size: _size);
    emit(state.copyWith(
        puzzle: puzzle.sort(),
        numberOfMoves: 0,
        numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
        puzzleLifecycle: PuzzleLifecycle.onCreate));
  }

  /// Build a randomized, solvable puzzle of the given size.
  Puzzle _generatePuzzle({required double size}) {
    _correctPositions.clear();
    _currentPositions.clear();
    final whitespacePosition = Position(x: size, y: size);

    // Create all possible board positions.
    for (double y = 1; y <= size; y++) {
      for (double x = 1; x <= size; x++) {
        if (x == size && y == size) {
          _correctPositions.add(whitespacePosition);
          _currentPositions.add(whitespacePosition);
        } else {
          final position = Position(x: x, y: y);
          _correctPositions.add(position);
          _currentPositions.add(position);
        }
      }
    }

    var tiles = _getTileListFromPositions(
      size,
      _correctPositions,
      _currentPositions,
    );

    var puzzle = Puzzle(tiles: tiles);

    return puzzle;
  }

  /// Build a list of tiles - giving each tile their correct position and a
  /// current position.
  List<Tile> _getTileListFromPositions(
    double size,
    List<Position> correctPositions,
    List<Position> currentPositions,
  ) {
    final whitespacePosition = Position(x: size, y: size);
    return [
      for (int i = 1; i <= size * size; i++)
        if (i == size * size)
          Tile(
            value: i,
            correctPosition: whitespacePosition,
            currentPosition: currentPositions[i - 1],
            isWhitespace: true,
          )
        else
          Tile(
            value: i,
            correctPosition: correctPositions[i - 1],
            currentPosition: currentPositions[i - 1],
          )
    ];
  }

  Future<List<MemoryImage>?> _splitImage({required String imagePath}) async {
    // convert image to image from image package
    try {
      final file = await ImageUtils.getImageBytes(imagePath: imagePath);
      final image = imglib.decodeImage(file)!;
      final size = 400;
      // print(size);
      bool isHorizontal = image.width > image.height;
      int x = isHorizontal ? ((max(image.width, image.height) - size) / 2).round() : 0;
      int y = !isHorizontal ? ((max(image.width, image.height) - size) / 2).round() : 0;

      final croppedImage = imglib.copyCrop(image, x, y, size, size);
      int width = (size / 4).round();
      int height = (size / 4).round();

      // split image to parts
      final parts = <imglib.Image>[];

      x = 0;
      y = 0;
      for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
          parts.add(imglib.copyCrop(croppedImage, x, y, width, height));
          x += width;
        }
        x = 0;
        y += height;
      }

      // convert image from image package to Image Widget to display
      final output = <MemoryImage>[];
      for (var img in parts) {
        output.add(MemoryImage(Uint8List.fromList(imglib.encodeJpg(img))));
      }

      return output;
    } on Exception catch (_) {}
    return null;
  }

  Puzzle _shufflePuzzle({required Puzzle generatePuzzle}) {
    // Randomize only the current tile posistions.
    _currentPositions.shuffle(random);

    var tiles = _getTileListFromPositions(
      _size,
      _correctPositions,
      _currentPositions,
    );

    var puzzle = Puzzle(tiles: tiles);

    // Assign the tiles new current positions until the puzzle is solvable and
    // zero tiles are in their correct position.
    while (!puzzle.isSolvable() || puzzle.getNumberOfCorrectTiles() != 0) {
      _currentPositions.shuffle(random);
      tiles = _getTileListFromPositions(
        _size,
        _correctPositions,
        _currentPositions,
      );
      puzzle = Puzzle(tiles: tiles);
    }

    return puzzle;
  }
}
