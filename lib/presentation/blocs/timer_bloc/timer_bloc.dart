import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/scheduler.dart';
import 'package:very_good_slide_puzzle/presentation/blocs/timer_bloc/bloc.dart';
import 'package:very_good_slide_puzzle/presentation/enums/puzzle_lifecycle.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc() : super(const TimerState()) {
    _ticker = Ticker(_onTick);
    on<ShowTimer>(_onShowTimer);
    on<StartTimer>(_onStartTimer);
    on<TickTimer>(_onTickTimer);
    on<StopTimer>(_onStopTimer);
  }

  late final Ticker _ticker;

  @override
  Future<void> close() {
    _ticker.dispose();
    return super.close();
  }

  void _onTick(Duration duration) {
    add(TickTimer(secondsElapsed: duration.inSeconds));
  }

  void _onShowTimer(ShowTimer event, Emitter<TimerState> emit) {
    _ticker.stop();
    emit(const TimerState(
      puzzleLifecycle: PuzzleLifecycle.onStart,
    ));
  }

  void _onStartTimer(StartTimer event, Emitter<TimerState> emit) {
    if (!_ticker.isTicking) {
      _ticker.start();
    }
  }

  void _onTickTimer(TickTimer event, Emitter<TimerState> emit) {
    emit(TimerState(
      secondsElapsed: event.secondsElapsed,
      isRunning: event.isRunning,
      puzzleLifecycle: PuzzleLifecycle.onRunning,
    ));
  }

  void _onStopTimer(StopTimer event, Emitter<TimerState> emit) async {
    _ticker.stop(canceled: true);
  }
}
