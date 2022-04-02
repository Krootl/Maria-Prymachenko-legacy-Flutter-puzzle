import 'package:equatable/equatable.dart';
import 'package:very_good_slide_puzzle/presentation/enums/menu_id.dart';

class MenuState extends Equatable {
  const MenuState({
    this.menuId,
    this.isSelected = false,
    this.isDisabled = false,
  });

  final MenuId? menuId;
  final bool isSelected;
  final bool isDisabled;

  @override
  List<Object?> get props => [menuId, isSelected];
}

class TurnedOnArtMode extends MenuState {
  const TurnedOnArtMode({
    bool isDisabled = false,
  }) : super(
          isDisabled: isDisabled,
          menuId: MenuId.artMode,
        );
}

class TurnedOnSimpleMode extends MenuState {
  const TurnedOnSimpleMode()
      : super(
          menuId: MenuId.simpleMode,
        );
}

class TurnedOnLightTheme extends MenuState {
  const TurnedOnLightTheme()
      : super(
          menuId: MenuId.turnOnLightTheme,
        );
}

class TurnedOnDarkTheme extends MenuState {
  const TurnedOnDarkTheme()
      : super(
          menuId: MenuId.turnOnDarkTheme,
        );
}

class TurnedOnExtremeMode extends MenuState {
  const TurnedOnExtremeMode()
      : super(
          menuId: MenuId.turnOnExtremeMode,
        );
}

class TurnedOnNeutralMode extends MenuState {
  const TurnedOnNeutralMode({
    bool isDisabled = false,
  }) : super(
          isDisabled: isDisabled,
          menuId: MenuId.turnOnNeutralMode,
        );
}

class GotInfo extends MenuState {
  const GotInfo({
    required bool isSelected,
  }) : super(
          menuId: MenuId.getInfo,
          isSelected: isSelected,
        );
}
