import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_slide_puzzle/presentation/blocs/menu_bloc/bloc.dart';
import 'package:very_good_slide_puzzle/presentation/blocs/theme_bloc/bloc.dart';
import 'package:very_good_slide_puzzle/presentation/enums/menu_id.dart';
import 'package:very_good_slide_puzzle/presentation/pages/home_page.dart';
import 'package:very_good_slide_puzzle/presentation/widgets/puzzle/menu_item.dart';

class Menu extends StatelessWidget {
  const Menu({
    Key? key,
    required VoidCallback onBack,
  })  : _onBack = onBack,
        super(key: key);

  final VoidCallback _onBack;

  @override
  Widget build(BuildContext context) => BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) => Wrap(
          spacing: 20,
          runSpacing: 10,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<MenuBloc, MenuState>(
              buildWhen: (_, state) => state is TurnedOnArtMode || state is TurnedOnSimpleMode,
              builder: (context, state) {
                final menuId = state.menuId;
                return MenuItem(
                  iconPath: menuId == null
                      ? themeState.currentPuzzleTheme.turnOnSimpleMode
                      : menuId.getIconPath(theme: themeState.currentPuzzleTheme),
                  menuId: menuId,
                  onPressed: () {
                    if (menuId == null || menuId == MenuId.artMode) {
                      BlocProvider.of<MenuBloc>(context).add(TurnOnSimpleMode());
                    } else {
                      BlocProvider.of<MenuBloc>(context).add(TurnOnArtMode());
                    }
                  },
                );
              },
            ),
            BlocBuilder<MenuBloc, MenuState>(
              buildWhen: (_, state) => state is TurnedOnDarkTheme || state is TurnedOnLightTheme,
              builder: (context, state) {
                final menuId = state.menuId;
                return MenuItem(
                  iconPath: menuId == null
                      ? themeState.currentPuzzleTheme.changeThemeAsset
                      : menuId.getIconPath(theme: themeState.currentPuzzleTheme),
                  menuId: menuId,
                  onPressed: () {
                    if (menuId == null || menuId == MenuId.turnOnLightTheme) {
                      BlocProvider.of<MenuBloc>(context).add(TurnOnDarkTheme());
                    } else {
                      BlocProvider.of<MenuBloc>(context).add(TurnOnLightTheme());
                    }
                  },
                );
              },
            ),
            BlocBuilder<MenuBloc, MenuState>(
              buildWhen: (_, state) => state is GotInfo,
              builder: (context, state) => MenuItem(
                iconPath: themeState.currentPuzzleTheme.getInfoAsset,
                isSelected: state.isSelected,
                menuId: state.menuId,
                onPressed: () {
                  BlocProvider.of<MenuBloc>(context).add(GetInfo(isSelected: !state.isSelected));
                },
              ),
            ),
            MenuItem(
              iconPath: themeState.currentPuzzleTheme.goHomeAsset,
              menuId: MenuId.goHome,
              onPressed: () {
                _onBack();
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, _, __) => const HomePage(),
                    transitionsBuilder: (context, animation, _, child) =>
                        FadeTransition(opacity: animation, child: child),
                  ),
                );
              },
            ),
            BlocBuilder<MenuBloc, MenuState>(
              buildWhen: (_, state) => state is TurnedOnNeutralMode || state is TurnedOnExtremeMode,
              builder: (context, state) {
                final menuId = state.menuId;
                return MenuItem(
                  iconPath: menuId == null
                      ? themeState.currentPuzzleTheme.extremeModeAsset
                      : menuId.getIconPath(theme: themeState.currentPuzzleTheme),
                  menuId: menuId,
                  onPressed: () {
                    if (menuId == null || menuId == MenuId.turnOnNeutralMode) {
                      BlocProvider.of<MenuBloc>(context).add(TurnOnExtremeMode());
                    } else {
                      BlocProvider.of<MenuBloc>(context).add(TurnOnNeutralMode());
                    }
                  },
                );
              },
            ),
          ],
        ),
      );
}
