import 'package:very_good_slide_puzzle/presentation/themes/puzzle/theme.dart';

class ThemeState {
  const ThemeState({
    this.currentPuzzleTheme = const LightPuzzleTheme(),
  });

  final PuzzleTheme currentPuzzleTheme;

  // @override
  // List<Object> get props => [currentPuzzleTheme];
}

class PuzzleThemeChanged extends ThemeState {
  const PuzzleThemeChanged({
    required PuzzleTheme puzzleTheme,
  }) : super(currentPuzzleTheme: puzzleTheme);
}
