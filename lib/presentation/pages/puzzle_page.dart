import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:very_good_slide_puzzle/domain/entities/painting_entity.dart';
import 'package:very_good_slide_puzzle/l10n/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_slide_puzzle/presentation/blocs/menu_bloc/bloc.dart';
import 'package:very_good_slide_puzzle/presentation/blocs/puzzle_bloc/bloc.dart';
import 'package:very_good_slide_puzzle/presentation/blocs/theme_bloc/bloc.dart';
import 'package:very_good_slide_puzzle/presentation/blocs/timer_bloc/bloc.dart';
import 'package:very_good_slide_puzzle/presentation/enums/puzzle_lifecycle.dart';
import 'package:very_good_slide_puzzle/presentation/resources/app_colors.dart';
import 'package:very_good_slide_puzzle/presentation/resources/app_text_styles.dart';
import 'package:very_good_slide_puzzle/presentation/themes/puzzle/theme.dart';
import 'package:very_good_slide_puzzle/presentation/widgets/puzzle/congratulations_dialog.dart';
import 'package:very_good_slide_puzzle/presentation/widgets/puzzle/get_info_dialog.dart';
import 'package:very_good_slide_puzzle/presentation/widgets/puzzle/menu.dart';
import 'package:very_good_slide_puzzle/presentation/widgets/puzzle/number_of_moves.dart';
import 'package:very_good_slide_puzzle/presentation/widgets/puzzle/puzzle_action_button.dart';
import 'package:very_good_slide_puzzle/presentation/widgets/puzzle/puzzle_board.dart';
import 'package:very_good_slide_puzzle/presentation/widgets/puzzle/game_timer.dart';
import 'package:very_good_slide_puzzle/presentation/widgets/response_layout_builder.dart';

class PuzzlePage extends StatefulWidget {
  const PuzzlePage({
    Key? key,
    required PaintingEntity paintingEntity,
  })  : _paintingEntity = paintingEntity,
        super(key: key);

  final PaintingEntity _paintingEntity;

  @override
  State<PuzzlePage> createState() => _PuzzlePageState();
}

class _PuzzlePageState extends State<PuzzlePage> with SingleTickerProviderStateMixin {
  late final _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
  late final _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
  OverlayEntry? _overlayEntry;
  int _time = 0;

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider<PuzzleBloc>(
            create: (context) => PuzzleBloc(4)..add(CreatePuzzle(imagePath: widget._paintingEntity.image)),
            lazy: false,
          ),
          BlocProvider<MenuBloc>(
            create: (context) => MenuBloc(),
          ),
          BlocProvider<TimerBloc>(
            create: (context) => TimerBloc(),
          ),
          BlocProvider<ThemeBloc>(
            create: (context) => ThemeBloc(),
            lazy: false,
          ),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<PuzzleBloc, PuzzleState>(
              listener: (context, state) {
                if (state.puzzleLifecycle == PuzzleLifecycle.onStart ||
                    state.puzzleLifecycle == PuzzleLifecycle.onCreate) {
                  BlocProvider.of<TimerBloc>(context).add(ShowTimer());
                } else if (state.puzzleLifecycle == PuzzleLifecycle.onRunning) {
                  BlocProvider.of<TimerBloc>(context).add(StartTimer());
                  if (state.numberOfCorrectTiles == 14) {
                    BlocProvider.of<TimerBloc>(context).add((StopTimer()));
                    _showCongratulationsDialog(
                        context: context, movesNumber: state.numberOfMoves, time: _time.toString());
                  }
                }
              },
            ),
            BlocListener<MenuBloc, MenuState>(
              listener: (context, state) {
                if (state is TurnedOnArtMode) {
                  BlocProvider.of<PuzzleBloc>(context).add(ShowArtPuzzle());
                } else if (state is TurnedOnSimpleMode) {
                  BlocProvider.of<PuzzleBloc>(context).add(ShowSimplePuzzle());
                } else if (state is TurnedOnDarkTheme) {
                  BlocProvider.of<ThemeBloc>(context)
                      .add(const ChangePuzzleTheme(selectedPuzzleTheme: DarkPuzzleTheme()));
                } else if (state is TurnedOnLightTheme) {
                  BlocProvider.of<ThemeBloc>(context)
                      .add(const ChangePuzzleTheme(selectedPuzzleTheme: LightPuzzleTheme()));
                } else if (state is TurnedOnExtremeMode) {
                  BlocProvider.of<PuzzleBloc>(context).add(ShowTileNumber());
                } else if (state is TurnedOnNeutralMode) {
                  BlocProvider.of<PuzzleBloc>(context).add(HideTileNumber());
                } else if (state is GotInfo) {
                  if (state.isSelected) {
                    _showGetInfoDialog(context: context);
                  } else {
                    _hideGetInfoDialog(context: context);
                  }
                }
              },
            ),
          ],
          child: BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              final systemStyle = themeState.currentPuzzleTheme is DarkPuzzleTheme
                  ? SystemUiOverlayStyle.light
                  : SystemUiOverlayStyle.dark;
              SystemChrome.setSystemUIOverlayStyle(systemStyle);
              return Material(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  color: themeState.currentPuzzleTheme.backgroundColor,
                  child: SafeArea(
                    child: Center(
                      child: BlocBuilder<PuzzleBloc, PuzzleState>(
                        builder: (context, state) => AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: state.images.isEmpty
                              ? SpinKitRipple(
                                  color: themeState.currentPuzzleTheme.loaderColor,
                                )
                              : Column(
                                  children: [
                                    ResponsiveLayoutBuilder(
                                      extraSmall: (context, child) => const SizedBox(height: 10),
                                      small: (context, child) => const SizedBox(height: 40),
                                      medium: (context, child) => const SizedBox(height: 40),
                                      large: (context, child) => const SizedBox(height: 40),
                                    ),
                                    Text(
                                      context.l10n.puzzleTitle,
                                      style: AppTextStyles.headline4.copyWith(
                                        color: themeState.currentPuzzleTheme.titleColor,
                                      ),
                                    ),
                                    ResponsiveLayoutBuilder(
                                      extraSmall: (context, child) => const SizedBox(height: 10),
                                      small: (context, child) => const SizedBox(height: 16),
                                      medium: (context, child) => const SizedBox(height: 16),
                                      large: (context, child) => const SizedBox(height: 16),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        NumberOfMoves(
                                          numberOfMoves: state.numberOfMoves,
                                          title: context.l10n.numberOfPuzzleMoves,
                                        ),
                                        Container(
                                          height: 20,
                                          width: 1,
                                          margin: const EdgeInsets.symmetric(horizontal: 8),
                                          decoration: BoxDecoration(
                                            color: AppColors.mariner,
                                            borderRadius: BorderRadius.circular(1),
                                          ),
                                        ),
                                        NumberOfMoves(
                                          numberOfMoves: state.puzzleLifecycle == PuzzleLifecycle.onRunning
                                              ? state.numberOfTilesLeft
                                              : state.numberOfCorrectTiles,
                                          title: context.l10n.numberOfPuzzleTilesLeft,
                                        ),
                                      ],
                                    ),
                                    AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 300),
                                      child: state.puzzleLifecycle != PuzzleLifecycle.onCreate
                                          ? BlocBuilder<TimerBloc, TimerState>(
                                              builder: (context, state) {
                                                _time = state.secondsElapsed;
                                                return Column(
                                                  children: [
                                                    ResponsiveLayoutBuilder(
                                                      extraSmall: (context, child) => const SizedBox(height: 5),
                                                      small: (context, child) => const SizedBox(height: 16),
                                                      medium: (context, child) => const SizedBox(height: 16),
                                                      large: (context, child) => const SizedBox(height: 16),
                                                    ),
                                                    GameTimer(secondsElapsed: state.secondsElapsed),
                                                    ResponsiveLayoutBuilder(
                                                      extraSmall: (context, child) => const SizedBox(height: 5),
                                                      small: (context, child) => const SizedBox(height: 40),
                                                      medium: (context, child) => const SizedBox(height: 40),
                                                      large: (context, child) => const SizedBox(height: 40),
                                                    ),
                                                  ],
                                                );
                                              },
                                            )
                                          : ResponsiveLayoutBuilder(
                                              extraSmall: (context, child) => const SizedBox(height: 10),
                                              small: (context, child) => const SizedBox(height: 83),
                                              medium: (context, child) => const SizedBox(height: 83),
                                              large: (context, child) => const SizedBox(height: 83),
                                            ),
                                    ),
                                    PuzzleBoard(
                                      tiles: state.puzzle.tiles,
                                      puzzleState: state,
                                      hasArt: state.hasArtPuzzle,
                                      showTileNumber: state.showTileNumber,
                                    ),
                                    ResponsiveLayoutBuilder(
                                      extraSmall: (context, child) => const SizedBox(
                                        height: 10,
                                      ),
                                      small: (context, child) => const SizedBox(height: 40),
                                      medium: (context, child) => const SizedBox(height: 40),
                                      large: (context, child) => const SizedBox(height: 40),
                                    ),
                                    SizedBox(
                                      width: 126,
                                      height: 42,
                                      child: PuzzleActionButton(puzzleLifecycle: state.puzzleLifecycle),
                                    ),
                                    const Spacer(),
                                    const SizedBox(height: 10),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 37),
                                      child: Menu(),
                                    ),
                                    ResponsiveLayoutBuilder(
                                      extraSmall: (context, child) => const SizedBox(height: 10),
                                      small: (context, child) => const SizedBox(height: 30),
                                      medium: (context, child) => const SizedBox(height: 60),
                                      large: (context, child) => const SizedBox(height: 60),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );

  void _showGetInfoDialog({required BuildContext context}) {
    final menuBloc = BlocProvider.of<MenuBloc>(context);
    final themeBloc = BlocProvider.of<ThemeBloc>(context);
    final overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => Opacity(
        opacity: _animation.value,
        child: BlocProvider.value(
          value: themeBloc,
          child: GetInfoDialog(
            imagePath: widget._paintingEntity.image,
            name: widget._paintingEntity.title,
            author: widget._paintingEntity.artistName ?? '',
            url: widget._paintingEntity.url,
            onCloseDialog: () async {
              menuBloc.add(const GetInfo(isSelected: false));
            },
          ),
        ),
      ),
    );

    _animationController.addListener(() {
      overlayState?.setState(() {});
    });
    if (_overlayEntry == null) return;
    Overlay.of(context)?.insert(_overlayEntry!);
    _animationController.forward();
  }

  Future<void> _hideGetInfoDialog({required BuildContext context}) async {
    if (_overlayEntry == null) return;
    await _animationController.reverse();
    _overlayEntry?.remove();
  }

  Future<void> _showCongratulationsDialog(
      {required BuildContext context, required int movesNumber, required String time}) {
    final themeBloc = BlocProvider.of<ThemeBloc>(context);
    return showGeneralDialog<void>(
      context: context,
      pageBuilder: (context, _, __) => BlocProvider.value(
        value: themeBloc,
        child: CongratulationsDialog(
          imagePath: widget._paintingEntity.image,
          name: widget._paintingEntity.title,
          author: widget._paintingEntity.artistName ?? '',
          movesNumber: movesNumber,
          time: time,
        ),
      ),
    );
  }
}
