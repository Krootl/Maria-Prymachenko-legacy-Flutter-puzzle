import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_slide_puzzle/presentation/blocs/menu_bloc/bloc.dart';
import 'package:very_good_slide_puzzle/presentation/blocs/theme_bloc/bloc.dart';
import 'package:very_good_slide_puzzle/presentation/enums/menu_id.dart';
import 'package:very_good_slide_puzzle/presentation/pages/home_page.dart';
import 'package:very_good_slide_puzzle/presentation/widgets/puzzle/menu_item.dart';
import 'package:very_good_slide_puzzle/l10n/l10n.dart';

class Menu extends StatelessWidget {
  const Menu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) => Wrap(
          spacing: 20,
          runSpacing: 10,
          children: [
            BlocBuilder<MenuBloc, MenuState>(
              buildWhen: (_, state) => state is TurnedOnArtMode || state is TurnedOnSimpleMode,
              builder: (context, state) {
                final menuId = state.menuId;
                return MenuItem(
                  iconPath: menuId == null
                      ? themeState.currentPuzzleTheme.turnOnSimpleMode
                      : menuId.getIconPath(theme: themeState.currentPuzzleTheme),
                  tooltipMessage: menuId?.getTooltipMessage(context: context) ?? context.l10n.noImageMode,
                  menuId: menuId,
                  isDisabled: state.isDisabled,
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
                  tooltipMessage: menuId?.getTooltipMessage(context: context) ?? context.l10n.darkMode,
                  menuId: menuId,
                  isDisabled: state.isDisabled,
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
                tooltipMessage: MenuId.getInfo.getTooltipMessage(context: context),
                isSelected: state.isSelected,
                isDisabled: state.isDisabled,
                menuId: state.menuId,
                onPressed: () {
                  BlocProvider.of<MenuBloc>(context).add(GetInfo(isSelected: !state.isSelected));
                },
              ),
            ),
            MenuItem(
              iconPath: themeState.currentPuzzleTheme.goHomeAsset,
              tooltipMessage: MenuId.goHome.getTooltipMessage(context: context),
              menuId: MenuId.goHome,
              onPressed: () {
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
                  tooltipMessage: menuId?.getTooltipMessage(context: context) ?? context.l10n.extremeMode,
                  menuId: menuId,
                  isDisabled: state.isDisabled,
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
