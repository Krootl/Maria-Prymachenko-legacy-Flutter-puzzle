import 'package:equatable/equatable.dart';

abstract class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object> get props => [];
}

class TurnOnArtMode extends MenuEvent {}

class TurnOnSimpleMode extends MenuEvent {}

class TurnOnLightTheme extends MenuEvent {}

class TurnOnDarkTheme extends MenuEvent {}

class GetInfo extends MenuEvent {
  const GetInfo({
    required this.isSelected,
  });

  final bool isSelected;
}

class TurnOnExtremeMode extends MenuEvent {}

class TurnOnNeutralMode extends MenuEvent {}
