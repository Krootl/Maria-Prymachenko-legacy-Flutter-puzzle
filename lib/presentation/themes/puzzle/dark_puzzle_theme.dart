import 'dart:ui';

import 'package:very_good_slide_puzzle/presentation/resources/app_colors.dart';
import 'package:very_good_slide_puzzle/presentation/resources/app_icons.dart';
import 'package:very_good_slide_puzzle/presentation/themes/puzzle/puzzle_theme.dart';

class DarkPuzzleTheme extends PuzzleTheme {
  const DarkPuzzleTheme();

  @override
  Color get backgroundColor => AppColors.mirage;

  @override
  String get changeThemeAsset => AppIcons.turnOnLightTheme;

  @override
  Color get defaultColor => AppColors.mariner;

  @override
  String get getInfoAsset => AppIcons.darkGetInfo;

  @override
  String get goHomeAsset => AppIcons.darkGoHome;

  @override
  Color get menuActiveColor => AppColors.dodgerBlue;

  @override
  Color get menuColor => AppColors.tuna;

  @override
  Color get movesTitleColor => AppColors.malibu;

  @override
  Color get shuffleButtonColor => AppColors.white;

  @override
  Color get titleColor => AppColors.white;

  @override
  String get turnOnArtMode => AppIcons.darkTurnOnArtMode;

  @override
  String get turnOnSimpleMode => AppIcons.darkTurnOnSimpleMode;

  @override
  String get timerAsset => AppIcons.darkTimer;

  @override
  Color get timerColor => AppColors.white;

  @override
  String get shuffleAsset => AppIcons.darkShuffle;

  @override
  Color get statusBarTextColor => AppColors.white;

  @override
  Color get restartButtonColor => AppColors.white;

  @override
  Color get startButtonColor => AppColors.malibu;

  @override
  Color get tileNumberColor => AppColors.white;

  @override
  Color get restartButtonTitleColor => AppColors.black;

  @override
  Color get shuffleButtonTitleColor => AppColors.black;

  @override
  Color get startButtonTitleColor => AppColors.white;

  @override
  String get activeExtremeModeAsset => AppIcons.activeExtremeMode;

  @override
  String get extremeModeAsset => AppIcons.darkExtremeMode;

  @override
  Color get activeExtremeModeColor => AppColors.white;

  @override
  Color get loaderColor => AppColors.brightSun;

  @override
  Color get learnMoreButtonColor => AppColors.tuna;

  @override
  Color get learnMoreTitleColor => AppColors.dodgerBlue;

  @override
  String get cancelAsset => AppIcons.darkCancelGetInfo;

  @override
  Color get getInfoDialogBackground => AppColors.mirage;

  @override
  Color get infoDescriptionColor => AppColors.white;

  @override
  Color get infoSubtitleColor => AppColors.montage;

  @override
  Color get infoTitleColor => AppColors.white;

  @override
  Color get authorColor => AppColors.montage;

  @override
  Color get congratulationsBackgroundColor => AppColors.mirage;

  @override
  Color get congratulationsSubtitleColor => AppColors.white;

  @override
  Color get congratulationsTitleColor => AppColors.white;

  @override
  Color get newGameButtonColor => AppColors.tuna;

  @override
  Color get newGameButtonTitleColor => AppColors.mariner;

  @override
  Color get pictureNameColor => AppColors.white;

  @override
  Color get pictureOriginalNameColor => AppColors.white;

  @override
  Color get shareButtonColor => AppColors.mariner;

  @override
  Color get shareButtonTitleColor => AppColors.white;
}
