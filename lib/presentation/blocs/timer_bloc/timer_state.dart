import 'package:equatable/equatable.dart';
import 'package:very_good_slide_puzzle/presentation/enums/puzzle_lifecycle.dart';

class TimerState extends Equatable {
  const TimerState({
    this.secondsElapsed = 0,
    this.isRunning = false,
    this.puzzleLifecycle = PuzzleLifecycle.onCreate,
  });

  final int secondsElapsed;
  final bool isRunning;
  final PuzzleLifecycle puzzleLifecycle;

  @override
  List<Object> get props => [
        secondsElapsed,
        isRunning,
        puzzleLifecycle,
      ];
}
