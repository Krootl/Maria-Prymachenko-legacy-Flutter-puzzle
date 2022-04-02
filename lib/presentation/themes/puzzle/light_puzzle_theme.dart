import 'dart:ui';

import 'package:very_good_slide_puzzle/presentation/resources/app_colors.dart';
import 'package:very_good_slide_puzzle/presentation/resources/app_icons.dart';
import 'package:very_good_slide_puzzle/presentation/themes/puzzle/puzzle_theme.dart';

class LightPuzzleTheme extends PuzzleTheme {
  const LightPuzzleTheme();

  @override
  Color get backgroundColor => AppColors.white;

  @override
  String get changeThemeAsset => AppIcons.turnOnDarkTheme;

  @override
  Color get defaultColor => AppColors.mariner;

  @override
  String get getInfoAsset => AppIcons.lightGetInfo;

  @override
  String get goHomeAsset => AppIcons.lightGoHome;

  @override
  Color get menuActiveColor => AppColors.dodgerBlue;

  @override
  Color get menuColor => AppColors.athensGray;

  @override
  Color get movesTitleColor => AppColors.malibu;

  @override
  Color get shuffleButtonColor => AppColors.black;

  @override
  Color get titleColor => AppColors.blackPearl;

  @override
  String get turnOnArtMode => AppIcons.lightTurnOnArtMode;

  @override
  String get turnOnSimpleMode => AppIcons.lightTurnOnSimpleMode;

  @override
  String get timerAsset => AppIcons.lightTimer;

  @override
  Color get timerColor => AppColors.black;

  @override
  String get shuffleAsset => AppIcons.lightShuffle;

  @override
  Color get statusBarTextColor => AppColors.black;

  @override
  Color get restartButtonColor => AppColors.black;

  @override
  Color get startButtonColor => AppColors.malibu;

  @override
  Color get tileNumberColor => AppColors.white;

  @override
  Color get restartButtonTitleColor => AppColors.white;

  @override
  Color get shuffleButtonTitleColor => AppColors.white;

  @override
  Color get startButtonTitleColor => AppColors.white;

  @override
  String get activeExtremeModeAsset => AppIcons.activeExtremeMode;

  @override
  String get extremeModeAsset => AppIcons.lightExtremeMode;

  @override
  Color get activeExtremeModeColor => AppColors.black;

  @override
  Color get loaderColor => AppColors.brightSun;

  @override
  Color get learnMoreButtonColor => AppColors.athensGray;

  @override
  Color get learnMoreTitleColor => AppColors.mariner;

  @override
  String get cancelAsset => AppIcons.lightCancelGetInfo;

  @override
  Color get getInfoDialogBackground => AppColors.white;

  @override
  Color get infoDescriptionColor => AppColors.blackPearl;

  @override
  Color get infoSubtitleColor => AppColors.montage;

  @override
  Color get infoTitleColor => AppColors.blackPearl;

  @override
  Color get authorColor => AppColors.montage;

  @override
  Color get congratulationsBackgroundColor => AppColors.white;

  @override
  Color get congratulationsSubtitleColor => AppColors.black;

  @override
  Color get congratulationsTitleColor => AppColors.black;

  @override
  Color get pictureNameColor => AppColors.black;

  @override
  Color get newGameButtonColor => AppColors.athensGray;

  @override
  Color get newGameButtonTitleColor => AppColors.mariner;

  @override
  Color get pictureOriginalNameColor => AppColors.black;

  @override
  Color get shareButtonColor => AppColors.mariner;

  @override
  Color get shareButtonTitleColor => AppColors.white;
}
