import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_slide_puzzle/presentation/blocs/puzzle_bloc/bloc.dart';
import 'package:very_good_slide_puzzle/presentation/blocs/theme_bloc/bloc.dart';
import 'package:very_good_slide_puzzle/presentation/enums/layout_size.dart';
import 'package:very_good_slide_puzzle/presentation/enums/puzzle_lifecycle.dart';
import 'package:very_good_slide_puzzle/presentation/models/tile.dart';
import 'package:very_good_slide_puzzle/presentation/resources/app_text_styles.dart';
import 'package:very_good_slide_puzzle/presentation/widgets/puzzle/puzzle_board.dart';
import 'package:very_good_slide_puzzle/presentation/widgets/response_layout_builder.dart';

abstract class _TileSize {
  static double extraSmall = 60;
  static double small = 80;
  static double medium = 100;
  static double large = 112;
}

const _tileLimit = 0.3389;

class PuzzleTile extends StatefulWidget {
  const PuzzleTile({
    Key? key,
    required this.tile,
    required this.puzzleState,
    required this.image,
    required this.hasArt,
    required this.layout,
    required this.showTileNumber,
  }) : super(key: key);

  final Tile tile;

  final PuzzleState puzzleState;
  final MemoryImage image;
  final bool hasArt;
  final LayoutSize layout;
  final bool showTileNumber;

  @override
  State<PuzzleTile> createState() => PuzzleTileState();
}

class PuzzleTileState extends State<PuzzleTile> with SingleTickerProviderStateMixin {
  /// The controller that drives [_scale] animation.
  late AnimationController _controller;
  late Animation<double> _scale;
  late FractionalOffset offset;
  late double _dragPower;
  late int size = widget.puzzleState.puzzle.getDimension();
  late double layout;
  late double tileSize;
  late double k;
  late double centerK;

  @override
  void initState() {
    _dragPower = 0;
    switch (widget.layout) {
      case LayoutSize.extraSmall:
        layout = BoardSize.extraSmall;
        tileSize = _TileSize.extraSmall;
        k = 0.7;

        break;
      case LayoutSize.small:
        layout = BoardSize.small;
        tileSize = _TileSize.small;
        k = 0.7;
        break;
      case LayoutSize.medium:
        layout = BoardSize.medium;
        tileSize = _TileSize.medium;
        k = 0.75;
        break;
      case LayoutSize.large:
        layout = BoardSize.large;
        tileSize = _TileSize.large;
        k = 0.4;

        break;
    }
    centerK = ((layout - tileSize * 4) * 0.01) / 3;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scale = Tween<double>(begin: 1, end: 1.3).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 1, curve: Curves.easeInOut),
      ),
    );
    size = widget.puzzleState.puzzle.getDimension();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = BlocProvider.of<ThemeBloc>(context).state.currentPuzzleTheme;
    final canPress = widget.puzzleState.puzzleLifecycle == PuzzleLifecycle.onRunning &&
        widget.puzzleState.puzzleStatus == PuzzleStatus.incomplete;
    _getOffset();

    return IgnorePointer(
      ignoring: !canPress,
      child: GestureDetector(
        onHorizontalDragUpdate: (e) {
          if (widget.puzzleState.puzzle.getWhitespaceTile().currentPosition.y ==
              widget.tile.currentPosition.y) {
            if (widget.puzzleState.puzzle.isTileMovable(widget.tile)) {
              final dragPower =
                  ((getLocalPosition(e.localPosition.dx, _getDx(size: size)) - _getDx(size: size)) /
                      _tileLimit);
              setState(() {
                _dragPower = dragPower;
              });

              BlocProvider.of<PuzzleBloc>(context).add(
                DragTile(
                  tile: widget.tile,
                  isDrag: true,
                  dragTiles: widget.puzzleState.draggablePuzzles.tiles,
                  dragPower: _dragPower,
                  isHorizontal: true,
                ),
              );
            }
          }
        },
        onVerticalDragUpdate: (e) {
          if (widget.puzzleState.puzzle.getWhitespaceTile().currentPosition.x ==
              widget.tile.currentPosition.x) {
            if (widget.puzzleState.puzzle.isTileMovable(widget.tile)) {
              final double dragPower =
                  (getLocalPosition(e.localPosition.dy, _getDy(size: size)) * 1.25 -
                          _getDy(size: size)) /
                      _tileLimit;

              setState(() {
                _dragPower = dragPower;
              });

              BlocProvider.of<PuzzleBloc>(context).add(
                DragTile(
                  tile: widget.tile,
                  isDrag: true,
                  dragTiles: widget.puzzleState.draggablePuzzles.tiles,
                  dragPower: _dragPower,
                  isHorizontal: false,
                ),
              );
            }
          }
        },
        onHorizontalDragEnd: (details) {
          if (widget.puzzleState.puzzle.getWhitespaceTile().currentPosition.y ==
              widget.tile.currentPosition.y) {
            if (widget.puzzleState.puzzle.isTileMovable(widget.tile)) {
              setState(() {
                _dragPower = _dragPower.round().toDouble();
              });

              BlocProvider.of<PuzzleBloc>(context).add(
                DragTile(
                  tile: widget.tile,
                  isDrag: false,
                  dragTiles: widget.puzzleState.puzzle.tiles,
                  dragPower: _dragPower,
                  isHorizontal: true,
                ),
              );
            }
          }
        },
        onVerticalDragEnd: (e) {
          if (widget.puzzleState.puzzle.getWhitespaceTile().currentPosition.x ==
              widget.tile.currentPosition.x) {
            if (widget.puzzleState.puzzle.isTileMovable(widget.tile)) {
              setState(() {
                _dragPower = _dragPower.round().toDouble();
              });

              BlocProvider.of<PuzzleBloc>(context).add(
                DragTile(
                  tile: widget.tile,
                  isDrag: false,
                  dragTiles: widget.puzzleState.puzzle.tiles,
                  dragPower: _dragPower,
                  isHorizontal: false,
                ),
              );
            }
          }
        },
        onTap: canPress
            ? () {
                BlocProvider.of<PuzzleBloc>(context).add(TapTile(tile: widget.tile));
              }
            : null,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _showTile
              ? AnimatedAlign(
                  duration: Duration(milliseconds: widget.puzzleState.isDrag ? 100 : 300),
                  alignment: offset,
                  curve: Curves.easeInOut,
                  child: ResponsiveLayoutBuilder(
                    extraSmall: (_, child) => SizedBox.square(
                      key: Key('dashatar_puzzle_tile_small_${widget.tile.value}'),
                      dimension: _TileSize.extraSmall,
                      child: child,
                    ),
                    small: (_, child) => SizedBox.square(
                      key: Key('dashatar_puzzle_tile_small_${widget.tile.value}'),
                      dimension: _TileSize.small,
                      child: child,
                    ),
                    medium: (_, child) => SizedBox.square(
                      key: Key('dashatar_puzzle_tile_medium_${widget.tile.value}'),
                      dimension: _TileSize.medium,
                      child: child,
                    ),
                    large: (_, child) => SizedBox.square(
                      key: Key('dashatar_puzzle_tile_large_${widget.tile.value}'),
                      dimension: _TileSize.large,
                      child: child,
                    ),
                    child: (tile) => MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_) {
                        if (canPress) {
                          _controller.forward();
                        }
                      },
                      onExit: (_) {
                        if (canPress) {
                          _controller.reverse();
                        }
                      },
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ScaleTransition(
                            key: Key('dashatar_puzzle_tile_scale_${widget.tile.value}'),
                            scale: _scale,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  widget.puzzleState.puzzleLifecycle == PuzzleLifecycle.onCreate
                                      ? 0
                                      : 4),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: widget.hasArt
                                    ? Image.memory(
                                        widget.image.bytes,
                                      )
                                    : Container(
                                        color: theme.defaultColor,
                                      ),
                              ),
                            ),
                          ),
                          Center(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: _showTileNumber
                                  ? Text(
                                      widget.tile.value.toString(),
                                      style: AppTextStyles.headline3.copyWith(
                                        color: theme.tileNumberColor,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }

  double _getDx({required int size, bool isDrag = false}) {
    if (widget.puzzleState.puzzleLifecycle == PuzzleLifecycle.onCreate) {
      return (widget.tile.currentPosition.x - 1.075) / (size - k) + centerK;
    }
    return (isDrag
            ? widget.puzzleState.draggablePuzzles.tiles
                    .firstWhere((e) => widget.tile.value == e.value)
                    .currentPosition
                    .x -
                1.025
            : widget.tile.currentPosition.x - 1.025) /
        (size - 1.05);
  }

  double _getDy({required int size, bool isDrag = false}) {
    if (widget.puzzleState.puzzleLifecycle == PuzzleLifecycle.onCreate) {
      return (widget.tile.currentPosition.y - 0.85) / (size - k);
    }
    return (isDrag
            ? widget.puzzleState.draggablePuzzles.tiles
                    .firstWhere((e) => widget.tile.value == e.value)
                    .currentPosition
                    .y -
                1.025
            : widget.tile.currentPosition.y - 1.025) /
        (size - 1.05);
  }

  void _getOffset() {
    setState(() {
      offset = FractionalOffset(
        _getDx(size: size, isDrag: widget.puzzleState.isDrag),
        _getDy(size: size, isDrag: widget.puzzleState.isDrag),
      );
    });
  }

  double getLocalPosition(double localPosition, double currentPosition) =>
      localPosition / layout < (tileSize / 2) / layout
          ? currentPosition - _tileLimit < localPosition / layout
              ? 0
              : currentPosition - _tileLimit
          : localPosition / layout < currentPosition - _tileLimit
              ? currentPosition - _tileLimit
              : localPosition / layout > currentPosition + _tileLimit
                  ? currentPosition + _tileLimit > _tileLimit * 3
                      ? _tileLimit * 3
                      : currentPosition + _tileLimit
                  : localPosition / layout > 1 - (tileSize / 2) / layout
                      ? _tileLimit * 3
                      : localPosition / layout;

  bool get _showTile {
    if (widget.puzzleState.puzzleLifecycle == PuzzleLifecycle.onCreate) {
      return true;
    } else if (widget.tile.value == 16) {
      return false;
    }
    return true;
  }

  bool get _showTileNumber =>
      !widget.showTileNumber && widget.puzzleState.puzzleLifecycle != PuzzleLifecycle.onCreate;
}
