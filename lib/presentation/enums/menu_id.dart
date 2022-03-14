import 'package:very_good_slide_puzzle/presentation/themes/puzzle/puzzle_theme.dart';

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
}
