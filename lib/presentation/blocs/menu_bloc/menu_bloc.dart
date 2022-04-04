import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_slide_puzzle/presentation/blocs/menu_bloc/bloc.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc() : super(const MenuState()) {
    on<TurnOnArtMode>(_onTurnOnArtMode);
    on<TurnOnSimpleMode>(_onTurnOnSimpleMode);
    on<TurnOnDarkTheme>(_onTurnOnDarkTheme);
    on<TurnOnLightTheme>(_onTurnOnLightTheme);
    on<GetInfo>(_onGetInfo);
    on<TurnOnExtremeMode>(_onTurnOnExtremeMode);
    on<TurnOnNeutralMode>(_onTurnOnNeutralMode);
  }

  void _onTurnOnArtMode(TurnOnArtMode event, Emitter<MenuState> emit) {
    emit(const TurnedOnArtMode());
    emit(const TurnedOnNeutralMode());
  }

  void _onTurnOnSimpleMode(TurnOnSimpleMode event, Emitter<MenuState> emit) {
    emit(const TurnedOnSimpleMode());
    emit(const TurnedOnNeutralMode(isDisabled: true));
  }

  void _onTurnOnDarkTheme(TurnOnDarkTheme event, Emitter<MenuState> emit) {
    emit(const TurnedOnDarkTheme());
  }

  void _onTurnOnLightTheme(TurnOnLightTheme event, Emitter<MenuState> emit) {
    emit(const TurnedOnLightTheme());
  }

  void _onGetInfo(GetInfo event, Emitter<MenuState> emit) {
    emit(GotInfo(isSelected: event.isSelected));
  }

  void _onTurnOnExtremeMode(TurnOnExtremeMode event, Emitter<MenuState> emit) {
    emit(const TurnedOnExtremeMode());
    emit(const TurnedOnArtMode(isDisabled: true));
  }

  void _onTurnOnNeutralMode(TurnOnNeutralMode event, Emitter<MenuState> emit) {
    emit(const TurnedOnNeutralMode());
    emit(const TurnedOnArtMode());
  }
}
