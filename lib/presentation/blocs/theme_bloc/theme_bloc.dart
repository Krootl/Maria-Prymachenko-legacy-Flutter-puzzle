import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:very_good_slide_puzzle/presentation/blocs/theme_bloc/bloc.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState()) {
    on<ChangePuzzleTheme>(_onChangePuzzleTheme);
  }

  void _onChangePuzzleTheme(ChangePuzzleTheme event, Emitter<ThemeState> emit) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: event.selectedPuzzleTheme.statusBarTextColor));
    emit(PuzzleThemeChanged(puzzleTheme: event.selectedPuzzleTheme));
  }
}
