import 'dart:math';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:very_good_slide_puzzle/presentation/models/position.dart';
import 'package:very_good_slide_puzzle/presentation/models/tile.dart';

// A 3x3 puzzle board visualization:
//
//   ┌─────1───────2───────3────► x
//   │  ┌─────┐ ┌─────┐ ┌─────┐
//   1  │  1  │ │  2  │ │  3  │
//   │  └─────┘ └─────┘ └─────┘
//   │  ┌─────┐ ┌─────┐ ┌─────┐
//   2  │  4  │ │  5  │ │  6  │
//   │  └─────┘ └─────┘ └─────┘
//   │  ┌─────┐ ┌─────┐
//   3  │  7  │ │  8  │
//   │  └─────┘ └─────┘
//   ▼
//   y
//
// This puzzle is in its completed state (i.e. the tiles are arranged in
// ascending order by value from top to bottom, left to right).
//
// Each tile has a value (1-8 on example above), and a correct and current
// position.
//
// The correct position is where the tile should be in the completed
// puzzle. As seen from example above, tile 2's correct position is (2, 1).
// The current position is where the tile is currently located on the board.

/// {@template puzzle}
/// Model for a puzzle.
/// {@endtemplate}
class Puzzle extends Equatable {
  /// {@macro puzzle}
  const Puzzle({required this.tiles});

  /// List of [Tile]s representing the puzzle's current arrangement.
  final List<Tile> tiles;

  /// Get the dimension of a puzzle given its tile arrangement.
  ///
  /// Ex: A 4x4 puzzle has a dimension of 4.
  int getDimension() => sqrt(tiles.length).toInt();

  /// Gets the single whitespace tile object in the puzzle.
  Tile getWhitespaceTile() => tiles
      .singleWhere((tile) => tile.isWhitespace); // tiles.singleWhere((tile) => tile.value == 16);

  /// Gets the tile relative to the whitespace tile in the puzzle
  /// defined by [relativeOffset].
  Tile? getTileRelativeToWhitespaceTile(Offset relativeOffset) {
    final whitespaceTile = getWhitespaceTile();
    return tiles.singleWhereOrNull(
      (tile) =>
          tile.currentPosition.x == whitespaceTile.currentPosition.x + relativeOffset.dx &&
          tile.currentPosition.y == whitespaceTile.currentPosition.y + relativeOffset.dy,
    );
  }

  /// Gets the number of tiles that are currently in their correct position.
  int getNumberOfCorrectTiles() {
    final whitespaceTile = getWhitespaceTile();
    var numberOfCorrectTiles = 0;
    for (final tile in tiles) {
      if (tile != whitespaceTile) {
        if (tile.currentPosition == tile.correctPosition) {
          numberOfCorrectTiles++;
        }
      }
    }
    return numberOfCorrectTiles;
  }

  /// Determines if the puzzle is completed.
  bool isComplete() => (tiles.length - 1) - getNumberOfCorrectTiles() == 0;

  /// Determines if the tapped tile can move in the direction of the whitespace
  /// tile.
  bool isTileMovable(Tile tile) {
    final whitespaceTile = getWhitespaceTile();
    if (tile == whitespaceTile) {
      return false;
    }

    // A tile must be in the same row or column as the whitespace to move.
    if (whitespaceTile.currentPosition.x != tile.currentPosition.x &&
        whitespaceTile.currentPosition.y != tile.currentPosition.y) {
      return false;
    }
    return true;
  }

  /// Determines if the puzzle is solvable.
  bool isSolvable() {
    final size = getDimension();
    final height = tiles.length ~/ size;
    assert(
      size * height == tiles.length,
      'tiles must be equal to size * height',
    );
    final inversions = countInversions();

    if (size.isOdd) {
      return inversions.isEven;
    }

    final whitespace = tiles.singleWhere((tile) => tile.isWhitespace);
    final whitespaceRow = whitespace.currentPosition.y;

    if (((height - whitespaceRow) + 1).toInt().isOdd) {
      return inversions.isEven;
    } else {
      return inversions.isOdd;
    }
  }

  /// Gives the number of inversions in a puzzle given its tile arrangement.
  ///
  /// An inversion is when a tile of a lower value is in a greater position than
  /// a tile of a higher value.
  int countInversions() {
    var count = 0;
    for (var a = 0; a < tiles.length; a++) {
      final tileA = tiles[a];
      if (tileA.isWhitespace) {
        continue;
      }

      for (var b = a + 1; b < tiles.length; b++) {
        final tileB = tiles[b];
        if (_isInversion(tileA, tileB)) {
          count++;
        }
      }
    }
    return count;
  }

  /// Determines if the two tiles are inverted.
  bool _isInversion(Tile a, Tile b) {
    if (!b.isWhitespace && a.value != b.value) {
      if (b.value < a.value) {
        return b.currentPosition.compareTo(a.currentPosition) > 0;
      } else {
        return a.currentPosition.compareTo(b.currentPosition) > 0;
      }
    }
    return false;
  }

  /// Shifts one or many tiles in a row/column with the whitespace and returns
  /// the modified puzzle.
  ///
  // Recursively stores a list of all tiles that need to be moved and passes the
  // list to _swapTiles to individually swap them.
  Puzzle moveTiles({
    required Tile tile,
    required List<Tile> tilesToSwap,
    double dragPower = 0,
    bool isHorizontal = false,
    bool isDrag = false,
  }) {
    final whitespaceTile = getWhitespaceTile();
    final deltaX = whitespaceTile.currentPosition.x - tile.currentPosition.x;
    final deltaY = whitespaceTile.currentPosition.y - tile.currentPosition.y;

    if ((deltaX.abs() + deltaY.abs()) > 1) {
      final shiftPointX = tile.currentPosition.x + deltaX.sign;
      final shiftPointY = tile.currentPosition.y + deltaY.sign;
      final tileToSwapWith = tiles.singleWhere(
        (tile) => tile.currentPosition.x == shiftPointX && tile.currentPosition.y == shiftPointY,
      );
      tilesToSwap.add(tile);
      return isDrag
          ? moveTiles(
              tile: tileToSwapWith,
              tilesToSwap: tilesToSwap,
              dragPower: dragPower,
              isHorizontal: isHorizontal,
              isDrag: isDrag,
            )
          : moveTiles(
              tile: tileToSwapWith,
              tilesToSwap: tilesToSwap,
            );
    } else {
      tilesToSwap.add(tile);
      return isDrag
          ? _swapDraggingTiles(tilesToSwap, dragPower, isHorizontal)
          : _swapTiles(tilesToSwap);
    }
  }

  Puzzle _swapDraggingTiles(
    List<Tile> tilesToSwap,
    double dragPower,
    bool isHorizontal,
  ) {
    for (final tileToSwap in tilesToSwap.reversed) {
      final tileIndex = tiles.indexWhere((tile) => tileToSwap.value == tile.value);
      final tile = tiles[tileIndex];

      final whitespaceTile = getWhitespaceTile();
      final whitespaceTileIndex = tiles.indexOf(whitespaceTile);
      final _dragPower = isHorizontal
          ? whitespaceTile.currentPosition.x > tile.currentPosition.x
              ? dragPower > 0
                  ? dragPower > 1
                      ? 1
                      : dragPower
                  : 0
              : dragPower < 0
                  ? dragPower < -1
                      ? 1
                      : dragPower
                  : 0
          : whitespaceTile.currentPosition.y > tile.currentPosition.y
              ? dragPower > 0
                  ? dragPower > 1
                      ? 1
                      : dragPower
                  : 0
              : dragPower < 0
                  ? dragPower < -1
                      ? 1
                      : dragPower
                  : 0;
      final Position position = isHorizontal
          ? Position(x: tile.currentPosition.x + _dragPower, y: tile.currentPosition.y)
          : Position(x: tile.currentPosition.x, y: tile.currentPosition.y + _dragPower);

      final Position whiteSpacePosition = isHorizontal
          ? Position(
              x: whitespaceTile.currentPosition.x - _dragPower, y: whitespaceTile.currentPosition.y)
          : Position(
              x: whitespaceTile.currentPosition.x,
              y: whitespaceTile.currentPosition.y - _dragPower);
      tiles[tileIndex] = tile.copyWith(
        currentPosition: position,
      );
      tiles[whitespaceTileIndex] = whitespaceTile.copyWith(
        currentPosition: whiteSpacePosition,
      );
    }
    return Puzzle(tiles: tiles);
  }

  /// Returns puzzle with new tile arrangement after individually swapping each
  /// tile in tilesToSwap with the whitespace.
  Puzzle _swapTiles(List<Tile> tilesToSwap) {
    for (final tileToSwap in tilesToSwap.reversed) {
      final tileIndex = tiles.indexOf(tileToSwap);
      final tile = tiles[tileIndex];
      final whitespaceTile = getWhitespaceTile();
      final whitespaceTileIndex = tiles.indexOf(whitespaceTile);

      // Swap current board positions of the moving tile and the whitespace.
      tiles[tileIndex] = tile.copyWith(
        currentPosition: whitespaceTile.currentPosition,
      );
      tiles[whitespaceTileIndex] = whitespaceTile.copyWith(
        currentPosition: tile.currentPosition,
      );
    }

    return Puzzle(tiles: tiles);
  }

  /// Sorts puzzle tiles so they are in order of their current position.
  Puzzle sort() {
    final sortedTiles = tiles.toList()
      ..sort((tileA, tileB) => tileA.currentPosition.compareTo(tileB.currentPosition));
    return Puzzle(tiles: sortedTiles);
  }

  @override
  List<Object> get props => [tiles];
}
