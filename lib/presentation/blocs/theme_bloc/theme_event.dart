import 'package:equatable/equatable.dart';
import 'package:very_good_slide_puzzle/presentation/themes/puzzle/theme.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class ChangePuzzleTheme extends ThemeEvent {
  const ChangePuzzleTheme({
    required this.selectedPuzzleTheme,
  });

  final PuzzleTheme selectedPuzzleTheme;

  @override
  List<Object> get props => [selectedPuzzleTheme];
}
