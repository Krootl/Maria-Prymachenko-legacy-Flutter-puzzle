import 'package:equatable/equatable.dart';

abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object> get props => [];
}

class ShowTimer extends TimerEvent {}

class StartTimer extends TimerEvent {}

class TickTimer extends TimerEvent {
  const TickTimer({
    this.secondsElapsed = 0,
    this.isRunning = true,
  });

  final int secondsElapsed;
  final bool isRunning;
}

class StopTimer extends TimerEvent {}
