import 'package:flutter/material.dart';
import 'package:very_good_slide_puzzle/l10n/l10n.dart';
import 'package:very_good_slide_puzzle/presentation/themes/puzzle/puzzle_theme.dart';

enum PuzzleLifecycle {
  onCreate,
  onStart,
  onShuffle,
  onRunning,
  onRestart,
}

extension PuzzleLifecycleX on PuzzleLifecycle {
  String getActionButtonTitle(BuildContext context) {
    switch (this) {
      case PuzzleLifecycle.onCreate:
      case PuzzleLifecycle.onRestart:
        return context.l10n.startPuzzle;
      case PuzzleLifecycle.onStart:
      case PuzzleLifecycle.onShuffle:
        return context.l10n.shufflePuzzle;
      case PuzzleLifecycle.onRunning:
        return context.l10n.restartPuzzle;
    }
  }

  Color getActionButtonTitleColor({required PuzzleTheme theme}) {
    switch (this) {
      case PuzzleLifecycle.onCreate:
        return theme.startButtonTitleColor;
      case PuzzleLifecycle.onStart:
      case PuzzleLifecycle.onShuffle:
      case PuzzleLifecycle.onRestart:
      case PuzzleLifecycle.onRunning:
        return theme.restartButtonTitleColor;
    }
  }

  Color getActionButtonColor({required PuzzleTheme theme}) {
    switch (this) {
      case PuzzleLifecycle.onCreate:
        return theme.startButtonColor;
      case PuzzleLifecycle.onStart:
      case PuzzleLifecycle.onRestart:
      case PuzzleLifecycle.onShuffle:
      case PuzzleLifecycle.onRunning:
        return theme.shuffleButtonColor;
    }
  }
}
