import 'package:flutter/widgets.dart';

abstract class PuzzleTheme {
  const PuzzleTheme();

  Color get statusBarTextColor;
  Color get titleColor;
  Color get tileNumberColor;
  Color get movesTitleColor;
  Color get menuColor;
  Color get menuActiveColor;
  Color get shuffleButtonColor;
  Color get startButtonColor;
  Color get restartButtonColor;
  Color get shuffleButtonTitleColor;
  Color get startButtonTitleColor;
  Color get restartButtonTitleColor;
  Color get backgroundColor;
  Color get defaultColor;
  Color get timerColor;
  Color get activeExtremeModeColor;
  Color get loaderColor;
  Color get getInfoDialogBackground;
  Color get infoTitleColor;
  Color get infoSubtitleColor;
  Color get infoDescriptionColor;
  Color get learnMoreTitleColor;
  Color get learnMoreButtonColor;
  Color get congratulationsBackgroundColor;
  Color get congratulationsTitleColor;
  Color get congratulationsSubtitleColor;
  Color get pictureNameColor;
  Color get pictureOriginalNameColor;
  Color get authorColor;
  Color get shareButtonTitleColor;
  Color get shareButtonColor;
  Color get newGameButtonTitleColor;
  Color get newGameButtonColor;
  String get turnOnArtMode;
  String get turnOnSimpleMode;
  String get changeThemeAsset;
  String get getInfoAsset;
  String get goHomeAsset;
  String get timerAsset;
  String get shuffleAsset;
  String get extremeModeAsset;
  String get activeExtremeModeAsset;
  String get cancelAsset;
}
