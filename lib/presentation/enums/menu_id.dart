import 'package:flutter/material.dart';
import 'package:very_good_slide_puzzle/presentation/themes/puzzle/puzzle_theme.dart';
import 'package:very_good_slide_puzzle/l10n/l10n.dart';

enum MenuId {
  artMode,
  simpleMode,
  turnOnLightTheme,
  turnOnDarkTheme,
  turnOnExtremeMode,
  turnOnNeutralMode,
  getInfo,
  goHome,
}

extension MenuIdX on MenuId {
  String getIconPath({required PuzzleTheme theme}) {
    switch (this) {
      case MenuId.artMode:
        return theme.turnOnSimpleMode;
      case MenuId.simpleMode:
        return theme.turnOnArtMode;
      case MenuId.turnOnLightTheme:
      case MenuId.turnOnDarkTheme:
        return theme.changeThemeAsset;
      case MenuId.getInfo:
        return theme.getInfoAsset;
      case MenuId.goHome:
        return theme.goHomeAsset;
      case MenuId.turnOnExtremeMode:
        return theme.activeExtremeModeAsset;
      case MenuId.turnOnNeutralMode:
        return theme.extremeModeAsset;
    }
  }

  String getTooltipMessage({required BuildContext context}) {
    switch (this) {
      case MenuId.artMode:
        return context.l10n.noImageMode;
      case MenuId.simpleMode:
        return context.l10n.imageMode;
      case MenuId.turnOnLightTheme:
        return context.l10n.darkMode;
      case MenuId.turnOnDarkTheme:
        return context.l10n.lightMode;
      case MenuId.turnOnExtremeMode:
        return context.l10n.simpleMode;
      case MenuId.turnOnNeutralMode:
        return context.l10n.extremeMode;
      case MenuId.getInfo:
        return context.l10n.paintingInfo;
      case MenuId.goHome:
        return context.l10n.home;
    }
  }
}
